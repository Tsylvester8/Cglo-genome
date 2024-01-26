# Terrence Sylvester
# 25/5/2023
# pradakshanas@gmail.com

# load librarys
library(reshape)
library(ggplot2)
library(viridis)
library(hrbrthemes)
library(tidyverse)
library(gridExtra)

# read kimura distances
KimuraDistance <- read.csv("../data/Chrysina_gloriosa.kimura.distance.csv",sep=" ")

# keep only the parent repeat category
for(i in 1:ncol(KimuraDistance)){
  colnames(KimuraDistance)[i] <- unlist(strsplit(colnames(KimuraDistance)[i],split = ".",fixed = T))[1]
}

# get the total basepairs for a given divergence group
# DNA
DNA <- KimuraDistance[,colnames(KimuraDistance) == "DNA"]
DNA_sum <- rowSums(DNA)
# LINE
LINE <- KimuraDistance[,colnames(KimuraDistance) == "LINE"]
LINE_sum <- rowSums(LINE)
# LTR
LTR <- KimuraDistance[,colnames(KimuraDistance) == "LTR"]
LTR_sum <- rowSums(LTR)
# SINE
SINE <- KimuraDistance[,colnames(KimuraDistance) == "SINE"]
SINE_sum <- rowSums(SINE)
# Satellite
Satellite <- KimuraDistance[,colnames(KimuraDistance) == "Satellite"]
# Simple repeats
Simple_repeat <- KimuraDistance[,colnames(KimuraDistance) == "Simple_repeat"]

# comibe above data into a single table
reps <- as.data.frame(matrix(nrow = nrow(KimuraDistance),ncol = 7))
colnames(reps) <- c("Div","DNA","LINE","LTR","SINE","Satellite","SSR")
reps$Div <- KimuraDistance$Div
reps$DNA <- DNA_sum
reps$LINE <- LINE_sum
reps$LTR <- LTR_sum
reps$SINE <- SINE_sum
reps$Satellite <- Satellite
reps$SSR <- Simple_repeat

#add here the genome size in bp
genomes_size=642274021

# get the percentage of the genome for a given divergence category
kd_melt = melt(reps[,c(1:5)],id="Div")
kd_melt$norm = kd_melt$value/genomes_size * 100

# plot
ggplot(kd_melt, aes(fill=variable, y=norm, x=Div)) + 
  geom_bar(position="stack", stat="identity",color="white",width = .99) +
  scale_fill_viridis_d() +
  theme_classic() +
  xlab("Kimura substitution level") +
  ylab("Percent of the genome") + 
  labs(fill = "") +
  coord_cartesian(xlim = c(0, 55)) +
  theme(axis.text=element_text(size=11),axis.title =element_text(size=12))
