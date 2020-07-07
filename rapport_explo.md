---
title: "Analyses préliminaires JD La Réunion"
date: 
output: word_document
---



# Objectif

Analyses préliminaires des données de la Réunion. Pour l'instant il s'agit surtout de comprendre comment elles sont structurées et ce qu'on peut en faire. Le document commence par des analyses multivariées sur les tables oiseaux et habitats, puis une FDA sur les variations d'abondance le long du gradient altitudinal.

# Points principaux 

-- deux analyses : une statique (PCOA sur données d'habitat et données oiseaux) et une par gradient (FDA sur les réponses des espèces à l'altitude)  

-- des résultats qui ne sont pas aberrants mais nécessitent un regard extérieur, je ne me sens pas à les analyser seul au regard de ma connaissance de l'avifaune de la Réunion. En tout cas on n'a aucune typologie de réponse claire et des résultats très multivariés.   

-- il faut qu'on discute de ce qu'on fait sur cette base : quelle approche on privilégie et quelles analyses supplémentaires  


# Données

Deux tables de données : 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlstd{ois} \hlkwb{<-} \hlkwd{read.table}\hlstd{(}\hlstr{"data/OIS_modif29042020.txt"}\hlstd{,} \hlkwc{header} \hlstd{= T,} \hlkwc{sep} \hlstd{=} \hlstr{"\textbackslash{}t"}\hlstd{,} \hlkwc{row.names} \hlstd{=} \hlnum{1}\hlstd{)}
\end{alltt}


