	
	
	
	# Simplification des habitats
	nh <- c("ALTI", "ACDE", "ACMI", "BOCO", "BRAN", "CANN", "CRYP", "CULT", "FOEX", "FRAR", "FRBA", "PATU", "SAAR", "SAHE", "TAMA", "URBA")	
	hab <- zjt@data %>% select(nh)
	##hab %<>% mutate(BAOU = CULT + SAHE + SAAR, FRIC = FRAR + FRBA) %>%
	#	select(- CULT, - SAHE, - SAAR, - FRAR, - FRBA)
	 
	acph <- dudi.pca(hab)
	
	scatter(acph)