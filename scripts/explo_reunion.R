rm(list=ls())
setwd("C:/Users/E7240/Documents/Reunion")
library(ade4)

### data ### 

ois=read.table("OIS_modif29042020.txt",header=T,sep="\t",row.names=1)
mil=read.table("MIL_modif29042020.txt",header=T,sep="\t",row.names=1)

### exploration ###

# fréquence cumulée des habitats par point
fr.hab=apply(mil[,-1],1,"sum")
summary(fr.hab)
hist(fr.hab) #!! il y a des surfaces cumulées >100% sur certains points

# distribution des habitats
x11()
par(mfrow=c(5,3))
for(i in 2:16){
  hist(mil[,i])
}

# distribution altitude
dev.off()
hist(mil[,1])

### PCOA sur la matrice habitats  ###

# fréquences d'habitat
hab=prep.fuzzy(mil[,-1],col.blocks=ncol(mil)-1,labels="habita")

# altitude
alti=as.data.frame(mil[,1])
rownames(alti) =rownames(mil)
# matrice de dissimilarité de gower
ktab=ktab.list.df(list(alti,hab))
distmat=dist.ktab(ktab,type=c("Q","F"),option="scaledBYrange")

# PCOA
pco.habitat=dudi.pco(distmat,scannf=F,nf=5) # avec 5 axes environ 70% de variation expliquée

# eigenvalues
screeplot(pco.habitat)
100*cumsum(pco.habitat$eig)/sum(pco.habitat$eig)

# ordination des sites

library(RColorBrewer)
c1=findInterval(mil$ALTI,quantile(mil$ALTI,p=c(0.05,0.1,0.25,0.5,0.75,0.95,1)),all.inside=T)
c2=brewer.pal(9,"Reds")[c1]
library(adegraphics)

# axes 1 vs 2
s.label(pco.habitat$li,ppoints=list(alpha=0.8,col=c2),plabels=list(alpha=0,boxes=list(draw=F)))
sp=supcol(pco.habitat,mil)
s.arrow(sp$cosup,add=T,plabels=list(alpha=1,col="darkblue",cex=0.7,boxes=list(draw=F)))

# axes 1 vs 3
s.label(pco.habitat$li,xax=1,yax=3,ppoints=list(alpha=0.8,col=c2),plabels=list(alpha=0,boxes=list(draw=F)))
s.arrow(sp$cosup,xax=1,yax=3,add=T,plabels=list(alpha=1,col="darkblue",cex=0.7,boxes=list(draw=F)))

# axes 1 vs 4
s.label(pco.habitat$li,xax=1,yax=4,ppoints=list(alpha=0.8,col=c2),plabels=list(alpha=0,boxes=list(draw=F)))
s.arrow(sp$cosup,xax=1,yax=4,add=T,plabels=list(alpha=1,col="darkblue",cex=0.7,boxes=list(draw=F)))

# axes 1 vs 5
s.label(pco.habitat$li,xax=1,yax=5,ppoints=list(alpha=0.8,col=c2),plabels=list(alpha=0,boxes=list(draw=F)))
s.arrow(sp$cosup,xax=1,yax=5,add=T,plabels=list(alpha=1,col="darkblue",cex=0.7,boxes=list(draw=F)))

# PC1 = altitude
# PC2 = habitats exo vs natifs
# PC3 = 
# PC4 = 
# PC5 = 

### oiseaux ###

# AFC sur les abondances
afc.ois=dudi.coa(ois,scannf=F,nf=2)

# valeurs propres
cumsum(afc.ois$eig)/sum(afc.ois$eig)

# nuage de points
s.label(afc.ois$li)

# 2 points extrêmes
ois[c("ID187","ID225"),]
apply(ois,2,"max")

# position de ID187 et ID225 sur les gradients d'habitat
extr.ois=pco.habitat$li[c("ID187","ID225"),]

# ces deux sites sont les seuls à avoir FRPO (le Francolin)
par(mfrow=c(2,2))
plot(pco.habitat$li[,1],pco.habitat$li[,2],bty="n",pch=21,bg="gray70",col="gray70",xlab="PCO habitat 1",ylab="PCO habitat 2")
abline(h=0,lty="dashed")
abline(v=0,lty="dashed")
text(extr.ois[,1],extr.ois[,2],labels=rownames(extr.ois),col="darkred")

plot(pco.habitat$li[,1],pco.habitat$li[,3],bty="n",pch=21,bg="gray70",col="gray70",xlab="PCO habitat 1",ylab="PCO habitat 3")
abline(h=0,lty="dashed")
abline(v=0,lty="dashed")
text(extr.ois[,1],extr.ois[,3],labels=rownames(extr.ois),col="darkred")

plot(pco.habitat$li[,1],pco.habitat$li[,4],bty="n",pch=21,bg="gray70",col="gray70",xlab="PCO habitat 1",ylab="PCO habitat 4")
abline(h=0,lty="dashed")
abline(v=0,lty="dashed")
text(extr.ois[,1],extr.ois[,4],labels=rownames(extr.ois),col="darkred")

plot(pco.habitat$li[,1],pco.habitat$li[,5],bty="n",pch=21,bg="gray70",col="gray70",xlab="PCO habitat 1",ylab="PCO habitat 5")
abline(h=0,lty="dashed")
abline(v=0,lty="dashed")
text(extr.ois[,1],extr.ois[,5],labels=rownames(extr.ois),col="darkred")

### AFC oiseaux sans espèces sous-représentées ###

# abondances
sum(ois)
0.05*sum(ois)
0.01*sum(ois)

