
    ## MULTIVARIATE
    #par(mfcol=c(5,4),mar=c(3,3,1,1))
    #apply(zhab[,!names(zhab)%in%c("num","ptec","alti","fal")],2,boxplot,hgr)
    ### define colors according to clusters (fgr object)
    cols <- rainbow(6, s = 0.8, v = 0.8)[hgr]

    # PCA
    # habitats
    pcah <- dudi.pca(zhab[, ! names(zhab) %in% c("num", "ptec", "alti", "fal")], scannf = FALSE, nf = 3)
    
    # species
	coas <- dudi.coa(zspp)#,scannf=FALSE,nf=3)
	coas2 <- dudi.coa(zspp[, names(zspp) != "FRPO"])#,scannf=FALSE,nf=3)
    par(mfcol = c(1,2))
    # plot species factorial map with colors indicating clusters (use pch=fgr without 'col'for black symobls)
    plot(coah$li[, 1:2], pch = 20, col = cols) # plot species coordinates (first two PC)
    abline(h = 0, v = 0) # draw horiz and vert axes
    s.corcircle(coas$co, xax = 1, yax = 2) # correlation circle (1st and 2nd axes)
    dev.copy(pdf,"figures/liverworts_cortico_PCA.pdf"); dev.off()

    # analyse habitats
    library(cluster)
    par(mfcol = c(1,2))    
    s.corcircle(pcah$co)
    tmp <- agnes(zhab[,-(1:3)],method = "ward")
    hgr <- cutree(tmp, df = 5) # returns index for habitat type
    tmp <- data.frame(hgr = hgr, zhab[,-(1:3)])
    tmp <- summaryBy(. ~ hgr, data = tmp, FUN = mean)
    tmp <- tmp / rowSums(tmp[,-1])
    cols <- terrain.colors(ncol(tmp) - 1)#,s=0.8,v=0.8)
    barplot(as.matrix(t(tmp[,-1])), beside = FALSE, col = cols)

	
    tmp <- pcaiv(coas2, zhab[, !names(zhab) %in% c("num","ptec","alti","fal")])

