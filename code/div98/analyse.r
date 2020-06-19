
    ##################################
    ## ANALYSE DONNEES AVIFAUNE
    ##
    
    #library(vegan)
    #library(Hmisc)
	library(gam)

    ## richesse par bande d'altitude
    x <- splitBy(~ fal, data = data.frame(zspp, fal = zhab$fal))
    Sn <- colSums(sapply(x, function(y) as.numeric(apply(y[, zn] != 0, 2, any))))
    Se <- colSums(sapply(x, function(y) as.numeric(apply(y[, ze] != 0, 2, any))))


    ## GAM model
    tmp <- data.frame(S = Sn+Se, alti = as.numeric(names(Sn)))
    modS <- gam(S~s(alti,df=5),data=tmp,family=poisson)
    tmp <- data.frame(S=Sn,alti=as.numeric(names(Sn)))
    modSn <- gam(S~s(alti,df=4),data=tmp,family=poisson)
    tmp <- data.frame(S=Se,alti=as.numeric(names(Sn)))
    modSe <- gam(S~s(alti,df=4),data=tmp,family=poisson)

	## Beta diversity
	tmp <- beta.pair(matrix(as.numeric(zspp[,ze]!=0),ncol=22))
	tmp <- lapply(tmp,as.matrix)
    
    ## Elevation distance
    dalt <- as.matrix(dist(zhab$alti))
    dgeo <- as.matrix(dist(zhab[,c("X","Y")]))

    ##
    plot(tmp$beta.sim~dgeo)
    plot(tmp$beta.sim~tmp$beta.sne)
    plot(tmp$beta.sim~tmp$beta.sor)
    plot(tmp$beta.sne~tmp$beta.sor)

    dat <- data.frame(sne=as.vector(tmp$beta.sne),sim=as.vector(tmp$beta.sim))
    ggplot(dat, aes(sne, sim)) + geom_point() + stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE, adjust=1/5)



	## site richness
	tmp <- data.frame(zhab[,c("X","Y")])
	tmp$Sn <- rowSums(matrix(as.numeric(zspp[,zn]!=0),nrow=363))
	tmp$Se <- rowSums(matrix(as.numeric(zspp[,ze]!=0),nrow=363))
	coordinates(tmp)<-c("X","Y")
	proj4string(tmp)<-CRS("+init=epsg:2975") ## RGR92
	

    ## RANDOM ASSEMBLAGES
	## Both individuals and samples are shuffled
	
#	 ## Both margins fixed
#    zpermb<-permatfull(zspp,fixedmar="both",shuffle="both",strata=NULL,mtype="count",times=1999)
#    ## Native species richness
#    xnb<-sapply(zpermb$perm,function(x)
#		      {
#			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))    
#			    Sn<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="N"]!=0,2,any))))
#		      })
#    xnb<-cbind(as.numeric(names(Sn)),t(apply(xnb,1,quantile,probs=c(0.025,0.975))))
#    xnb<-xnb[order(xnb[,1]),]
#    ## Exotic species richness
#    xeb<-sapply(zpermb$perm,function(x)
#		      {
#			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))
#			    Se<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="E"]!=0,2,any))))
#		      })
#    xeb<-cbind(as.numeric(names(Se)),t(apply(xeb,1,quantile,probs=c(0.025,0.975))))
#    xeb<-xeb[order(xeb[,1]),]
#    
#    ## Column margins fixed (only species abundance preserved)
#    zpermc<-permatfull(zspp,fixedmar="columns",shuffle="both", strata=NULL,mtype="count",times=1999)
     ## Native
#    xnc<-sapply(zpermc$perm,function(x)
#		      {
#			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))    
#			    Sn<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="N"]!=0,2,any))))
#		      })
#    xnc<-cbind(as.numeric(names(Sn)),t(apply(xnc,1,quantile,probs=c(0.025,0.975))))
#    xnc<-xnc[order(xnc[,1]),]
#    ## Exotic
#    xec<-sapply(zpermc$perm,function(x)
#		      {
#			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))
#			    Se<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="E"]!=0,2,any))))
#		      })
#    xec<-cbind(as.numeric(names(Se)),t(apply(xec,1,quantile,probs=c(0.025,0.975))))
#    xec<-xec[order(xec[,1]),]


    ## INDIVIDUAL BASED RANDOM SAMPLING	
	 ## Both margins fixed
    zpermbi<-permatfull(zspp,fixedmar="both",shuffle="both",strata=NULL,mtype="count",times=1999)
    ## Native species richness
    xnbi<-sapply(zpermbi$perm,function(x)
		      {
			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))    
			    Sn<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="N"]!=0,2,any))))
		      })
    xnbi<-cbind(as.numeric(names(Sn)),t(apply(xnbi,1,quantile,probs=c(0.025,0.975))))
    xnbi<-xnbi[order(xnbi[,1]),]
    ## Exotic species richness
    xebi<-sapply(zpermbi$perm,function(x)
		      {
			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))
			    Se<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="E"]!=0,2,any))))
		      })
    xebi<-cbind(as.numeric(names(Se)),t(apply(xebi,1,quantile,probs=c(0.025,0.975))))
    xebi<-xebi[order(xebi[,1]),]
    
    ## Column margins fixed (only species abundance preserved)
    zpermci<-permatfull(zspp,fixedmar="columns",shuffle="both", strata=NULL,mtype="count",times=1999)
     # Native
    xnci<-sapply(zpermci$perm,function(x)
		      {
			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))    
			    Sn<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="N"]!=0,2,any))))
		      })
    xnci<-cbind(as.numeric(names(Sn)),t(apply(xnci,1,quantile,probs=c(0.025,0.975))))
    xnci<-xnci[order(xnci[,1]),]
    ## Exotic
    xeci<-sapply(zpermci$perm,function(x)
		      {
			    x<-splitBy(~fal,data=data.frame(x,fal=zhab$fal))
			    Se<-colSums(sapply(x,function(y)as.numeric(apply(y[,ztax$Status=="E"]!=0,2,any))))
		      })
    xeci<-cbind(as.numeric(names(Se)),t(apply(xeci,1,quantile,probs=c(0.025,0.975))))
    xeci<-xeci[order(xeci[,1]),]






