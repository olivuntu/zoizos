
###################################################
## Species richness in BIRDS, Reunion Island
##
##
###################################################

library(scales)

## distribution of altitude where species present
## ---- boxalti
	x <- data.frame(sapply(zspp, function(x) {x[x != 0] <- zhab$alti[x != 0]; x}))
	x <- stack(x)
	x$values[x$values == 0] <- NA
	x$ind <- reorder(x$ind, x$values, FUN = median, na.rm = TRUE)
	par(mar = c(3, 6, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
	tmp <- ztax
	rownames(tmp) <- paste(tmp$code, " (", era$occ, ")", sep = "")
	tmp <- tmp[levels(x$ind), ]
	levels(tmp$Status) <- c(rgb(0.8, 0, 0.4), rgb(0, 0.4, 0.8))
	boxplot(values~ind, data = x, names = rownames(tmp), xlab = "Elevation (m)", horizontal = TRUE, pch = 19, cex = 0.8, boxfill = as.character(tmp$Status))


## ---- boxes
	tmp <- melt(era, measure = c("wmalt", "ampl", "max", "min"))
	levels(tmp$variable) <- c("Weighted mid-point (m)", "Amplitude (m)", "Maxium (m)", "Minimum (m)")
	ggplot(tmp, aes(x = Status, y = value)) + geom_point(position = position_jitter(width = 0.1), size = 3, alpha = 0.4) + stat_summary(fun.data = "mean_se", aes(colour = Status), geom = "pointrange", size = 2) + facet_wrap(~variable, scales = "free")#+ geom_boxplot() 


## ---- boxwmalt
	par(mar = c(3, 5, 0.5, 0.5), mgp = c(2, 0.5, 0), cex = 1.2, tck = 0.03, las = 1)
	boxplot(wmalt ~ Status, data = era[era$occ >= 5, ], names = c("Exotic", "Native"), ylab = "Weighted mid-point (m)", boxfill = c(rgb(0.8, 0, 0.4), rgb(0, 0.4, 0.8)), outline = 0, ylim = c(0, 3000))
	col <- as.numeric(era$occ >= 5)
	beeswarm(wmalt~Status, data = era, add = TRUE, pch = 21, pwbg = col, cex = 1.2)

## ---- boxampl
par(mar = c(3, 5, 0.5, 0.5), mgp = c(2, 0.5, 0), cex = 1.2, tck = 0.03, las = 1)
	boxplot(ampl~Status, data = era[era$occ >= 5, ], names = c("Exotic", "Native"), ylab = "Range amplitude (m)", boxfill = c(rgb(0.8, 0, 0.4), rgb(0, 0.4, 0.8)), outline = 0, ylim = c(0, 3000))
	col <- as.numeric(era$occ >= 5)
	beeswarm(ampl~Status, data = era, add = TRUE, pch = 21, pwbg = col, cex = 1.2)

## ---- boxmin
	par(mar = c(3, 5, 0.5, 0.5), mgp = c(2, 0.5, 0), cex = 1.2, tck = 0.03, las = 1)
	boxplot(min~Status, data = era[era$occ>= 5, ], names = c("Exotic", "Native"), ylab = "Minimum elevation (m)", boxfill = c(rgb(0.8, 0, 0.4), rgb(0, 0.4, 0.8)), outline = 0, ylim = c(0, 3000))
	col <- as.numeric(era$occ>= 5)
	beeswarm(min~Status, data = era, add = TRUE, pch = 21, pwbg = col, cex = 1.2)

## ---- boxmax
par(mar = c(3, 5, 0.5, 0.5), mgp = c(2, 0.5, 0), cex = 1.2, tck = 0.03, las = 1)
	boxplot(max~Status, data = era[era$occ>= 5, ], names = c("Exotic", "Native"), ylab = "Maximum elevation (m)", boxfill = c(rgb(0.8, 0, 0.4), rgb(0, 0.4, 0.8)), outline = 0, ylim = c(0, 3000))
	col <- as.numeric(era$occ>= 5)
	beeswarm(max~Status, data = era, add = TRUE, pch = 21, pwbg = col, cex = 1.2)
  
## raw species richness + gam model
## ---- Stot
	par(mar = c(3, 3, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
	tmp <- data.frame(S = Sn+Se, alti = as.numeric(names(Sn)))
	plot(S~alti, data = tmp, pch = 19, xlab = "Altitude (m)", ylab = "Total species richness", ylim = c(0, 20))
  fit <- predict(modS, type = "response")
	se <- predict(modS, se.fit = TRUE, type = "response")$se.fit
  lcl <- fit - 1.96 * se
  ucl <- fit + 1.96 * se
  i.for <- order(tmp$alti)
  i.back <- order(tmp$alti, decreasing = TRUE )
  x.polygon <- c(tmp$alti[i.for], tmp$alti[i.back])
  y.polygon <- c(ucl[i.for], lcl[i.back] )
  polygon(x.polygon, y.polygon, col = rgb(0.2, 0.2, 0.2, alpha = 0.2), border = NA )
lines(tmp$alti[i.for] , fit[i.for], col = "black", lwd = 1, lty = 2)
rm(i.back, i.for, lcl, ucl, se, fit)

## ---- Snatexo
	par(mar = c(3, 3, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
	tmp <- data.frame(S = Se, alti = as.numeric(names(Se)))
  fit <- predict(modSe, type = "response")
	se <- predict(modSe, se.fit = TRUE, type = "response")$se.fit
  lcl <- fit - 1.96 * se
  ucl <- fit + 1.96 * se
  i.for <- order(tmp$alti)
  i.back <- order(tmp$alti, decreasing = TRUE )
  x.polygon <- c(tmp$alti[i.for], tmp$alti[i.back])
  y.polygon <- c(ucl[i.for], lcl[i.back] )
plot(S~alti, data = tmp, pch = 19, ylim = c(0, 20), xlab = "Elevation (m)", ylab = "Species richness", col = rgb(0.8, 0, 0.4))
	polygon(x.polygon, y.polygon, col = rgb(0.8, 0, 0.4, alpha = 0.2), border = NA )
	lines(tmp$alti[i.for], fit[i.for], col = rgb(0.8, 0, 0.4), lwd = 1, lty = 2)
	tmp <- data.frame(S = Sn, alti = as.numeric(names(Sn)))
  fit <- predict(modSn, type = "response")
	se <- predict(modSn, se.fit = TRUE, type = "response")$se.fit
  lcl <- fit - 1.96 * se
  ucl <- fit + 1.96 * se
  i.for <- order(tmp$alti)
  i.back <- order(tmp$alti, decreasing = TRUE )
  x.polygon <- c(tmp$alti[i.for], tmp$alti[i.back])
  y.polygon <- c(ucl[i.for], lcl[i.back] )
	points(S~alti, data = tmp, pch = 19, ylim = c(0, 15), xlab = "Elevation (m)", ylab = "Species richness", col = rgb(0, 0.4, 0.8))
	polygon(x.polygon, y.polygon, col = rgb(0, 0.4, 0.8, alpha = 0.2), border = NA )
	lines(tmp$alti[i.for], fit[i.for], col = rgb(0, 0.4, 0.8), lwd = 1, lty = 2)
	legend(2300, 15, legend = c("Native", "Exotic"), pch = 19, col = c(rgb(0, 0.4, 0.8), rgb(0.8, 0, 0.4)), bty = "n")
	rm(i.back, i.for, lcl, ucl, se, fit)

## species richness and null model
## ---- Snatb
	par(mar = c(3, 3, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
	tmp <- data.frame(S = Sn, alti = as.numeric(names(Se)))		
  lcl <- lowess(xnb[, 1], xnb[, "2.5%"], f = 1/4)
  ucl <- lowess(xnb[, 1], xnb[, "97.5%"], f = 1/4)
  x.polygon <- c(lcl$x, rev(ucl$x))
  y.polygon <- c(lcl$y, rev(ucl$y))
	plot(S~alti, data = tmp, pch = 19, ylim = c(0, 15), xlab = "Elevation (m)", ylab = "Species richness")
	polygon(x.polygon, y.polygon, col = rgb(0.7, 0.7, 0.7, alpha = 0.2), border = NA )
  lcl2 <- lowess(xnc[, 1], xnc[, "2.5%"], f = 1/4)
  ucl2 <- lowess(xnc[, 1], xnc[, "97.5%"], f = 1/4)
  x2.polygon <- c(lcl2$x, rev(ucl2$x))
  y2.polygon <- c(lcl2$y, rev(ucl2$y))
	polygon(x2.polygon, y2.polygon, col = rgb(0.4, 0.4, 0.4, alpha = 0.2), border = NA )

	rm(lcl, ucl, x.polygon, y.polygon, lcl2, ucl2, x2.polygon, y2.polygon)


## ---- Snatc
	par(mar = c(3, 3, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
	tmp <- data.frame(S = Se, alti = as.numeric(names(Se)))		
 	lcl <- lowess(xeb[, 1], xeb[, "2.5%"], f = 1/4)
  ucl <- lowess(xeb[, 1], xeb[, "97.5%"], f = 1/4)
  x.polygon <- c(lcl$x, rev(ucl$x))
  y.polygon <- c(lcl$y, rev(ucl$y))
plot(S ~ alti, data = tmp, pch = 19, ylim = c(0, 15), xlab = "Elevation (m)", ylab = "Species richness")
	polygon(x.polygon, y.polygon, col = rgb(0.7, 0.7, 0.7, alpha = 0.2), border = NA)
  lcl2 <- lowess(xec[, 1], xec[, "2.5%"], f = 1/4)
  ucl2 <- lowess(xec[, 1], xec[, "97.5%"], f = 1/5)
  x2.polygon <- c(lcl2$x, rev(ucl2$x))
  y2.polygon <- c(lcl2$y, rev(ucl2$y))
	polygon(x2.polygon, y2.polygon, col = rgb(0.7, 0.7, 0.7, alpha = 0.2), border = NA)

	rm(lcl, ucl, x.polygon, y.polygon, lcl2, ucl2, x2.polygon, y2.polygon)


### ---- Snatgam")
#  {
#		par(mar = c(3, 3, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
#		tmp <- data.frame(S = Sn, alti = as.numeric(names(Sn)))
#	  fit <- predict(modSn, type = "response")
#		se <- predict(modSn, se.fit = TRUE, type = "response")$se.fit
#	  lcl <- fit - 1.96 * se
#	  ucl <- fit + 1.96 * se
#	  i.for <- order(tmp$alti)
#	  i.back <- order(tmp$alti, decreasing = TRUE )
#	  x.polygon <- c(tmp$alti[i.for], tmp$alti[i.back])
#	  y.polygon <- c(ucl[i.for], lcl[i.back] )
#    plot(S~alti, data = tmp, pch = 19, ylim = c(0, 15), xlab = "Elevation (m)", ylab = "Species richness", col = rgb(0, 0.4, 0.8))
#		polygon(x.polygon, y.polygon, col = rgb(0, 0.4, 0.8, alpha = 0.2), border = NA )
#		lines(tmp$alti[i.for], fit[i.for], col = rgb(0, 0.4, 0.8), lwd = 1, lty = 2)
#		rm(i.back, i.for, lcl, ucl, se, fit)
#	}
### ---- Sexogam")
#  {
#		par(mar = c(3, 3, 0.5, 0.5), mgp = c(2, 0.5, 0), tck = 0.03, las = 1)
#		tmp <- data.frame(S = Se, alti = as.numeric(names(Se)))
#	  fit <- predict(modSe, type = "response")
#		se <- predict(modSe, se.fit = TRUE, type = "response")$se.fit
#	  lcl <- fit - 1.96 * se
#	  ucl <- fit + 1.96 * se
#	  i.for <- order(tmp$alti)
#	  i.back <- order(tmp$alti, decreasing = TRUE )
#	  x.polygon <- c(tmp$alti[i.for], tmp$alti[i.back])
#	  y.polygon <- c(ucl[i.for], lcl[i.back] )
#    plot(S~alti, data = tmp, pch = 19, ylim = c(0, 15), xlab = "Elevation (m)", ylab = "Species richness", col = rgb(0.8, 0, 0.4))
#		polygon(x.polygon, y.polygon, col = rgb(0.8, 0, 0.4, alpha = 0.2), border = NA )
#		lines(tmp$alti[i.for], fit[i.for], col = rgb(0.8, 0, 0.4), lwd = 1, lty = 2)
#		rm(i.back, i.for, lcl, ucl, se, fit)
#	}

