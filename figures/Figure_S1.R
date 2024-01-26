# Terrence Sylvester
# pradakshanas@gmail.com
# 26 May 2023

# load library
library(ggplot2)
library(gridExtra)
library(grid)

#### helper function ####
remove.overlaps <- function(dat = NULL){
  
  dat_new <- matrix(data = NA, nrow = nrow(dat), ncol = ncol(dat))
  dat_new <- as.data.frame(dat_new)
  colnames(dat_new) <- colnames(dat)
  
  counter <- 1
  for(i in 1:nrow(dat)){
    if(i > 1){
      if(j > i){
        next
      }
    }
    j <- i
    print(i)
    start <- dat$start[j]
    end <- dat$end[j]
    
    if((j + 1) > nrow(dat)){
      break
    }
    while (dat$start[j+1] < end) {
      j <- j + 1
      end <- dat$end[j] 
      if((j + 1)> nrow(dat)){
        break
      }
    }
    dat_new$scaffold[counter] <- dat$scaffold[counter]
    dat_new$start[counter] <- start
    dat_new$end[counter] <- end
    dat_new$repeatClass[counter] <- dat$repeatClass[counter]
    
    counter <- counter + 1
  }
  dat_new <- dat_new[!(is.na(dat_new$scaffold)),]
  return(dat_new)
}
#####


# read in data
repeats <-  read.csv("../data/Chrysina_gloriosa.repeats.csv", 
                     header = F,
                     as.is = T)
# assign column names
colnames(repeats) <- c("scaffold", "start", "end", "repeatClass")
# get chromosome
interval <- 100000