{\ttfamily\noindent\color{warningcolor}{\#\# Warning in file(file, "{}rt"{}): impossible d'ouvrir le fichier 'data/OIS\_modif29042020.txt' : Aucun fichier ou dossier de ce type}}

{\ttfamily\noindent\bfseries\color{errorcolor}{\#\# Error in file(file, "{}rt"{}): impossible d'ouvrir la connexion}}\begin{alltt}
\hlstd{mil} \hlkwb{<-} \hlkwd{read.table}\hlstd{(}\hlstr{"data/MIL_modif29042020.txt"}\hlstd{,} \hlkwc{header} \hlstd{= T,} \hlkwc{sep} \hlstd{=} \hlstr{"\textbackslash{}t"}\hlstd{,} \hlkwc{row.names} \hlstd{=} \hlnum{1}\hlstd{)}
\end{alltt}


{\ttfamily\noindent\color{warningcolor}{\#\# Warning in file(file, "{}rt"{}): impossible d'ouvrir le fichier 'data/MIL\_modif29042020.txt' : Aucun fichier ou dossier de ce type}}

{\ttfamily\noindent\bfseries\color{errorcolor}{\#\# Error in file(file, "{}rt"{}): impossible d'ouvrir la connexion}}\end{kframe}
\end{knitrout}

Les colonnes sont décrites dans les fichiers excel initiaux. 

## table oiseaux

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{dim}\hlstd{(ois)}
\end{alltt}
\begin{verbatim}
## [1] 410  23
\end{verbatim}
\begin{alltt}
\hlkwd{summary}\hlstd{(ois)}
\end{alltt}
\begin{verbatim}
##       ACTR             CIMA              COCH               COCO             COFR              ESAS             FOMA             FRPO        
##  Min.   : 0.000   Min.   :0.00000   Min.   :0.000000   Min.   :0.0000   Min.   : 0.0000   Min.   : 0.000   Min.   : 0.000   Min.   :0.00000  
##  1st Qu.: 0.000   1st Qu.:0.00000   1st Qu.:0.000000   1st Qu.:0.0000   1st Qu.: 0.0000   1st Qu.: 0.000   1st Qu.: 1.000   1st Qu.:0.00000  
##  Median : 1.000   Median :0.00000   Median :0.000000   Median :0.0000   Median : 0.0000   Median : 0.000   Median : 3.000   Median :0.00000  
##  Mean   : 1.768   Mean   :0.02683   Mean   :0.004878   Mean   :0.3122   Mean   : 0.3829   Mean   : 1.444   Mean   : 3.822   Mean   :0.01951  
##  3rd Qu.: 2.000   3rd Qu.:0.00000   3rd Qu.:0.000000   3rd Qu.:0.0000   3rd Qu.: 0.0000   3rd Qu.: 1.000   3rd Qu.: 6.000   3rd Qu.:0.00000  
##  Max.   :34.000   Max.   :2.00000   Max.   :2.000000   Max.   :8.0000   Max.   :10.0000   Max.   :28.000   Max.   :57.000   Max.   :5.00000  
##       GEST              HYBO             LOPU               MAMA              PADO             PEAS              PHBO              PLCU        
##  Min.   : 0.0000   Min.   :0.0000   Min.   :0.000000   Min.   :0.00000   Min.   : 0.000   Min.   : 0.0000   Min.   :0.00000   Min.   : 0.0000  
##  1st Qu.: 0.0000   1st Qu.:0.0000   1st Qu.:0.000000   1st Qu.:0.00000   1st Qu.: 0.000   1st Qu.: 0.0000   1st Qu.:0.00000   1st Qu.: 0.0000  
##  Median : 0.0000   Median :0.0000   Median :0.000000   Median :0.00000   Median : 0.000   Median : 0.0000   Median :0.00000   Median : 0.0000  
##  Mean   : 0.8049   Mean   :0.3488   Mean   :0.002439   Mean   :0.02683   Mean   : 1.066   Mean   : 0.1463   Mean   :0.02195   Mean   : 0.5366  
##  3rd Qu.: 1.0000   3rd Qu.:0.0000   3rd Qu.:0.000000   3rd Qu.:0.00000   3rd Qu.: 0.000   3rd Qu.: 0.0000   3rd Qu.:0.00000   3rd Qu.: 0.0000  
##  Max.   :31.0000   Max.   :6.0000   Max.   :1.000000   Max.   :5.00000   Max.   :17.000   Max.   :11.0000   Max.   :6.00000   Max.   :42.0000  
##       PYJO              SATE            STPI             TEBO              TUNI             ZOBO           ZOOL       
##  Min.   : 0.0000   Min.   : 0.00   Min.   :0.0000   Min.   :0.00000   Min.   :0.0000   Min.   : 0.0   Min.   :0.0000  
##  1st Qu.: 0.0000   1st Qu.: 0.00   1st Qu.:0.0000   1st Qu.:0.00000   1st Qu.:0.0000   1st Qu.: 0.0   1st Qu.:0.0000  
##  Median : 0.0000   Median : 1.00   Median :0.0000   Median :0.00000   Median :0.0000   Median : 2.0   Median :0.0000  
##  Mean   : 0.5561   Mean   : 1.59   Mean   :0.1902   Mean   :0.06829   Mean   :0.1878   Mean   : 2.3   Mean   :0.2976  
##  3rd Qu.: 0.0000   3rd Qu.: 3.00   3rd Qu.:0.0000   3rd Qu.:0.00000   3rd Qu.:0.0000   3rd Qu.: 4.0   3rd Qu.:0.0000  
##  Max.   :10.0000   Max.   :10.00   Max.   :7.0000   Max.   :3.00000   Max.   :5.0000   Max.   :16.0   Max.   :7.0000
\end{verbatim}
\end{kframe}
\end{knitrout}

Pas d'incohérence apparente. Beaucoup de 0, les distributions sont très asymétriques, sans surprise. 

## table habitats

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{dim}\hlstd{(mil)}
\end{alltt}
\begin{verbatim}
## [1] 410  16
\end{verbatim}
\begin{alltt}
\hlkwd{summary}\hlstd{(mil)}
\end{alltt}
\begin{verbatim}
##       ALTI             ACDE             ACMI               BOCO             BRAN             CANN             CRYP             CULT        
##  Min.   :  20.0   Min.   :0.0000   Min.   :0.000000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.00000  
##  1st Qu.: 803.8   1st Qu.:0.0000   1st Qu.:0.000000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000  
##  Median :1290.0   Median :0.0000   Median :0.000000   Median :0.0000   Median :0.0000   Median :0.0000   Median :0.0000   Median :0.00000  
##  Mean   :1204.2   Mean   :0.1243   Mean   :0.003585   Mean   :0.1222   Mean   :0.0841   Mean   :0.1443   Mean   :0.0599   Mean   :0.04134  
##  3rd Qu.:1598.8   3rd Qu.:0.0575   3rd Qu.:0.000000   3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.:0.00000  
##  Max.   :2880.0   Max.   :1.0000   Max.   :0.700000   Max.   :1.0000   Max.   :1.0000   Max.   :1.0000   Max.   :0.9400   Max.   :1.00000  
##       FOEX              FRAR               FRBA             PATU              SAAR              SAHE              TAMA             URBA        
##  Min.   :0.00000   Min.   :0.000000   Min.   :0.0000   Min.   :0.00000   Min.   :0.00000   Min.   :0.00000   Min.   :0.0000   Min.   :0.00000  
##  1st Qu.:0.00000   1st Qu.:0.000000   1st Qu.:0.0000   1st Qu.:0.00000   1st Qu.:0.00000   1st Qu.:0.00000   1st Qu.:0.0000   1st Qu.:0.00000  
##  Median :0.00000   Median :0.000000   Median :0.0000   Median :0.00000   Median :0.00000   Median :0.00000   Median :0.0000   Median :0.00000  
##  Mean   :0.06646   Mean   :0.003756   Mean   :0.1195   Mean   :0.05895   Mean   :0.03398   Mean   :0.03444   Mean   :0.0852   Mean   :0.01868  
##  3rd Qu.:0.06000   3rd Qu.:0.000000   3rd Qu.:0.0000   3rd Qu.:0.00000   3rd Qu.:0.00000   3rd Qu.:0.00000   3rd Qu.:0.0000   3rd Qu.:0.00000  
##  Max.   :0.72000   Max.   :0.390000   Max.   :1.0000   Max.   :1.00000   Max.   :1.00000   Max.   :1.00000   Max.   :1.0000   Max.   :0.47000
\end{verbatim}
\end{kframe}
\end{knitrout}

Attention : il y a des fréquences cumulées d'habitats par point >100% ! 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# fréquence cumulée des habitats par point}
\hlstd{fr.hab}\hlkwb{=}\hlkwd{apply}\hlstd{(mil[,}\hlopt{-}\hlnum{1}\hlstd{],}\hlnum{1}\hlstd{,}\hlstr{"sum"}\hlstd{)}
\hlkwd{summary}\hlstd{(fr.hab)}
\end{alltt}
\begin{verbatim}
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.990   1.000   1.000   1.001   1.000   1.010
\end{verbatim}
\begin{alltt}
\hlkwd{hist}\hlstd{(fr.hab)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-4-1} 

\end{knitrout}

### Distribution des habitats

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{par}\hlstd{(}\hlkwc{mfrow}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{3}\hlstd{,}\hlnum{3}\hlstd{))}
\hlkwa{for}\hlstd{(i} \hlkwa{in} \hlnum{2}\hlopt{:}\hlnum{10}\hlstd{)\{}
  \hlkwd{hist}\hlstd{(mil[,i])}
\hlstd{\}}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-5-1} 

\end{knitrout}


\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{par}\hlstd{(}\hlkwc{mfrow}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{3}\hlstd{,}\hlnum{2}\hlstd{))}
\hlkwa{for}\hlstd{(i} \hlkwa{in} \hlnum{11}\hlopt{:}\hlnum{16}\hlstd{)\{}
  \hlkwd{hist}\hlstd{(mil[,i])}
\hlstd{\}}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-6-1} 

\end{knitrout}
Les distris des habitats posent deux problèmes :  

-- la somme à 100 (en théorie)  
-- leur asymétrie

### Altitude

Pour l'altitude, variation assez classique : 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{hist}\hlstd{(mil[,}\hlnum{1}\hlstd{])}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-7-1} 

\end{knitrout}

## Analyse en coordonnées principales sur la matrice d'habitats



\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# PCOA}
\hlstd{pco.habitat} \hlkwb{<-} \hlkwd{dudi.pco}\hlstd{(distmat,} \hlkwc{scannf} \hlstd{= F,} \hlkwc{nf} \hlstd{=} \hlnum{5}\hlstd{)} \hlcom{# avec 5 axes environ 70% de variation expliquée}
\end{alltt}
\end{kframe}
\end{knitrout}

L'analyse en coordonnées principale permet de résoudre les deux problèmes mentionnés ci dessus et d'ajouter l'altitude aux variables d'habitat. 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{screeplot}\hlstd{(pco.habitat)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/wat-1} 
\begin{kframe}\begin{alltt}
\hlnum{100}\hlopt{*}\hlkwd{cumsum}\hlstd{(pco.habitat}\hlopt{$}\hlstd{eig)}\hlopt{/}\hlkwd{sum}\hlstd{(pco.habitat}\hlopt{$}\hlstd{eig)}
\end{alltt}
\begin{verbatim}
##  [1]  20.14260  33.63155  45.67581  57.21639  66.67637  74.33942  80.98807  87.08968  90.99293  94.47521  97.65528  98.70365  99.28549  99.61633
## [15]  99.82905 100.00000
\end{verbatim}
\end{kframe}
\end{knitrout}

On est sur des % de variance expliquée assez classiques pour ce genre de données. En première intention je retiens 5 composantes.



### Projection des points et des variables (axe 1 vs chacun des 4 autres)


\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# axes 1 vs 2}
\hlkwd{s.label}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li,}\hlkwc{ppoints}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0.8}\hlstd{,}\hlkwc{col}\hlstd{=c2),}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\hlstd{sp}\hlkwb{=}\hlkwd{supcol}\hlstd{(pco.habitat,mil)}
\hlkwd{s.arrow}\hlstd{(sp}\hlopt{$}\hlstd{cosup,}\hlkwc{add}\hlstd{=T,}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"darkblue"}\hlstd{,}\hlkwc{cex}\hlstd{=}\hlnum{0.7}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-11-1} 

\end{knitrout}

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# axes 1 vs 3}
\hlkwd{s.label}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li,}\hlkwc{xax}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{yax}\hlstd{=}\hlnum{3}\hlstd{,}\hlkwc{ppoints}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0.8}\hlstd{,}\hlkwc{col}\hlstd{=c2),}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\hlkwd{s.arrow}\hlstd{(sp}\hlopt{$}\hlstd{cosup,}\hlkwc{xax}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{yax}\hlstd{=}\hlnum{3}\hlstd{,}\hlkwc{add}\hlstd{=T,}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"darkblue"}\hlstd{,}\hlkwc{cex}\hlstd{=}\hlnum{0.7}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-12-1} 