#    library(picante)
#    tmp<-lapply(1:100,function(x) x=randomizeMatrix(zspp,null.model="frequency"))
#    Dr<-sapply(tmp,function(y) apply(y,1,function(x) exp(sum(x[x!=0]*log(x[x!=0])))))
#	    plot(D~zhab$alti)
#	    A<-apply(zspp,1,sum)
#	    
#	    
#    tmp<-lapply(1:100,function(x) x=permatfull(zspp,null.model="richness"))
#    
#    tmp<-permatfull(zspp,fixedmar="columns",mtype="count")
#    
#    Dr<-lapply(tmp,function(y) apply(y,1,function(x) exp(sum(x[x!=0]*log(x[x!=0])))))
#    plot(D~zhab$alti)
#    A<-apply(zspp,1,sum)
    

    ### ELEVATIONAL RANGE ANALYSIS
    ### mean elevation
    #era<-data.frame(t(sapply(zspp,function(x) c(sum(x!=0),mean(zhab$alti[x!=0]),sum(x*zhab$alti)/sum(x),range(zhab$alti[x!=0])))))
    #names(era)<-c("occ","malt","wmalt","min","max")
    #era$ampl<-era$max-era$min
    #era<-merge(era,ztax[,c("code","Species","Status")],by.x=0,by.y="code")
    #names(era)[1]<-"code"
    ### propotion of gradient occupied
    #era$prop<-round(era$ampl/2860*100)
    #latex(era,cdec=c(0,rep(0,5)),caption="Summary of species elevation patterns",ctable=FALSE,label="era",file="tables/zoizos_era.tex")
    #
    ### tests
    #tmp<-era[era$occ>=5,c("code","Status","min","max","malt","wmalt","ampl")]    
    #wilcox.test(wmalt~Status,data=tmp,correct=TRUE)
    #bartlett.test(wmalt~Status,data=era)
    #wilcox.test(ampl~Status,data=tmp,correct=TRUE)
    #bartlett.test(ampl~Status,data=era)
    #wilcox.test(min~Status,data=era,exact=FALSE)
    #bartlett.test(min~Status,data=era)
    #wilcox.test(max~Status,data=tmp,exact=FALSE)
    #bartlett.test(max~Status,data=era)
    #
    #
    #
    #wilcox.test(malt~Status,data=tmp)
    #bartlett.test(malt~Status,data=era)
    #
    #
    #
    #boxplot(wmalt~Status,data=tmp)
    #boxplot(min~Status,data=tmp)
    #
    #wilcox_test(ampl~Status,data=tmp)
		
		


    #alti<-seq(350,2350,by=200)	
    ### find elevation of maximum occurrence 
    #emo<-apply(occ[i,s],1,function(x) alti[which(x==max(x))])
    ### 7 species with two maxima > retain first : arbitrary !!
    #emo[sapply(emo,length)>1]=sapply(emo[sapply(emo,length)>1],function(x) x[[1]])
    #emo<-unlist(emo)
    ### elevational range
    #elr<-apply(occ[i,s],1,function(x) max(alti[x!=0])-min(alti[x!=0]))    

 
 
	## BETA DIVERSITY
	tmp <- beta.multi(matrix(as.numeric(zspp!=0),ncol=ncol(zspp)))
	
	tmp <- beta.pair(matrix(as.numeric(zspp!=0),ncol=ncol(zspp)))
		d <- as.matrix(dist(zhab$alti))
		d <- matrix(as.character(cut(d,breaks=seq(0,2900,by=100))),ncol=ncol(d))
	plot(as.matrix(d),tmp$sor)
	
	boxplot(as.vector(as.matrix(tmp$beta.sort))~as.vector(d))
	