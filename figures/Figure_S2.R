# pradakshanas@gmail.com
# December 15 2021
# analysis of depth of coverage

# read data
# get names of files
files <- dir("../Depth-stats/")
# make an object to store data
dat <- vector(mode = "list", length = length(files))
# get data
for(i in 1:length(files)){
  dat[[i]] <- read.table(paste("../Depth-stats/", files[i], sep = ""))  
}
# remove unneccessary wording from the speciman names
sp <- gsub("sorted_filtered_sorted_nuclear_trim_paired_", "", files)
sp <- gsub("_R1_001.txt", "", sp)
# get data for first 13 scaffolds
cov <- matrix(data = NA,
              ncol = length(sp) + 1,
              nrow = 13)
# fill in values
colnames(cov) <- c("contig", sp)
cov[,1] <- dat[[1]]$V1[1:13]
# get normalized coverage for each contig
for(i in 1:length(dat)){
  cov[,(i+1)] <- dat[[i]]$V7[1:13]/ mean(dat[[i]]$V7[1:12])
}
# plot and see if we have male reads
plot(y = cov[,2], pch = 16,
     x = jitter(1:13, factor = 1),
     ylim = c(0.4,1.2),
     # type = "l",
     col = if(cov[13,2] < 0.7) "#fdb86380" else "#5e3c9980",
     ylab = "Normalized mean coverage per contig",
     xlab = "Scaffold",
     cex = 0.5,axes = F)
for(i in 3:(ncol(cov))){
  points(cov[,i],
         x = jitter(1:13, factor = 1),
        pch = 16,
        col = if(cov[13,i] < 0.7) "#fdb86380" else "#5e3c9980",
        cex = 0.5)
}

axis(side = 1, at = 1:13)
axis(side = 2)

abline(v = c(1:13), lty = 2, col = "grey")
abline(h = c(mean(as.numeric(cov[1:12,2:82][cov[13,2:82]>0.7]))),lty = 2, col = "#e66101")
# abline(h = c(mean(as.numeric(cov[13,2:82][cov[13,2:82]<0.7]))), lty = 2, col = "#e66101")

text(x = 1:13,
     y = 1.23,labels = paste("Scaffold", 1:13),srt = 90,
     pos = 2,
     cex = 0.8)

legend("bottomleft",
       inset=.02,
       legend = c("Male","Female","Average coverage of autosomal scaffolds"),
       pch = c(16,16,NA),
       lty=c(NA,NA,2),
       col = c("#fdb863", "#5e3c99","#e66101"),
       horiz=F,
       cex=1)


# get the number of males in the sample
males <- colnames(cov[,2:ncol(cov)])[(cov[13,2:82] < 0.7)]
females <- colnames(cov[,2:ncol(cov)])[(cov[13,2:82] > 0.7)]
write(x = males, file = "males.txt")
write(x = females, file = "females.txt")