\end{knitrout}

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# axes 1 vs 4}
\hlkwd{s.label}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li,}\hlkwc{xax}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{yax}\hlstd{=}\hlnum{4}\hlstd{,}\hlkwc{ppoints}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0.8}\hlstd{,}\hlkwc{col}\hlstd{=c2),}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\hlkwd{s.arrow}\hlstd{(sp}\hlopt{$}\hlstd{cosup,}\hlkwc{xax}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{yax}\hlstd{=}\hlnum{4}\hlstd{,}\hlkwc{add}\hlstd{=T,}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"darkblue"}\hlstd{,}\hlkwc{cex}\hlstd{=}\hlnum{0.7}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-13-1} 

\end{knitrout}

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# axes 1 vs 5}
\hlkwd{s.label}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li,}\hlkwc{xax}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{yax}\hlstd{=}\hlnum{5}\hlstd{,}\hlkwc{ppoints}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0.8}\hlstd{,}\hlkwc{col}\hlstd{=c2),}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\hlkwd{s.arrow}\hlstd{(sp}\hlopt{$}\hlstd{cosup,}\hlkwc{xax}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{yax}\hlstd{=}\hlnum{5}\hlstd{,}\hlkwc{add}\hlstd{=T,}\hlkwc{plabels}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{alpha}\hlstd{=}\hlnum{1}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"darkblue"}\hlstd{,}\hlkwc{cex}\hlstd{=}\hlnum{0.7}\hlstd{,}\hlkwc{boxes}\hlstd{=}\hlkwd{list}\hlstd{(}\hlkwc{draw}\hlstd{=F)))}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-14-1} 

