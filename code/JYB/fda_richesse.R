library(fda)

setwd("D:/PROJETS/PROJET_CIRCE/MS_BBS_shape_of_trends/data")

### data ###
load("species_richness_807r435s.RData")
RS1[RS1==0]=NA
RS2=RS1[,-c(1:4)]

### virer les routes avec un NA en 1970 et/ou 2011 (sinon on ne peut pas estimer le mod�le sur les bords)
RS3=RS2[-which(is.na(RS2[,1])),]
RS4=RS3[-which(is.na(RS3[,ncol(RS3)])),]

### jeu de donn�es sans aucun NA
misval=apply(RS2,1,function(x){sum(is.na(x))})
RS5=RS2[-which(misval>0),]

### r�cup�rer les donn�es environnementales + BCR pour ces routes
env=read.table("landscape_data_with_pca.txt",header=T,sep="\t")
env2=subset(env,comarrayname%in%rownames(RS5))
alti=read.csv("Buffer_1km_allroutes.csv",sep="\t") # voir Victor Cazalis pour origine des donn�es d'altitude
alti2=subset(alti,Country=="USA")
alti2$code_country=840
alti2$comarrayname=paste(alti2$code_country,alti2$State,alti2$Route,sep="_")
env3=merge(env2,alti2,by="comarrayname",all=F)
head(alti2)


### explo de quelques routes ###

par(mfrow=c(3,3))
k=sample(1:807,1)
	plot(1:ncol(RS2),RS2[k,],type="b")

### Fonction de r�partition ###

	# derni�re ann�e de donn�es
s1=apply(RS2,1,function(x){max(which(!is.na(x)))})
plot(sort(s1),(1:length(s1))/length(s1),type="s")

### cr�er la base ###

myb=create.bspline.basis(rangeval=c(1970,2011),nbasis=4)
myb=create.fourier.basis(rangeval=c(1970,2011),nbasis=21)


### cr�er l'objet qui contient les estimateurs des splines et des m�tadonn�es ###
# la fonction Data2fd permet d'appliquer des contraintes, par ex le lambda permet de changer le lissage. 
RS4=as.matrix(RS4)
RS5=as.matrix(RS5) # sans NA
datamyb=Data2fd(y=t(RS5),argvals=1970:2011,basisobj=myb)

# eval.fd sert, � partir des coefficients, � r��chantillonner des points pour repr�senter les courbes
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

# MSE donn�es
delta=vector("numeric",length=ncol(evalmyb))
for(k in 1:ncol(evalmyb)){
delta[k]=mean((evalmyb[,k]-t(RS5)[,k])^2)
}
MSE1[j]=mean(delta)

# MSE courbe estim�e (variation autour de la courbe moyenne)
mean.myb=mean.fd(datamyb)
evalmean.myb=eval.fd(evalarg=1970:2011,fdobj=mean.myb)

delta2=vector("numeric",length=ncol(evalmyb))
for(k in 1:ncol(evalmyb)){
	delta2[k]=mean((evalmyb[,k]-evalmean.myb)^2)
}
MSE2[j]=mean(delta2)

}

# on repr�sente la variation du MSE avec l'ordre : on veut minimiser l'�cart � la courbe moyenne et l'�cart � la courbe d'�cart aux donn�es
plot(1:36,MSE1,type="l")
lines(1:36,MSE2,type="l",lty="dashed")

# on choisit une base 5, correspondant � la cassure de ces courbes = meilleur compromis entre faible �cart � la courbe moyenne et faible �cart aux donn�es

myb5=create.bspline.basis(rangeval=c(1970,2011),nbasis=5)
datamyb5=Data2fd(y=t(RS5),argvals=1970:2011,basisobj=myb5)
evalmyb5=eval.fd(evalarg=1970:2011,fdobj=datamyb5)

# plot d'une courbe
plot(1970:2011,RS5[50,],pch=21,bg="gray70",col="gray70")
lines(1970:2011,evalmyb5[,50],type="l",col="red")

#### ACP ###
mypca=pca.fd(datamyb5,nharm=2)

# courbes associ�e � chaque axe (ce ne sont pas des d�formations de courbes mais des courbes r�elles aux extr�mes des axes)
plot(mypca) 
# Trait plein = courbe moyenne, trait + = la d�formation quand on va vers le (+) de l'axe, trait - = la d�formation quand on va vers le (-)
# !!! si on ne normalise pas, on obtient un axe domin� par la richesse sp�cifique (= juste une translation de la courbe)
# en toute rigueur on doit diviser par l'int�grale de la courbe: on �chantillonne finement la courbe, on calcule l'aire des trap�zes ainsi calcul�s, on a somme -> approximation convergente de l'int�grale de la courbe

# nuage de points
plot(mypca$scores) # 82% expliqu� par le premier axe. 
abline(h=0)
abline(v=0)

### Normalisation ### 

# on prend le max de richesse pour chaque site et on divise les valeurs pour ce max --> limite les fluctuations
maxrs=apply(RS5,1,max)
RS6=RS5/maxrs

# on normalise de la m�me mani�re pour le temps
maxtps=2011
x=(1970:2011-1970)/max((1970:2011)-1970)

# refaire la fda avec les donn�es normalis�es
myb6=create.bspline.basis(rangeval=c(0,1),nbasis=5)
datamyb6=Data2fd(y=t(RS6),argvals=x,basisobj=myb6)
evalmyb6=eval.fd(evalarg=x,fdobj=datamyb6)

# pca
mypca=pca.fd(datamyb6,nharm=3)

# courbes extr�mes (et moyenne) qu'on a th�oriquement aux extr�mit�s des axes

par(mfrow=c(2,2))
plot(mypca)

# % var expliqu�
barplot(100*mypca$varprop)


# m�mes courbes, en quantiles
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
plot(mypca$scores) # 82% expliqu� par le premier axe. 
abline(h=0)
abline(v=0)