for(j in 1:10){
  scaffold <- paste("scaf",j, sep = "")
  print(paste("working on", scaffold))
  #names(Chroms)[j] <- scaffold
  scaf <- repeats[repeats$scaffold == scaffold,]
  # remove repeat family and retain only repeat class
  for(i in 1:nrow(scaf)){
    scaf$repeatClass[i] <- unlist(strsplit(scaf$repeatClass[i],split = "/",fixed = T))[1]
    if(i %% 10000 == 0){
      print(i)
    } 
  }
  
  scafLength <- NULL
  if(scaffold == "scaf1") scafLength <- 109611085
  if(scaffold == "scaf2") scafLength <- 81599725
  if(scaffold == "scaf3") scafLength <- 75050035
  if(scaffold == "scaf4") scafLength <- 72353455
  if(scaffold == "scaf5") scafLength <- 67692486
  if(scaffold == "scaf6") scafLength <- 59159807
  if(scaffold == "scaf7") scafLength <- 58964884
  if(scaffold == "scaf8") scafLength <- 56816963
  if(scaffold == "scaf9") scafLength <- 36732878
  if(scaffold == "scaf10") scafLength <- 13479537
  
  # subset each repeat class
  DNA <- scaf[scaf$repeatClass =="DNA",]
  LINE <- scaf[scaf$repeatClass =="LINE",]
  SINE <- scaf[scaf$repeatClass =="SINE",]
  sat <- scaf[scaf$repeatClass =="Satellite",]
  smpl <- scaf[scaf$repeatClass =="Simple_repeat",]
  unk <- scaf[scaf$repeatClass =="Unknown",]
  
  # set the target interval to 10Kb 
  breaks <-  seq(from = 1,
                 to = scafLength,
                 by = interval)
  
  tab_DNA <- as.data.frame(matrix(nrow = length(breaks), ncol = 3))
  tab_LINE <- as.data.frame(matrix(nrow = length(breaks), ncol = 3))
  tab_SINE <- as.data.frame(matrix(nrow = length(breaks), ncol = 3))
  tab_sat <- as.data.frame(matrix(nrow = length(breaks), ncol = 3))
  tab_smpl <- as.data.frame(matrix(nrow = length(breaks), ncol = 3))
  tab_unk <- as.data.frame(matrix(nrow = length(breaks), ncol = 3))
  
  colnames(tab_DNA) <- colnames(tab_LINE) <- colnames(tab_SINE) <- colnames(tab_sat) <- colnames(tab_unk) <- colnames(tab_smpl) <- c("interval","amount", "calss")
  
  tab_DNA$interval <- breaks / 1000000
  tab_LINE$interval <- breaks / 1000000
  tab_SINE$interval <- breaks / 1000000
  tab_sat$interval <- breaks / 1000000
  tab_smpl$interval <- breaks / 1000000
  tab_unk$interval <- breaks / 1000000
  
  tab_DNA$calss <- "DNA transposon"
  tab_LINE$calss <- "LINE"
  tab_SINE$calss <- "SINE"
  tab_sat$calss <- "Macrosatellite"
  tab_smpl$calss <- "Microsatellite"
  tab_unk$calss <- "Unclassified transposon"
  
  for (i in 1:length(breaks)){
    tmp_DNA <- DNA[DNA$start >= (breaks[i]) & DNA$end <= (breaks[i] + (interval-1)),]
    tmp_LINE <- LINE[LINE$start >= (breaks[i]) & LINE$end <= (breaks[i] + (interval-1)),]
    tmp_SINE <- SINE[SINE$start >= (breaks[i]) & SINE$end <= (breaks[i] + (interval-1)),]
    tmp_sat <- sat[sat$start >= (breaks[i]) & sat$end <= (breaks[i] + (interval-1)),]
    tmp_smpl <- smpl[smpl$start >= (breaks[i]) & smpl$end <= (breaks[i] + (interval-1)),]
    tmp_unk <- unk[unk$start >= (breaks[i]) & unk$end <= (breaks[i] + (interval-1)),]
    
    tmp_DNA <- remove.overlaps(dat = tmp_DNA)
    tmp_LINE <- remove.overlaps(dat = tmp_LINE)
    tmp_SINE <- remove.overlaps(dat = tmp_SINE)
    tmp_sat <- remove.overlaps(dat = tmp_sat)
    tmp_smpl <- remove.overlaps(dat = tmp_smpl)
    tmp_unk <- remove.overlaps(dat = tmp_unk)
    
    
    if(nrow(tmp_DNA) > 0){
      tab_DNA$amount[i] <- (sum((tmp_DNA$end - tmp_DNA$start) + 1) /interval) * 100
    }else{
      tab_DNA$amount[i] <- 0
    }
    
    if(nrow(tmp_LINE) > 0){
      tab_LINE$amount[i] <- (sum((tmp_LINE$end - tmp_LINE$start) + 1) /interval) * 100
    }else{
      tab_LINE$amount[i] <- 0
    }
    
    if(nrow(tmp_SINE) > 0){
      tab_SINE$amount[i] <- (sum((tmp_SINE$end - tmp_SINE$start) + 1) /interval) * 100
    }else{
      tab_SINE$amount[i] <- 0
    }
    
    if(nrow(tmp_sat) > 0){
      tab_sat$amount[i] <- (sum((tmp_sat$end - tmp_sat$start) + 1) /interval) * 100
    }else{
      tab_sat$amount[i] <- 0
    }
    
    if(nrow(tmp_smpl) > 0){
      tab_smpl$amount[i] <- (sum((tmp_smpl$end - tmp_smpl$start) + 1) /interval) * 100
    }else{
      tab_smpl$amount[i] <- 0
    }
    
    if(nrow(tmp_unk) > 0){
      tab_unk$amount[i] <- (sum((tmp_unk$end - tmp_unk$start) + 1) /interval) * 100
    }else{
      tab_unk$amount[i] <- 0
    }
    
  }
  
  type.color <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                  "#0072B2", "#D55E00", "#CC79A7")
  
  # plot
  tab_retro <- tab_LINE
  tab_retro$calss <- "Retroelements"
  tab_retro$amount <- tab_LINE$amount + tab_SINE$amount
  
  # combine all scaffold data
  scaf.reps <- NULL
  scaf.reps <- rbind(tab_DNA,tab_retro,tab_sat,tab_smpl,tab_unk)
  scaf.reps$calss <- factor(scaf.reps$calss, levels = c("Macrosatellite",
                                                        "Microsatellite",
                                                        "DNA transposon",
                                                        "Retroelements",
                                                        "Unclassified transposon"))
  pp <- NULL
  pp <-  ggplot(data = scaf.reps, aes(x = scaf.reps$interval, y = amount, fill = calss, group = calss)) +
    geom_bar(stat = "identity",width = 0.2) +
    labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
    facet_grid(rows = vars(scaf.reps$calss),
               scales = "free", 
               space = "fixed") +
    guides(fill = guide_legend(title = "Repeat Type")) +
    scale_fill_manual(values = type.color) +
    theme_classic() +
    theme(strip.text.y = element_blank(),axis.text.y = element_text(size = 5)) 
  assign(paste0("plot_", j),pp)
}

plot_1$data$scaf <- "scaf1"
plot_2$data$scaf <- "scaf2"
plot_3$data$scaf <- "scaf3"
plot_4$data$scaf <- "scaf4"
plot_5$data$scaf <- "scaf5"
plot_6$data$scaf <- "scaf6"
plot_7$data$scaf <- "scaf7"
plot_8$data$scaf <- "scaf8"
plot_9$data$scaf <- "scaf9"
plot_10$data$scaf <- "scaf10"

repDat <- rbind(plot_1$data,
                plot_2$data,
                plot_3$data,
                plot_4$data,
                plot_5$data,
                plot_6$data,
                plot_7$data,
                plot_8$data,
                plot_9$data,
                plot_10$data)