\end{knitrout}

### Interprétation

Difficile sans bien connaître le contexte. Olivier, peux-tu avoir un apport là dessus? Voilà ce que j'arrive à sortir: 

-- PC1 = altitude
-- PC2 = habitats exo vs natifs
-- PC3 = ?? 
-- PC4 = ??
-- PC5 = ??

## table Oiseaux

### Toutes espèces 

#### AFC sur les abondances



\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# valeurs propres}
\hlkwd{cumsum}\hlstd{(afc.ois}\hlopt{$}\hlstd{eig)}\hlopt{/}\hlkwd{sum}\hlstd{(afc.ois}\hlopt{$}\hlstd{eig)}
\end{alltt}
\begin{verbatim}
##  [1] 0.1330918 0.2302468 0.3112237 0.3820102 0.4511414 0.5094170 0.5662222 0.6191457 0.6691835 0.7093530 0.7458145 0.7801068 0.8105675 0.8408215
## [15] 0.8685437 0.8954101 0.9199879 0.9439219 0.9661262 0.9810814 0.9929844 1.0000000
\end{verbatim}
\end{kframe}
\end{knitrout}

Pas évident de retenir des gradients bien clairs, la variation est trop graduelle. Passer en présence/absence ne change rien au problème.

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# nuage de points}
\hlkwd{s.label}\hlstd{(afc.ois}\hlopt{$}\hlstd{li)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-17-1} 

\end{knitrout}

Il y a deux points extrêmes : 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# 2 points extrêmes}
\hlstd{ois[}\hlkwd{c}\hlstd{(}\hlstr{"ID187"}\hlstd{,}\hlstr{"ID225"}\hlstd{),]}
\end{alltt}
\begin{verbatim}
##       ACTR CIMA COCH COCO COFR ESAS FOMA FRPO GEST HYBO LOPU MAMA PADO PEAS PHBO PLCU PYJO SATE STPI TEBO TUNI ZOBO ZOOL
## ID187    2    0    0    0    3    0    0    5    4    0    0    0    0    0    0    1    1    0    0    0    0    5    0
## ID225    2    0    0    0    0    0    0    3    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
\end{verbatim}
\begin{alltt}
\hlkwd{apply}\hlstd{(ois,}\hlnum{2}\hlstd{,}\hlstr{"max"}\hlstd{)}
\end{alltt}
\begin{verbatim}
## ACTR CIMA COCH COCO COFR ESAS FOMA FRPO GEST HYBO LOPU MAMA PADO PEAS PHBO PLCU PYJO SATE STPI TEBO TUNI ZOBO ZOOL 
##   34    2    2    8   10   28   57    5   31    6    1    5   17   11    6   42   10   10    7    3    5   16    7
\end{verbatim}
\end{kframe}
\end{knitrout}

Correspondent en particulier aux seuls points avec Francolin - voir plus bas. 



