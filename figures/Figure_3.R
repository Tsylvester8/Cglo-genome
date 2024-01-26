# Terrence Sylvester
# pradakshanas@gmail.com
# 24 August 2023

library(circlize)

# read in circos karyotype data
CgChroms <- read.table("synteny/Cglo_Tcas/Cglo.karyotype.txt", header = F)
TcChroms <- read.table("synteny/Cglo_Tcas/Tcas.karyotype.txt", header = F)
CgChroms.Td <- read.table("synteny/Cglo_Tdic/Cglo.karyotype.txt", header = F)
TdChroms <- read.table("synteny/Cglo_Tdic/Tdic.karyotype.txt", header = F)

CgChroms <- CgChroms[,c(3,6,7)]
TcChroms <- TcChroms[,c(3,6,7)]
CgChroms.Td <- CgChroms.Td[,c(3,6,7)]
TdChroms <- TdChroms[,c(3,6,7)]

colnames(CgChroms) <- colnames(TcChroms) <- colnames(CgChroms.Td) <- colnames(TdChroms) <- c("cont","length","col")

# read links
link.tc <- read.table("synteny/Cglo_Tcas/Cglo_Tcas/data/Tcas_Cglo_bundles.tsv", header = F)
link.td <- read.table("synteny/Cglo_Tdic/Cglo_Tdic/data/Tdic_Cglo_bundles.tsv", header = F)

for(i in 1:nrow(link.tc)){
  hit <- unlist(strsplit(link.tc$V7[i],split = ","))
  loc <- grep("color", hit)
  link.tc$V7[i] <- gsub("color=", "",hit[loc])
}

for(i in 1:nrow(link.td)){
  hit <- unlist(strsplit(link.td$V7[i],split = ","))
  loc <- grep("color", hit)
  link.td$V7[i] <- gsub("color=", "",hit[loc])
}

# set colours
lgx = "#a50026"
lg2 = "#d73027"
lg3 = "#f46d43"
lg4 = "#fdae61"
lg5 = "#fee090"
lg6 = "#e0f3f8"
lg7 = "#abd9e9"
lg8 = "#74add1"
lg9 = "#4575b4"
lg10 = "#313695"

CgChroms$col[CgChroms$col == "lgx"] <- "#a50026"
CgChroms$col[CgChroms$col == "lg2"] <- "#d73027"
CgChroms$col[CgChroms$col == "lg3"] <- "#f46d43"
CgChroms$col[CgChroms$col == "lg4"] <- "#fdae61"
CgChroms$col[CgChroms$col == "lg5"] <- "#fee090"
CgChroms$col[CgChroms$col == "lg6"] <- "#e0f3f8"
CgChroms$col[CgChroms$col == "lg7"] <- "#abd9e9"
CgChroms$col[CgChroms$col == "lg8"] <- "#74add1"
CgChroms$col[CgChroms$col == "lg9"] <- "#4575b4"
CgChroms$col[CgChroms$col == "lg10"] <- "#313695"

CgChroms.Td$col[CgChroms.Td$col == "lgx"] <- "#a50026"
CgChroms.Td$col[CgChroms.Td$col == "lg2"] <- "#d73027"
CgChroms.Td$col[CgChroms.Td$col == "lg3"] <- "#f46d43"
CgChroms.Td$col[CgChroms.Td$col == "lg4"] <- "#fdae61"
CgChroms.Td$col[CgChroms.Td$col == "lg5"] <- "#fee090"
CgChroms.Td$col[CgChroms.Td$col == "lg6"] <- "#e0f3f8"
CgChroms.Td$col[CgChroms.Td$col == "lg7"] <- "#abd9e9"
CgChroms.Td$col[CgChroms.Td$col == "lg8"] <- "#74add1"
CgChroms.Td$col[CgChroms.Td$col == "lg9"] <- "#4575b4"
CgChroms.Td$col[CgChroms.Td$col == "lg10"] <- "#313695"

