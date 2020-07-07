#########################################################
## Script d'analyse des données de RS Amérique du Nord ##
######################################################### Morgan Godard 30/03/2018

#### Packages nécessaires ####
require(fda)

#### Chargement des données ####
setwd("C:/Users/E7240/Documents/DATA/MS_BBS_shape_of_trends/data")
load("species_richness_807r435s.RData")
RS1[RS1==0]=NA
RS2=RS1[,-c(1:4)]

#### Retrait des routes avec des NA aux bords empêchant l'approximation ####
RS3=RS2[-which(is.na(RS2[,1])),]
RS4=RS3[-which(is.na(RS3[,ncol(RS3)])),]

#### Travail sous forme de list afin de supprimer les NAs ####
RS5=list()
for(i in 1:nrow(RS4))
{
  if (sum(is.na(RS4[i,]))==0) {RS5[[i]]=RS4[i,]}
  else if (sum(is.na(RS4[i,]))!=0) {RS5[[i]]=RS4[i,-which(is.na(RS4[i,]))]}
}


#### Création de la base #####
myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=4)

#### Approximation des données #####
Tot.fd=Data2fd(as.numeric(names(RS5[[1]])),as.numeric(RS5[[1]]),myb)
for (i in 2:length(RS5))
{
  A=Data2fd(as.numeric(names(RS5[[i]])),as.numeric(RS5[[i]]),myb)
  Tot.fd$coefs=cbind(Tot.fd$coefs,A$coefs)
  
}

#### Estimation du nombre de bases optimale ####
MSE1=vector("numeric",length=36)
MSE2=vector("numeric",length=36)


for(j in 1:36){
  i=j+3
  myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=i)
  Tot.fd=Data2fd(as.numeric(names(RS5[[1]])),as.numeric(RS5[[1]]),myb)
  
  for (i in 2:length(RS5))
  {
    A=Data2fd(as.numeric(names(RS5[[i]])),as.numeric(RS5[[i]]),myb)
    Tot.fd$coefs=cbind(Tot.fd$coefs,A$coefs)
    
  }
  
  delta=vector("numeric",length=ncol(Tot.fd$coefs))
  for(k in 1:ncol(Tot.fd$coefs)){
    fd.cal=Tot.fd
    fd.cal$coefs=Tot.fd$coefs[,k]
    evalmyb=eval.fd(evalarg=as.numeric(names(RS5[[k]])),fdobj=fd.cal)
    delta[k]=mean((evalmyb-RS5[[k]]))^2
   }
  MSE1[j]=mean(delta)
  
  # MSE courbe estim?e (variation autour de la courbe moyenne)
  
  
  
  mean.myb=mean.fd(Tot.fd)
  evalmyb=eval.fd(evalarg=1970:2011,fdobj=Tot.fd)
  evalmean.myb=eval.fd(evalarg=1970:2011,fdobj=mean.myb)

  delta2=vector("numeric",length=ncol(evalmyb))
  for(k in 1:ncol(evalmyb)){
    delta2[k]=mean((evalmyb[,k]-evalmean.myb)^2)
  }
  MSE2[j]=mean(delta2)
  
}

#### Approximation avec 5 bases ####
myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=5)
Tot.fd=Data2fd(as.numeric(names(RS5[[1]])),as.numeric(RS5[[1]]),myb)
for (i in 2:length(RS5))
{
  A=Data2fd(as.numeric(names(RS5[[i]])),as.numeric(RS5[[i]]),myb)
  Tot.fd$coefs=cbind(Tot.fd$coefs,A$coefs)
  
}
eval.tot=eval.fd(evalarg=1970:2011,fdobj=Tot.fd)

x=rnorm(100,0,1)
y=3+0.2*x
y2=exp(y)
y3=rpois(100,y2)

m1=lm(y3~x)
m2=glm(y3~x,family=poisson)
#m3=lm(log(y3)~x)

m1p=predict(m1)
m2p=predict(m2,type="response")
m2c=cbind(x,m1p,m2p)
m2c=m2c[order(m2c[,"x"]),]

plot(m2c[,1],m2c[,2],xlim=range(x),ylim=range(m2c[,-1]),type="l")
lines(m2c[,1],m2c[,3],col="red")


## Génération aléatoire de courbes
np=sample(1:ncol(Tot.fd$coefs),1)
plot(as.numeric(names(RS5[[np]])),RS5[[np]])
points(1970:2011,eval.tot[,np],type="l",col="red")


#### ACP fonctionnelle ####
mypca=pca.fd(Tot.fd,nharm=5)

## Plot du nuage de points des observations
plot(mypca$scores[,1:2]) 

## Plot de la déformation selon les différents axes
plot(mypca)

## Nécessite de normaliser la richesse spécifique car l'axe dominant (PC1) contient 84.6% de la variabilité et ne représente qu'une déformation liée à la richesse spécifique moyenne.
RS5_n=lapply(RS5,function(x) x/max(x))


## On approxime de nouveau
myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=5)
Tot.fd=Data2fd(as.numeric(names(RS5_n[[1]])),as.numeric(RS5_n[[1]]),myb)
for (i in 2:length(RS5_n))
{
  A=Data2fd(as.numeric(names(RS5_n[[i]])),as.numeric(RS5_n[[i]]),myb)
  Tot.fd$coefs=cbind(Tot.fd$coefs,A$coefs)
  
}

## courbe moyenne et �cart type
cmoy=mean.fd(Tot.fd)
plot(cmoy,main="courbe moyenne",ylim=c(0,1))
csd=sd.fd(Tot.fd)
lines(1970:2011,eval.fd(evalarg=1970:2011,csd),col="red")

par(mfrow=c(1,2))
plot(cmoy,main="courbe moyenne")
plot(csd,main="courbe �cart type")

## ACP fonctionnelle
mypca=pca.fd(Tot.fd,nharm=5)

## aspect spatial
xy=read.table("centroid_807_routes.txt",header=T,sep="\t")
rownames(xy)=xy[,1]
xy=xy[rownames(RS4),]
scores=mypca$scores
rownames(scores)=rownames(RS4)
xyscores=merge(xy,scores,by=0,all=F)

alti1=read.csv("Buffer_1km_allroutes.csv",header=T,sep="\t")
alti2=subset(alti1,Country=="USA")
alti2$coderoute=paste(840,alti2$RtCode,sep="_")
fda.spat=merge(xyscores,alti2,by="coderoute",all=F)

library(RColorBrewer)
c1=findInterval(fda.spat$V1,quantile(fda.spat$V1,p=c(0.025,0.10,0.25,0.5,0.75,0.975)))
c2=brewer.pal(9,"Reds")[c1]
plot(fda.spat$mean_X,fda.spat$mean_Y,pch=21,bg=c2,col=c2)
c1=findInterval(fda.spat$V2,quantile(fda.spat$V2,p=c(0.025,0.10,0.25,0.5,0.75,0.975)))
c2=brewer.pal(9,"Reds")[c1]
plot(fda.spat$mean_X,fda.spat$mean_Y,pch=21,bg=c2,col=c2,cex=1.5)
c1=findInterval(fda.spat$V3,quantile(fda.spat$V3,p=c(0.025,0.10,0.25,0.5,0.75,0.975)))
c2=brewer.pal(9,"Reds")[c1]
plot(fda.spat$mean_X,fda.spat$mean_Y,pch=21,bg=c2,col=c2,cex=1.5)

plot(fda.spat$alt_mean,fda.spat$V3)
