	#--------------------------------
	# 
	#
	#-------------------------------
	
	tmp <- data.frame(coordinates(zjt))
	names(tmp) <- c("X", "Y")
	tmp %<>% bind_cols(zjt@data)
	
	p <- ggplot(tmp, aes(x = X, y = Y, color = pub)) +
	geom_point()

	p <- ggplot(data = mmnt) + 
		geom_raster(aes(x, y, fill = z)) +	
		geom_point(data = tmp, aes(X, Y, colour = FRPO), alpha = 0.5) +
		scale_fill_gradient(low = "gray70", high = "gray90", na.value = "white") +
        scale_colour_viridis(direction = 1,  option = "inferno") +
        coord_equal() +
		guides(fill = F)
        theme_minimal() +
		theme(axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank())
	p