TcChroms$col[TcChroms$col == "lgx"] <- "#a50026"
TcChroms$col[TcChroms$col == "lg2"] <- "#d73027"
TcChroms$col[TcChroms$col == "lg3"] <- "#f46d43"
TcChroms$col[TcChroms$col == "lg4"] <- "#fdae61"
TcChroms$col[TcChroms$col == "lg5"] <- "#fee090"
TcChroms$col[TcChroms$col == "lg6"] <- "#e0f3f8"
TcChroms$col[TcChroms$col == "lg7"] <- "#abd9e9"
TcChroms$col[TcChroms$col == "lg8"] <- "#74add1"
TcChroms$col[TcChroms$col == "lg9"] <- "#4575b4"
TcChroms$col[TcChroms$col == "lG10"] <- "#313695"

TdChroms$col[TdChroms$col == "lgx"] <- "#a50026"
TdChroms$col[TdChroms$col == "lg2"] <- "#d73027"
TdChroms$col[TdChroms$col == "lg3"] <- "#f46d43"
TdChroms$col[TdChroms$col == "lg4"] <- "#fdae61"
TdChroms$col[TdChroms$col == "lg5"] <- "#fee090"
TdChroms$col[TdChroms$col == "lg6"] <- "#e0f3f8"
TdChroms$col[TdChroms$col == "lg7"] <- "#abd9e9"
TdChroms$col[TdChroms$col == "lg8"] <- "#74add1"
TdChroms$col[TdChroms$col == "lg9"] <- "#4575b4"
TdChroms$col[TdChroms$col == "lG10"] <- "#313695"

link.tc$V7[link.tc$V7 == "lgx"] <- "#a50026"
link.tc$V7[link.tc$V7 == "lg2"] <- "#d73027"
link.tc$V7[link.tc$V7 == "lg3"] <- "#f46d43"
link.tc$V7[link.tc$V7 == "lg4"] <- "#fdae61"
link.tc$V7[link.tc$V7 == "lg5"] <- "#fee090"
link.tc$V7[link.tc$V7 == "lg6"] <- "#e0f3f8"
link.tc$V7[link.tc$V7 == "lg7"] <- "#abd9e9"
link.tc$V7[link.tc$V7 == "lg8"] <- "#74add1"
link.tc$V7[link.tc$V7 == "lg9"] <- "#4575b4"
link.tc$V7[link.tc$V7 == "lg10"] <- "#313695"

link.td$V7[link.td$V7 == "lgx"] <- "#a50026"
link.td$V7[link.td$V7 == "lg2"] <- "#d73027"
link.td$V7[link.td$V7 == "lg3"] <- "#f46d43"
link.td$V7[link.td$V7 == "lg4"] <- "#fdae61"
link.td$V7[link.td$V7 == "lg5"] <- "#fee090"
link.td$V7[link.td$V7 == "lg6"] <- "#e0f3f8"
link.td$V7[link.td$V7 == "lg7"] <- "#abd9e9"
link.td$V7[link.td$V7 == "lg8"] <- "#74add1"
link.td$V7[link.td$V7 == "lg9"] <- "#4575b4"
link.td$V7[link.td$V7 == "lg10"] <- "#313695"

# set the canvas
par(mfcol = c(1,2), mar= c(0,0,0,0))
#layout(matrix(c(1,2), 1, 1, byrow = TRUE))

# make the input matrix for Dab vs Tcas comparison
contMat <- as.data.frame(matrix(data= 0,nrow = c(nrow(CgChroms) + nrow(TcChroms)), ncol = 2))
rownames(contMat) <- c(TcChroms$cont,CgChroms$cont)
contMat[,2] <- c(TcChroms$length,CgChroms$length)
# re order chromosomes
tc.chrom.order <- c(1,11,2:10,12,13,19,20,17,23,14,18,16,15,22,21,24)
conts <- factor(c(TcChroms$cont,CgChroms$cont), 
                levels = c(TcChroms$cont,CgChroms$cont)[tc.chrom.order])
contMat <- contMat[c(TcChroms$cont,CgChroms$cont)[tc.chrom.order],]
# set chromosome colours
bg.col <- c(TcChroms$col,CgChroms$col)[tc.chrom.order]