Position dans la PCOA "habitats" (tous les plans axe 1 vs l'un des 4 autres) : 

1 vs 2: 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{par}\hlstd{(}\hlkwc{mfrow}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{2}\hlstd{,}\hlnum{2}\hlstd{))}
\hlkwd{plot}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{1}\hlstd{],pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{2}\hlstd{],}\hlkwc{bty}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{pch}\hlstd{=}\hlnum{21}\hlstd{,}\hlkwc{bg}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"PCO habitat 1"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"PCO habitat 2"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{h}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{v}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{text}\hlstd{(extr.ois[,}\hlnum{1}\hlstd{],extr.ois[,}\hlnum{2}\hlstd{],}\hlkwc{labels}\hlstd{=}\hlkwd{rownames}\hlstd{(extr.ois),}\hlkwc{col}\hlstd{=}\hlstr{"darkred"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-20-1} 

\end{knitrout}

1 vs 3

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{plot}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{1}\hlstd{],pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{3}\hlstd{],}\hlkwc{bty}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{pch}\hlstd{=}\hlnum{21}\hlstd{,}\hlkwc{bg}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"PCO habitat 1"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"PCO habitat 3"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{h}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{v}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{text}\hlstd{(extr.ois[,}\hlnum{1}\hlstd{],extr.ois[,}\hlnum{3}\hlstd{],}\hlkwc{labels}\hlstd{=}\hlkwd{rownames}\hlstd{(extr.ois),}\hlkwc{col}\hlstd{=}\hlstr{"darkred"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-21-1} 

\end{knitrout}

1 vs 4 : 
\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{plot}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{1}\hlstd{],pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{4}\hlstd{],}\hlkwc{bty}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{pch}\hlstd{=}\hlnum{21}\hlstd{,}\hlkwc{bg}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"PCO habitat 1"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"PCO habitat 4"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{h}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{v}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{text}\hlstd{(extr.ois[,}\hlnum{1}\hlstd{],extr.ois[,}\hlnum{4}\hlstd{],}\hlkwc{labels}\hlstd{=}\hlkwd{rownames}\hlstd{(extr.ois),}\hlkwc{col}\hlstd{=}\hlstr{"darkred"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-22-1} 

\end{knitrout}

1 vs 5:

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{plot}\hlstd{(pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{1}\hlstd{],pco.habitat}\hlopt{$}\hlstd{li[,}\hlnum{5}\hlstd{],}\hlkwc{bty}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{pch}\hlstd{=}\hlnum{21}\hlstd{,}\hlkwc{bg}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"PCO habitat 1"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"PCO habitat 5"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{h}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{v}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{text}\hlstd{(extr.ois[,}\hlnum{1}\hlstd{],extr.ois[,}\hlnum{5}\hlstd{],}\hlkwc{labels}\hlstd{=}\hlkwd{rownames}\hlstd{(extr.ois),}\hlkwc{col}\hlstd{=}\hlstr{"darkred"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-23-1} 

\end{knitrout}

L'analyse est écrasée par deux points qui n'ont rien de spécifique si ce n'est une espèce qui leur est unique, mais leur position sur les gradients d'habitat n'a rien d'extraordinaire. Je tente une analyse que sur les espèces bien distribuées pour y voir plus clair. 


## table oiseaux : restreint aux espèces présentes sur >5% des points

### AFC oiseaux sans espèces sous-représentées ###

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# abondances}
\hlkwd{sum}\hlstd{(ois)}
\end{alltt}
\begin{verbatim}
## [1] 6529
\end{verbatim}
\begin{alltt}
\hlnum{0.05}\hlopt{*}\hlkwd{sum}\hlstd{(ois)}
\end{alltt}
\begin{verbatim}
## [1] 326.45
\end{verbatim}
\begin{alltt}
\hlnum{0.01}\hlopt{*}\hlkwd{sum}\hlstd{(ois)}
\end{alltt}
\begin{verbatim}
## [1] 65.29
\end{verbatim}
\begin{alltt}
\hlcom{# fréquence}
\hlstd{frq.cum}\hlkwb{=}\hlkwd{colSums}\hlstd{(ois)}\hlopt{/}\hlkwd{nrow}\hlstd{(ois)}
\hlstd{frq.cum[frq.cum}\hlopt{<}\hlnum{0.05}\hlstd{]}
\end{alltt}
\begin{verbatim}
##        CIMA        COCH        FRPO        LOPU        MAMA        PHBO 
## 0.026829268 0.004878049 0.019512195 0.002439024 0.026829268 0.021951220
\end{verbatim}
\end{kframe}
\end{knitrout}

# AFC sans les espèces vues sur moins de 5% des points

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlstd{ois.com}\hlkwb{=}\hlstd{ois[,}\hlkwd{names}\hlstd{(frq.cum[frq.cum}\hlopt{>}\hlnum{0.05}\hlstd{])]}
\hlstd{afc.ois.com}\hlkwb{=}\hlkwd{dudi.coa}\hlstd{(ois.com,}\hlkwc{scannf}\hlstd{=F,}\hlkwc{nf}\hlstd{=}\hlnum{2}\hlstd{)}
\hlkwd{cumsum}\hlstd{(afc.ois.com}\hlopt{$}\hlstd{eig)}\hlopt{/}\hlkwd{sum}\hlstd{(afc.ois.com}\hlopt{$}\hlstd{eig)}
\end{alltt}
\begin{verbatim}
##  [1] 0.1685298 0.2707443 0.3599813 0.4456636 0.5192498 0.5897839 0.6562875 0.7063508 0.7519071 0.7955382 0.8342180 0.8718459 0.9068289 0.9407699
## [15] 0.9718166 1.0000000
\end{verbatim}
\begin{alltt}
\hlkwd{s.label}\hlstd{(afc.ois.com}\hlopt{$}\hlstd{li)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-25-1} 
\begin{kframe}\begin{alltt}
\hlkwd{s.label}\hlstd{(afc.ois.com}\hlopt{$}\hlstd{co)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-25-2} 

\end{knitrout}

Il y a un effet arche assez fort, mais au moins les points sont bien étalés dans l'ordination

# Analyse fonctionnelle

Cette analyse fonctionnelle ne porte **que sur l'altitude** et sur **les abondances d'espèces log-transformées**. C'est donc très préliminaire, mais l'altitude étant très structurante ça donne déjà une première idée des distributions d'espèces. 




## base optimale

Le choix de la base fonctionnelle optimale se fait par une comparaison entre des écarts fonctions-données pour différentes bases. Le but est d'avoir un compromis entre sur- et sous-lissage.



\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# on représente la variation du MSE avec l'ordre : on veut minimiser l'écart à la courbe moyenne et l'écart à la courbe d'écart aux données}
\hlkwd{plot}\hlstd{(}\hlnum{1}\hlopt{:}\hlnum{36}\hlstd{,MSE1,}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{ylim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0}\hlstd{,}\hlnum{4}\hlstd{))}
\hlkwd{lines}\hlstd{(}\hlnum{1}\hlopt{:}\hlnum{36}\hlstd{,MSE2,}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-28-1} 

\end{knitrout}

Quelle que soit la base, la représentation n'est de toute façon pas très bonne, probablement à cause des patterns de réponse à l'altitude mal marqués (gros pics en plein milieu du gradient qui ne sont pas modélisables facilement et / ou grosse dominance de 0 partout). Faute de mieux on reste sur une base 4 (classique, permet de marquer 1 ou 2 optimums mais sans surlisser).

## Analyse fonctionnelle

On travaille sur abondances log transformées. Les abondances et les altitudes sont normalisées pour limiter l'impact de la rareté des espèces et faciliter l'estimation numérique. 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# normaliser les abondances}
\hlstd{oiscb}\hlkwb{=}\hlkwd{log}\hlstd{(oisc}\hlopt{+}\hlnum{1}\hlstd{)}
\hlstd{maxab}\hlkwb{=}\hlkwd{apply}\hlstd{(oiscb,}\hlnum{2}\hlstd{,max)}
\hlstd{oisd}\hlkwb{=}\hlstd{oiscb}\hlopt{/}\hlstd{maxab}

\hlcom{# normaliser les altitudes}
\hlstd{alti4}\hlkwb{=}\hlstd{(alti3}\hlopt{-}\hlkwd{min}\hlstd{(alti3))}\hlopt{/}\hlkwd{max}\hlstd{((alti3)}\hlopt{-}\hlkwd{min}\hlstd{(alti3))}
\end{alltt}
\end{kframe}
\end{knitrout}

### Estimation des courbes

Ces courbes décrivent, pour chaque espèce, la réponse à l'altitude estimée à partir de splines de base 4. 



\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# plot d'une courbe}
\hlkwd{plot}\hlstd{(alti4,oisd[,}\hlnum{10}\hlstd{],}\hlkwc{pch}\hlstd{=}\hlnum{21}\hlstd{,}\hlkwc{bg}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"gray70"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"altitude"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"log(abondance)"}\hlstd{,}\hlkwc{main}\hlstd{=}\hlkwd{colnames}\hlstd{(oisd)[}\hlnum{10}\hlstd{])}
\hlkwd{lines}\hlstd{(alti4,evalmyb6[,}\hlnum{10}\hlstd{],}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"red"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-31-1} 

\end{knitrout}

La dispersion des points est toujours forte et il y a souvent des gros pics d'abondance en milieu de gradient qui sont mal modélisables. En général les optimums sont au bon endroit sur l'axe des altitudes mais leur amplitude n'est pas bonne. 

Comparaison des courbes de toutes les espèces : 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# courbes toutes espèces}
\hlkwd{plot}\hlstd{(}\hlkwc{x}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{y}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{xlim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0}\hlstd{,}\hlnum{1}\hlstd{),}\hlkwc{ylim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0}\hlstd{,}\hlnum{1}\hlstd{),}\hlkwc{type}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"altitude"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"estimation log(abondance)"}\hlstd{)}
\hlkwa{for}\hlstd{(i} \hlkwa{in} \hlnum{1}\hlopt{:}\hlkwd{ncol}\hlstd{(evalmyb6))\{}
  \hlkwd{lines}\hlstd{(alti4,evalmyb6[,i],}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"red"}\hlstd{)}
