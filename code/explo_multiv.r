	
#	 Acacia dense (ACDE)
#    Acacia mixte (ACMI)
#    Bois de couleurs (BOCO) : forêt naturelle de moyenne altitude
#    Branles (BRAN) : végétation éricoïde basse dominée par les branles (Erica reunionensis)
#    Canne (CANN)
#    Cultures (CULT)
#    Friches arbustives (FOUR)
#    Friches basses (FRBA)
#    Pâturages (PATU)
#    Savane arborée (SAAR)
#    Savane herbeuse(SAHE)
#    Tamarinaie (TAMA)
#    Zones d’habitat (URBA)
	
	# Simplification des habitats
	nhab <- c("ALTI", "ACDE", "ACMI", "BOCO", "BRAN", "CANN", "CRYP", "CULT", "FOEX", "FRAR", "FRBA", "PATU", "SAAR", "SAHE", "TAMA", "URBA")	
	hab <- zjt@data %>% select(nhab)
	hab %<>%
	
		#mutate(BAOU = CULT + SAHE + SAAR, FRIC = FRAR + FRBA) %>%
		#dplyr::select(- CULT, - SAHE, - SAAR, - FRAR, - FRBA) %>%
		pivot_longer(cols = - ALTI, names_to = "hab", values_to = "prop")

	# Altitude moyenne des points avec habitats dominants		
	hab %>% group_by(hab) %>%
		filter(prop > 0.5) %>% 
		summarise(alti.moy = mean(ALTI)) %>% print
	
	
	# ACP 
	#acph <- dudi.pca(hab)
	#scatter(acph)