# rename chromosomes
names <- c(TcChroms$cont,CgChroms$cont)[tc.chrom.order]
names[c(1,12,13,24)] <- ""
names <- gsub("scaf", "", names)
names <- gsub("lg", "LG", names)
names[14] <- "5"
names[15] <- "6"
names[16] <- "2"
names[17] <- "9"
names[18] <- "3"
names[19] <- "4"
names[20] <- "1"
names[21] <- "8"
names[22] <- "7"
names[23] <- "10"


# make the input matrix for Dab vs pcer comparison
contMat.td <- as.data.frame(matrix(data= 0,nrow = c(nrow(CgChroms.Td) + nrow(TdChroms)), ncol = 2))
rownames(contMat.td) <- c(TdChroms$cont,CgChroms.Td$cont)
contMat.td[,2] <- c(TdChroms$length,CgChroms.Td$length)

td.chrom.order <- c(1,3,8,10,2,6,5,11,4,9,7,12,13,19,20,17,23,14,18,16,15,22,21,24)

conts.td <- factor(c(TdChroms$cont,CgChroms.Td$cont), 
                   levels = c(TdChroms$cont,CgChroms.Td$cont)[])
contMat.td <- contMat.td[c(TdChroms$cont,CgChroms.Td$cont)[td.chrom.order],]
bg.col.td <- c(TdChroms$col,CgChroms.Td$col)[td.chrom.order]

names.td <- c(TdChroms$cont,CgChroms.Td$cont)[td.chrom.order]
names.td[c(1,12,13,24)] <- ""
names.td <- gsub("scaf", "", names.td)
names.td[14] <- "5"
names.td[15] <- "6"
names.td[16] <- "2"
names.td[17] <- "9"
names.td[18] <- "3"
names.td[19] <- "4"
names.td[20] <- "1"
names.td[21] <- "8"
names.td[22] <- "7"
names.td[23] <- "10"

# plot 1
circos.par("start.degree" = 90,
           "gap.degree" = 1,
           "track.height" = 0.05,
           "cell.padding" = c(0.02, 0, 0.02, 0))
circos.initialize(xlim = contMat)
circos.labels(sectors = c(TcChroms$cont,CgChroms$cont)[tc.chrom.order],
              x = contMat$V2/2,
              labels = names,
              padding = 0.4,
              facing = "reverse.clockwise",
              side = "outside",
              connection_height = mm_h(0.1),
              line_col = "white",
              cex = 1.2)
circos.track(conts, 
             ylim = c(0,0.1),
             bg.col = bg.col,
             bg.border = bg.col)

for(i in 1:nrow(link.tc)){
  circos.link(link.tc$V1[i] ,
              c(link.tc$V2[i],link.tc$V3[i]),
              link.tc$V4[i], 
              c(link.tc$V5[i],link.tc$V6[i]),
              col = link.tc$V7[i])  
}

mtext(text = "A",side = 3,adj = 0.05, line = -2,font = 2, cex = 2)
circos.clear()

text(x = -.8, y = -.8, labels = "C. gloriosa", font = 3,cex = 1.2)
text(x = .8, y = .8, labels = "T. castaneum", font = 3,cex = 1.2)


# plot 2
circos.par("start.degree" = 90,
           "gap.degree" = 1,
           "track.height" = 0.05,
           "cell.padding" = c(0.02, 0, 0.02, 0))

circos.initialize(xlim = contMat.td)
circos.labels(sectors = c(TdChroms$cont,CgChroms.Td$cont)[td.chrom.order],
              x = contMat.td$V2/2,
              labels = names.td,
              side = "outside",
              connection_height = mm_h(1),
              line_col = "white",
              cex = 1.2)
circos.track(conts.td, 
             ylim = c(0,0.1),
             bg.col = bg.col.td,
             bg.border = bg.col.td)


for(i in 1:nrow(link.td)){
  circos.link(link.td$V1[i] ,
              c(link.td$V2[i],link.td$V3[i]),
              link.td$V4[i], 
              c(link.td$V5[i],link.td$V6[i]),
              col = link.td$V7[i])  
}

mtext(text = "B",side = 3,adj = 0.05, line = -2, font = 2, cex = 2)
circos.clear()

text(x = -.8, y = -.8, labels = "C. gloriosa", font = 3, cex = 1.2)
text(x = .8, y = .8, labels = "T. dichotomus", font = 3, cex = 1.2)