# fréquence
frq.cum=colSums(ois)/nrow(ois)
frq.cum[frq.cum<0.05]

# AFC sans les espèces vues sur moins de 5% des points

ois.com=ois[,names(frq.cum[frq.cum>0.05])]
afc.ois.com=dudi.coa(ois.com,scannf=F,nf=2)
cumsum(afc.ois.com$eig)/sum(afc.ois.com$eig)
s.label(afc.ois.com$li)

#---------#
### FDA ###
#---------#

library(fda)

### estimation des courbes pour toutes les espèces ###

# réordonner par altitude
oisb=as.matrix(ois)
alti2=data.frame(rownames(alti),alti[,1])
alti2=alti2[order(alti2[,2]),]
alti3=as.numeric(alti2[,2])
names(alti3)=alti2[,1]
oisc=oisb[names(alti3),]

### Estimer la base optimale ###

MSE1=vector("numeric",length=36)
MSE2=vector("numeric",length=36)

for(j in 1:36){
  i=j+3
  myb=create.bspline.basis(rangeval=range(alti3),nbasis=i)
  datamyb=Data2fd(y=oisc,argvals=alti3,basisobj=myb)
  evalmyb=eval.fd(evalarg=alti3,fdobj=datamyb)
  
  # MSE données
  delta=vector("numeric",length=ncol(evalmyb))
  for(k in 1:ncol(evalmyb)){
    delta[k]=mean((evalmyb[,k]-oisc[,k])^2)
  }
  MSE1[j]=mean(delta)
  
  # MSE courbe estimée (variation autour de la courbe moyenne)
  mean.myb=mean.fd(datamyb)
  evalmean.myb=eval.fd(evalarg=alti3,fdobj=mean.myb)
  
  delta2=vector("numeric",length=ncol(evalmyb))
  for(k in 1:ncol(evalmyb)){
    delta2[k]=mean((evalmyb[,k]-evalmean.myb)^2)
  }
  MSE2[j]=mean(delta2)
  
}

# on représente la variation du MSE avec l'ordre : on veut minimiser l'écart à la courbe moyenne et l'écart à la courbe d'écart aux données
plot(1:36,MSE1,type="l",ylim=c(0,4))
lines(1:36,MSE2,type="l",lty="dashed") # la représentation n'est de toute façon pas très bonne, probablement à cause des patterns de réponse à l'altitude mal marqués

# faute de mieux on reste sur une base 4


### Réestimer sur données normalisées par le max de chaque espèce ###

# normaliser les abondances
oiscb=log(oisc+1)
maxab=apply(oiscb,2,max)
oisd=oiscb/maxab

# normaliser les altitudes
alti4=(alti3-min(alti3))/max((alti3)-min(alti3))

# on refait les courbes
myb6=create.bspline.basis(rangeval=c(0,1),nbasis=4)
datamyb6=Data2fd(y=oisd,argvals=alti4,basisobj=myb6)
evalmyb6=eval.fd(evalarg=alti4,fdobj=datamyb6)


# plot d'une courbe
plot(alti4,oisd[,10],pch=21,bg="gray70",col="gray70",xlab="altitude",ylab="log(abondance)",main=colnames(oisd)[10])
lines(alti4,evalmyb6[,10],type="l",col="red")

# courbes toutes espèces
dev.off()
plot(x=0,y=0,xlim=c(0,1),ylim=c(0,1),type="n",xlab="altitude",ylab="estimation log(abondance)")
for(i in 1:ncol(evalmyb6)){
  lines(alti4,evalmyb6[,i],type="l",col="red")
}

# FPCA
mypca=pca.fd(datamyb6,nharm=2)

# courbes extrêmes (et moyenne) qu'on a théoriquement aux extrémités des axes
par(mfrow=c(1,2))
plot(mypca)

100*mypca$varprop

# axe 1  en quantiles
par(mfrow=c(1,2))
qt1=quantile(mypca$scores[,1],p=c(0.05,0.25,0.5,0.75,0.95))
scr.qt1=which(mypca$scores[,1]<qt1[1])
eva.qt1=evalmyb6[,scr.qt1]
mcurve.qt1=apply(eva.qt1,1,mean)
plot(alti4,mcurve.qt1,type="l")

for(i in 2:length(qt1)){
  scr.qt1=which(mypca$scores[,1]<qt1[i])
  eva.qt1=evalmyb6[,scr.qt1]
  mcurve.qt1=apply(eva.qt1,1,mean)
  lines(alti4,mcurve.qt1,type="l",col=i+1)
}

# axe 2  en quantiles
qt2=quantile(mypca$scores[,2],p=c(0.05,0.25,0.5,0.75,0.95))
scr.qt2=which(mypca$scores[,2]<qt2[1])
eva.qt2=evalmyb6[,scr.qt2]
mcurve.qt2=apply(eva.qt2,1,mean)
plot(alti4,mcurve.qt2,type="l")

for(i in 2:length(qt2)){
  scr.qt2=which(mypca$scores[,2]<qt2[i])
  eva.qt2=evalmyb6[,scr.qt2]
  mcurve.qt2=apply(eva.qt2,1,mean)
  lines(alti4,mcurve.qt2,type="l",col=i+1)
}


# nuage de points
rownames(mypca$scores)=colnames(oisd)
dev.off()
plot(mypca$scores,type="n",xlab="PC1",ylab="PC2",xlim=c(-2,0.7),ylim=c(-0.5,0.5))
abline(h=0,lty="dashed")
abline(v=0,lty="dashed")
text(mypca$scores,labels=rownames(mypca$scores))