p1 <-  ggplot(data = repDat[repDat$scaf == "scaf1",], aes(x = repDat$interval[repDat$scaf == "scaf1"],
                                                       y = repDat$amount[repDat$scaf == "scaf1"],
                                                       fill = repDat$calss[repDat$scaf == "scaf1"], 
                                                       group = repDat$calss[repDat$scaf == "scaf1"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf1"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("A)") +
  theme(strip.text.y = element_blank(),legend.position = "none",
        plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p2 <-  ggplot(data = repDat[repDat$scaf == "scaf2",], aes(x = repDat$interval[repDat$scaf == "scaf2"],
                                                      y = repDat$amount[repDat$scaf == "scaf2"],
                                                      fill = repDat$calss[repDat$scaf == "scaf2"], 
                                                      group = repDat$calss[repDat$scaf == "scaf2"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf2"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("B)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p3 <-  ggplot(data = repDat[repDat$scaf == "scaf3",], aes(x = repDat$interval[repDat$scaf == "scaf3"],
                                                      y = repDat$amount[repDat$scaf == "scaf3"],
                                                      fill = repDat$calss[repDat$scaf == "scaf3"], 
                                                      group = repDat$calss[repDat$scaf == "scaf3"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf3"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("C)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p4 <-  ggplot(data = repDat[repDat$scaf == "scaf4",], aes(x = repDat$interval[repDat$scaf == "scaf4"],
                                                      y = repDat$amount[repDat$scaf == "scaf4"],
                                                      fill = repDat$calss[repDat$scaf == "scaf4"], 
                                                      group = repDat$calss[repDat$scaf == "scaf4"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf4"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("D)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p5 <-  ggplot(data = repDat[repDat$scaf == "scaf5",], aes(x = repDat$interval[repDat$scaf == "scaf5"],
                                                      y = repDat$amount[repDat$scaf == "scaf5"],
                                                      fill = repDat$calss[repDat$scaf == "scaf5"], 
                                                      group = repDat$calss[repDat$scaf == "scaf5"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf5"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("E)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p6 <-  ggplot(data = repDat[repDat$scaf == "scaf6",], aes(x = repDat$interval[repDat$scaf == "scaf6"],
                                                      y = repDat$amount[repDat$scaf == "scaf6"],
                                                      fill = repDat$calss[repDat$scaf == "scaf6"], 
                                                      group = repDat$calss[repDat$scaf == "scaf6"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf6"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("F)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p7 <-  ggplot(data = repDat[repDat$scaf == "scaf7",], aes(x = repDat$interval[repDat$scaf == "scaf7"],
                                                      y = repDat$amount[repDat$scaf == "scaf7"],
                                                      fill = repDat$calss[repDat$scaf == "scaf7"], 
                                                      group = repDat$calss[repDat$scaf == "scaf7"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf7"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("G)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p8 <-  ggplot(data = repDat[repDat$scaf == "scaf8",], aes(x = repDat$interval[repDat$scaf == "scaf8"],
                                                      y = repDat$amount[repDat$scaf == "scaf8"],
                                                      fill = repDat$calss[repDat$scaf == "scaf8"], 
                                                      group = repDat$calss[repDat$scaf == "scaf8"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf8"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("H)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p9 <-  ggplot(data = repDat[repDat$scaf == "scaf9",], aes(x = repDat$interval[repDat$scaf == "scaf9"],
                                                      y = repDat$amount[repDat$scaf == "scaf9"],
                                                      fill = repDat$calss[repDat$scaf == "scaf9"], 
                                                      group = repDat$calss[repDat$scaf == "scaf9"])) +
  geom_bar(stat = "identity",width = 0.2) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf9"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("I)") +
  theme(strip.text.y = element_blank(),legend.position = "none",plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),axis.text.y = element_text(size = 5)) 

p10 <-  ggplot(data = repDat[repDat$scaf == "scaf10",], aes(x = repDat$interval[repDat$scaf == "scaf10"],
                                                      y = repDat$amount[repDat$scaf == "scaf10"],
                                                      fill = repDat$calss[repDat$scaf == "scaf10"], 
                                                      group = repDat$calss[repDat$scaf == "scaf10"])) +
  geom_bar(stat = "identity",width = 0.1) +
  labs(x = "Position on sequence (Mbp)", y = "Percent repetitive DNA") +
  facet_grid(rows = vars(repDat$calss[repDat$scaf == "scaf10"]),
             scales = "free", 
             space = "fixed") +
  guides(fill = guide_legend(title = "Repeat Type")) +
  scale_fill_manual(values = type.color) +
  theme_classic() +
  ggtitle("J)") +
  theme(strip.text.y = element_blank(),
        plot.title = element_text(color="Black", size=12, face="bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_text(size = 5)) 

gridExtra::grid.arrange(grobs = list(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10),
                        
                        layout_matrix = rbind(c(1, 2, 3),
                                              c(4, 5, 6),
                                              c(7, 8, 9),
                                              c(10,10,NA)),
                        left = "Percent repetitive DNA",
                        bottom = "Position on sequence (Mbp)")