\hlstd{\}}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-32-1} 

\end{knitrout}

## ACP fonctionnelle

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlstd{mypca}\hlkwb{=}\hlkwd{pca.fd}\hlstd{(datamyb6,}\hlkwc{nharm}\hlstd{=}\hlnum{2}\hlstd{)}
\end{alltt}
\end{kframe}
\end{knitrout}

Cette ACP permet de créer des typologies de courbes. Les axes opposent des courbes de formes différentes. 

Variance expliquée : 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlnum{100}\hlopt{*}\hlstd{mypca}\hlopt{$}\hlstd{varprop}
\end{alltt}
\begin{verbatim}
## [1] 87.45767 11.89144
\end{verbatim}
\end{kframe}
\end{knitrout}

### Interprétation des axes

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# courbes extrêmes (et moyenne) qu'on a théoriquement aux extrémités des axes}
\hlkwd{par}\hlstd{(}\hlkwc{mfrow}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{1}\hlstd{,}\hlnum{2}\hlstd{))}
\hlkwd{plot}\hlstd{(mypca,}\hlkwc{xlab}\hlstd{=}\hlstr{"altitude normalisée"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-35-1} 

\end{knitrout}

La courbe en trait plein est la courbe moyenne (ici plate : en moyenne les espèces ne répondent pas à l'altitude). La courbe "--" est la déformation de cette courbe moyenne vers le négatif de l'axe d'ACP, et la courbe "++" est la déformation vers les positifs.  

-- **axe 1** (courbe de gauche): sépare des espèces qui diminuent avec l'altitude (-) ou augmentent avec l'altitude (+)  
-- **axe 2** (courbe de droite) : sépare des espèces qui ont un pic d'abondance (-) ou un déficit d'abondance (+) dans les plaines.   

Cette interprétation manque de netteté, probablement parce que les réponses à l'altitude sont un peu anarchiques et mal définies. Il faudra probablement réitérer l'exercice sur les axes de PCOA si on les comprend bien. On peut aussi interpréter les axes à partir des courbes quantiles, afin d'affiner la compréhension: 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# axe 1  en quantiles}
\hlstd{qt1}\hlkwb{=}\hlkwd{quantile}\hlstd{(mypca}\hlopt{$}\hlstd{scores[,}\hlnum{1}\hlstd{],}\hlkwc{p}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0.05}\hlstd{,}\hlnum{0.25}\hlstd{,}\hlnum{0.5}\hlstd{,}\hlnum{0.75}\hlstd{,}\hlnum{0.95}\hlstd{))}
\hlstd{scr.qt1}\hlkwb{=}\hlkwd{which}\hlstd{(mypca}\hlopt{$}\hlstd{scores[,}\hlnum{1}\hlstd{]}\hlopt{<}\hlstd{qt1[}\hlnum{1}\hlstd{])}
\hlstd{eva.qt1}\hlkwb{=}\hlstd{evalmyb6[,scr.qt1]}
\hlstd{mcurve.qt1}\hlkwb{=}\hlkwd{apply}\hlstd{(eva.qt1,}\hlnum{1}\hlstd{,mean)}
\hlkwd{plot}\hlstd{(alti4,mcurve.qt1,}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{)}

