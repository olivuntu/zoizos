
	#----------------------------------------------------------
	# DISTRIBUTION DE L'AVIFAUNE à LA Réunion (J. Tassin)
	# zspp : relevés d'abondance (pts d'écoute)
	# zhab : description des habitats
	# ztax : taxonomie,  statut, ...
	#
	#----------------------------------------------------------
	
	
	#library(vegan)
	library(rgdal)

## Coordonnées géographiques
	zjt <- read.ods("data/Gradient.ods")
	zjt <- zjt$Avifaune
	n  <-  intersect(names(zjt), names(zspp))
	#x <- attr(zjt, "data")[, c("ALTI", n)]
	x <- zjt[, c("ALTI", n)]
	x$S <- rowSums(x[, -1] != 0)
	x %<>% plyr::arrange(ALTI, S)
	x2 <- data.frame(alti = zhab$alti, zspp[, n])
	x2$S <- rowSums(x2[, -1] != 0)
	x2 %<>% arrange(alti, S)
	## 
	i <- paste(x$ALTI, x$S) %in% paste(x2$alti, x2$S) ## sites for publication
	x <- x[i, ]
	table(sapply(1:nrow(x), function(i) sum(x[i, ] == x2[i, ])))
	zjt$pub <- FALSE
	zjt$pub[i] <- TRUE
	zjt$ID <- NA; zjt$ID[i] <- rownames(x2)[i]
	coordinates(zjt) <- c("X", "Y")
	proj4string(zjt) <- CRS("+init=epsg:3727")
	zjt <- spTransform(zjt, CRS("+init=epsg:2975")) ## RGR92




	#writePointsShape(zjt, fn = "SIG.shp")

	## ajout des coordonnées au tableau de référence
	#zhab <- merge(zhab, data.frame(id = zjt$ID, coordinates(tmp)), by.x = 0, by.y = "id", all.x = TRUE)[, -1]		

