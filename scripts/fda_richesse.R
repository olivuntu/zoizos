library(fda)

setwd("D:/PROJETS/PROJET_CIRCE/MS_BBS_shape_of_trends/data")

### data ###
load("species_richness_807r435s.RData")
RS1[RS1==0]=NA
RS2=RS1[,-c(1:4)]

### virer les routes avec un NA en 1970 et/ou 2011 (sinon on ne peut pas estimer le modèle sur les bords)
RS3=RS2[-which(is.na(RS2[,1])),]
RS4=RS3[-which(is.na(RS3[,ncol(RS3)])),]

### jeu de données sans aucun NA
misval=apply(RS2,1,function(x){sum(is.na(x))})
RS5=RS2[-which(misval>0),]

### récupérer les données environnementales + BCR pour ces routes
env=read.table("landscape_data_with_pca.txt",header=T,sep="\t")
env2=subset(env,comarrayname%in%rownames(RS5))
alti=read.csv("Buffer_1km_allroutes.csv",sep="\t") # voir Victor Cazalis pour origine des données d'altitude
alti2=subset(alti,Country=="USA")
alti2$code_country=840
alti2$comarrayname=paste(alti2$code_country,alti2$State,alti2$Route,sep="_")
env3=merge(env2,alti2,by="comarrayname",all=F)
head(alti2)


### explo de quelques routes ###

par(mfrow=c(3,3))
k=sample(1:807,1)
	plot(1:ncol(RS2),RS2[k,],type="b")

### Fonction de répartition ###

	# dernière année de données
s1=apply(RS2,1,function(x){max(which(!is.na(x)))})
plot(sort(s1),(1:length(s1))/length(s1),type="s")

### créer la base ###

myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=4)
myb=create.fourier.basis(rangeval=c(1970,2011),nbasis=21)


### créer l'objet qui contient les estimateurs des splines et des métadonnées ###
# la fonction Data2fd permet d'appliquer des contraintes, par ex le lambda permet de changer le lissage. 
RS4=as.matrix(RS4)
RS5=as.matrix(RS5) # sans NA
datamyb=Data2fd(y=t(RS5),argvals=1970:2011,basisobj=myb)

# eval.fd sert, à partir des coefficients, à rééchantillonner des points pour représenter les courbes
evalmyb=eval.fd(evalarg=1970:2011,fdobj=datamyb)

par(mfrow=c(2,2))
for(i in 1:4){
plot(1970:2011,RS5[i,])
lines(1970:2011,evalmyb[,i],col="red")
}

### Estimer une base optimale ###

MSE1=vector("numeric",length=36)
MSE2=vector("numeric",length=36)

for(j in 1:36){
	i=j+3
myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=i)
datamyb=Data2fd(y=t(RS5),argvals=1970:2011,basisobj=myb)
evalmyb=eval.fd(evalarg=1970:2011,fdobj=datamyb)

# MSE données
delta=vector("numeric",length=ncol(evalmyb))
for(k in 1:ncol(evalmyb)){
delta[k]=mean((evalmyb[,k]-t(RS5)[,k])^2)
}
MSE1[j]=mean(delta)

# MSE courbe estimée (variation autour de la courbe moyenne)
mean.myb=mean.fd(datamyb)
evalmean.myb=eval.fd(evalarg=1970:2011,fdobj=mean.myb)

delta2=vector("numeric",length=ncol(evalmyb))
for(k in 1:ncol(evalmyb)){
	delta2[k]=mean((evalmyb[,k]-evalmean.myb)^2)
}
MSE2[j]=mean(delta2)

}

# on représente la variation du MSE avec l'ordre : on veut minimiser l'écart à la courbe moyenne et l'écart à la courbe d'écart aux données
plot(1:36,MSE1,type="l")
lines(1:36,MSE2,type="l",lty="dashed")

# on choisit une base 5, correspondant à la cassure de ces courbes = meilleur compromis entre faible écart à la courbe moyenne et faible écart aux données

myb5=create.bspline.basis(rangeval=c(1970,2011),nbasis=5)
datamyb5=Data2fd(y=t(RS5),argvals=1970:2011,basisobj=myb5)
evalmyb5=eval.fd(evalarg=1970:2011,fdobj=datamyb5)

# plot d'une courbe
plot(1970:2011,RS5[50,],pch=21,bg="gray70",col="gray70")
lines(1970:2011,evalmyb5[,50],type="l",col="red")

#### ACP ###
mypca=pca.fd(datamyb5,nharm=2)

# courbes associée à chaque axe (ce ne sont pas des déformations de courbes mais des courbes réelles aux extrêmes des axes)
plot(mypca) 
# Trait plein = courbe moyenne, trait + = la déformation quand on va vers le (+) de l'axe, trait - = la déformation quand on va vers le (-)
# !!! si on ne normalise pas, on obtient un axe dominé par la richesse spécifique (= juste une translation de la courbe)
# en toute rigueur on doit diviser par l'intégrale de la courbe: on échantillonne finement la courbe, on calcule l'aire des trapèzes ainsi calculés, on a somme -> approximation convergente de l'intégrale de la courbe

# nuage de points
plot(mypca$scores) # 82% expliqué par le premier axe. 
abline(h=0)
abline(v=0)

### Normalisation ### 

# on prend le max de richesse pour chaque site et on divise les valeurs pour ce max --> limite les fluctuations
maxrs=apply(RS5,1,max)
RS6=RS5/maxrs

# on normalise de la même manière pour le temps
maxtps=2011
x=(1970:2011-1970)/max((1970:2011)-1970)

# refaire la fda avec les données normalisées
myb6=create.bspline.basis(rangeval=c(0,1),nbasis=5)
datamyb6=Data2fd(y=t(RS6),argvals=x,basisobj=myb6)
evalmyb6=eval.fd(evalarg=x,fdobj=datamyb6)

# pca
mypca=pca.fd(datamyb6,nharm=3)

# courbes extrêmes (et moyenne) qu'on a théoriquement aux extrémités des axes

par(mfrow=c(2,2))
plot(mypca)

# % var expliqué
barplot(100*mypca$varprop)


# mêmes courbes, en quantiles
qt1=quantile(mypca$scores[,1],p=c(0.025,0.25,0.5,0.75,0.975))
scr.qt1=which(mypca$scores[,1]<qt1[1])
eva.qt1=evalmyb6[,scr.qt1]
mcurve.qt1=apply(eva.qt1,1,mean)
plot(1970:2011,mcurve.qt1,type="l")

for(i in 2:length(qt1)){
	scr.qt1=which(mypca$scores[,1]<qt1[i])
	eva.qt1=evalmyb6[,scr.qt1]
	mcurve.qt1=apply(eva.qt1,1,mean)
	lines(1970:2011,mcurve.qt1,type="l",col=i+1)
}

# nuage de points
x11()
plot(mypca$scores) # 82% expliqué par le premier axe. 
abline(h=0)
abline(v=0)