\hlkwa{for}\hlstd{(i} \hlkwa{in} \hlnum{2}\hlopt{:}\hlkwd{length}\hlstd{(qt1))\{}
  \hlstd{scr.qt1}\hlkwb{=}\hlkwd{which}\hlstd{(mypca}\hlopt{$}\hlstd{scores[,}\hlnum{1}\hlstd{]}\hlopt{<}\hlstd{qt1[i])}
  \hlstd{eva.qt1}\hlkwb{=}\hlstd{evalmyb6[,scr.qt1]}
  \hlstd{mcurve.qt1}\hlkwb{=}\hlkwd{apply}\hlstd{(eva.qt1,}\hlnum{1}\hlstd{,mean)}
  \hlkwd{lines}\hlstd{(alti4,mcurve.qt1,}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{col}\hlstd{=i}\hlopt{+}\hlnum{1}\hlstd{)}
\hlstd{\}}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-36-1} 

\end{knitrout}

Les quantiles vont du noir (-) au violet (+) et montrent bien une typologie de patrons de réponse allant d'espèces présentes sur tout le gradient altitudinal jusqu'à un seuil après lequel elles déclinent brusquement à des espèces qui ont un optimum d'altitude mais une variation peu marquée. C'est déjà plus interprétable que les déformations.

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# axe 2  en quantiles}
\hlstd{qt2}\hlkwb{=}\hlkwd{quantile}\hlstd{(mypca}\hlopt{$}\hlstd{scores[,}\hlnum{2}\hlstd{],}\hlkwc{p}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0.05}\hlstd{,}\hlnum{0.25}\hlstd{,}\hlnum{0.5}\hlstd{,}\hlnum{0.75}\hlstd{,}\hlnum{0.95}\hlstd{))}
\hlstd{scr.qt2}\hlkwb{=}\hlkwd{which}\hlstd{(mypca}\hlopt{$}\hlstd{scores[,}\hlnum{2}\hlstd{]}\hlopt{<}\hlstd{qt2[}\hlnum{1}\hlstd{])}
\hlstd{eva.qt2}\hlkwb{=}\hlstd{evalmyb6[,scr.qt2]}
\hlstd{mcurve.qt2}\hlkwb{=}\hlkwd{apply}\hlstd{(eva.qt2,}\hlnum{1}\hlstd{,mean)}
\hlkwd{plot}\hlstd{(alti4,mcurve.qt2,}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{)}

