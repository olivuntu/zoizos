
	#----------------------------------------------------------
	# DISTRIBUTION DE L'AVIFAUNE à LA Réunion (J. Tassin)
	# zspp : relevés d'abondance (pts d'écoute)
	# zhab : description des habitats
	# ztax : taxonomie,  statut, ...
	#
	#----------------------------------------------------------
	
	
	#library(vegan)
	library(rgdal)

## ---- data
	zspp <- read.table("data/avifaune_gradient_spp.csv", header = TRUE, sep = ", ", row.names = 2)[, -1]
	zspp <- zspp[, colSums(zspp)!= 0]
	zhab <- read.table("data/avifaune_gradient_habitats.csv", header = TRUE, row.names = 1, sep = ";", dec = ", ")
	## factor for altitudinal bands
	zhab$fal <- cut(zhab$alti, breaks = seq(0, 2900, by = 100));
	levels(zhab$fal) <- seq(0, 2900, by = 100)#c(seq(100, 1900, by = 200), 2200, 2200, 2600, 2600, 2600)
	zhab$fal2 <- cut(zhab$alti, breaks = seq(0, 2900, by = 100));
	levels(zhab$fal2) <- c(rep(seq(100, 1100, by = 200), each = 2), seq(1250, 1550, by = 100), 1700, 1700, 1900, 1900, rep(2200, 4), rep(2600, 5))
	rownames(zhab) <- rownames(zspp)
	ztax <- read.table("data/species.csv", header = TRUE, sep = ";")
	ztax$code <- sapply(as.character(ztax$Species), function(x) paste(toupper(substring(strsplit(x, " ")[[1]], 1, 2)), collapSerow = ""))
	## codes espèces
	zn  <-  ztax$code[ztax$Status == "N"]
	zn  <-  zn[zn%in%names(zspp)]
	ze  <-  ztax$code[ztax$Status == "E"]
	ze  <-  ze[ze%in%names(zspp)]
	
## ----
# Variables explicatives
	
	## sampling sites
	pts  <-  zhab
	coordinates(pts)  <-  c("X", "Y")
	proj4string(pts)  <-  CRS("+init=epsg:2975") ## RGR92
	pts@data  <-  pts@data[, ! names(pts@data) %in% c("X", "Y")]
	source("~/Boulot/code/R/add_enviro.r")
	## move object back to current environment
	move(pts, ., 0/zoizos)
	cd(0/zoizos)
	varz  <-  pts
	varz@data  <-  droplevels(varz@data)	
	i  <-  sapply(varz@data, class) == "list"
	varz@data[, i]  <-  sapply(varz@data[, i],  as.character)



## ---- ech
## Echantillonnage

	par(mfcol = c(3, 2))
	hist(zhab$alti)
	## RichesSerow,  diversité,  abondance
	S <- rowSums(zspp!= 0)
	## Native species
	n <- colnames(zspp)%in%ztax$code[ztax$Status == "N"]
	Snrow <- rowSums(zspp[, n]!= 0)
	tmp <- data.frame(matrix(unlist(tapply(Snrow, zhab$fal, FUN = function(x) c(mean(x), sd(x), length(x)))), byrow = TRUE, ncol = 3))
	colnames(tmp) <- c("m", "sd", "n")
	b <- barplot(tmp$m, names = seq(0, 2800, by = 100))	
	arrows(b, tmp$m + tmp$sd/sqrt(tmp$n), b, tmp$m,  angle = 90,  code = 1, length = 0.05)        
	## exotic species
	e <- colnames(zspp) %in% ztax$code[ztax$Status == "E"]
	Serow <- rowSums(zspp[, e]!= 0)
	plot(Serow ~ zhab$alti)
		
		
		#Dn <- exp(diversity(zspp[, n]))#apply(zspp, 1, function(x) exp(sum(x[x!= 0]*log(x[x!= 0]))))
		#De <- exp(diversity(zspp[, e]))#apply(zspp, 1, function(x) exp(sum(x[x!= 0]*log(x[x!= 0]))))
		#plot(Dn~zhab$alti)
		#points(De~zhab$alti, pch = " + ")
		#A <- apply(zspp, 1, sum)
		#plot(A~zhab$alti)
		#  
		### occurrence espèces
		#occ <- colSums(zspp)/sum(zspp)
		#hist(occ)
    }

## ---- spatial
## Coordonnées géographiques
	zjt <- read.ods("data/Gradient.ods")
	n  <-  intersect(names(zjt), names(zspp))
	#x <- attr(zjt, "data")[, c("ALTI", n)]
	x <- zjt[, c("ALTI", n)]
	x$S <- rowSums(x[, -1] != 0)
	x <- orderBy(~ ALTI + S, data = x)
	x2 <- data.frame(alti = zhab$alti, zspp[, n])
	x2$S <- rowSums(x2[, -1] != 0)
	x2 <- orderBy(~ alti + S, data = x2)
	## 
	i <- paste(x$ALTI, x$S) %in% paste(x2$alti, x2$S) ## sites for publication
	x <- x[i, ]
	table(sapply(1:nrow(x), function(i)sum(x[i, ] == x2[i, ])))
	zjt$pub <- FALSE
	zjt$pub[i] <- TRUE
	zjt$ID <- NA; zjt$ID[i] <- rownames(x2)
	coordinates(zjt) <- c("X", "Y")
	proj4string(zjt) <- CRS("+init=epsg:3727")
	zjt <- spTransform(zjt, CRS("+init=epsg:2975")) ## RGR92
	#writePointsShape(zjt, fn = "SIG.shp")

	## ajout des coordonnées au tableau de référence
	#zhab <- merge(zhab, data.frame(id = zjt$ID, coordinates(tmp)), by.x = 0, by.y = "id", all.x = TRUE)[, -1]		