\hlkwa{for}\hlstd{(i} \hlkwa{in} \hlnum{2}\hlopt{:}\hlkwd{length}\hlstd{(qt2))\{}
  \hlstd{scr.qt2}\hlkwb{=}\hlkwd{which}\hlstd{(mypca}\hlopt{$}\hlstd{scores[,}\hlnum{2}\hlstd{]}\hlopt{<}\hlstd{qt2[i])}
  \hlstd{eva.qt2}\hlkwb{=}\hlstd{evalmyb6[,scr.qt2]}
  \hlstd{mcurve.qt2}\hlkwb{=}\hlkwd{apply}\hlstd{(eva.qt2,}\hlnum{1}\hlstd{,mean)}
  \hlkwd{lines}\hlstd{(alti4,mcurve.qt2,}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{col}\hlstd{=i}\hlopt{+}\hlnum{1}\hlstd{)}
\hlstd{\}}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-37-1} 

\end{knitrout}

Le deuxième axe semble séparer les espèces en termes de fréquence, toutes devenant plus rares en altitude. 

Le nuage de points de cette ACP: 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlcom{# nuage de points}
\hlkwd{rownames}\hlstd{(mypca}\hlopt{$}\hlstd{scores)}\hlkwb{=}\hlkwd{colnames}\hlstd{(oisd)}
\hlkwd{plot}\hlstd{(mypca}\hlopt{$}\hlstd{scores,}\hlkwc{type}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"PC1"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"PC2"}\hlstd{,}\hlkwc{xlim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlopt{-}\hlnum{2}\hlstd{,}\hlnum{0.7}\hlstd{),}\hlkwc{ylim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlopt{-}\hlnum{0.5}\hlstd{,}\hlnum{0.5}\hlstd{))}
\hlkwd{abline}\hlstd{(}\hlkwc{h}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{abline}\hlstd{(}\hlkwc{v}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{lty}\hlstd{=}\hlstr{"dashed"}\hlstd{)}
\hlkwd{text}\hlstd{(mypca}\hlopt{$}\hlstd{scores,}\hlkwc{labels}\hlstd{=}\hlkwd{rownames}\hlstd{(mypca}\hlopt{$}\hlstd{scores))}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-38-1} 

\end{knitrout}

La plupart des espèces est décalée dans le positif de l'axe 1, soit une réponse assez graduelle (et faible) à l'altitude avec une baisse d'abondance vers les sommets. Le négatif est dominé par le Foudi et le zosterops des Mascareignes, deux espèces qui sont donc présentes sur une bonne partie du gradient altitudinal avant une chute d'effectifs en haute altitude. On peut le vérifier sur les courbes individuelles (Zosterops : rouge ; Foudi : noir) : 

\begin{knitrout}
\definecolor{shadecolor}{rgb}{0.969, 0.969, 0.969}\color{fgcolor}\begin{kframe}
\begin{alltt}
\hlkwd{plot}\hlstd{(}\hlkwc{x}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{y}\hlstd{=}\hlnum{0}\hlstd{,}\hlkwc{xlim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0}\hlstd{,}\hlnum{1}\hlstd{),}\hlkwc{ylim}\hlstd{=}\hlkwd{c}\hlstd{(}\hlnum{0}\hlstd{,}\hlnum{1}\hlstd{),}\hlkwc{type}\hlstd{=}\hlstr{"n"}\hlstd{,}\hlkwc{xlab}\hlstd{=}\hlstr{"altitude"}\hlstd{,}\hlkwc{ylab}\hlstd{=}\hlstr{"estimation log(abondance)"}\hlstd{)}
  \hlkwd{lines}\hlstd{(alti4,evalmyb6[,}\hlstr{"ZOBO"}\hlstd{],}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"red"}\hlstd{)}
  \hlkwd{lines}\hlstd{(alti4,evalmyb6[,}\hlstr{"FOMA"}\hlstd{],}\hlkwc{type}\hlstd{=}\hlstr{"l"}\hlstd{,}\hlkwc{col}\hlstd{=}\hlstr{"black"}\hlstd{)}
\end{alltt}
\end{kframe}
\includegraphics[width=\maxwidth]{figure/unnamed-chunk-39-1} 

\end{knitrout}

# Conclusions

-- L'approche à choisir : une approche statique (type PCOA / coinertie / RLQ) ou une approche par gradient (type FDA). Dépend d'à quel point on a confiance en l'une ou l'autre. Je n'estime pas avoir une connaissance suffisante de l'avifaune réunionnaise pour y répondre clairement : Olivier, ton retour serait vraiment utile.  

-- la suite des analyses : là on décrit juste l'organisation des espèces le long des gradients, il faut aller plus loin. Il y a l'approche traits qui est facile à ajouter aux deux types d'analyses, une répartition des ordinations sur la phylogénie, etc : à voir ce qui est le plus intéressant à vos yeux  

-- la robustesse : les éboulis de variance ne sont pas terrible, les 3-4 premiers axes des ordinations tentées ne représentent pas énormément de variance. Ca suggère des résumés pas hyper pertinents (en tout cas bruités) des gradients qui nous intéressent. Je suis pas très clair sur leur représentation de la réalité du terrain (en particulier pour la matrice habitats).
