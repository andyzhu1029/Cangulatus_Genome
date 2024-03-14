rm(list = ls())
#install.packages("ggridges")
#if (!requireNamespace("BioManager", quietly = TRUE))
#  install.packages("BioManager")
#BiocManager::install("magrittr") 
#BiocManager::install("dplyr") 

library("magrittr") #for %>%
library(dplyr) #for select function
library(ggplot2)
library(ggridges)

setwd("/Users/andy_zhu/Downloads/01-Recent_Tasks/01-AGIS/02-Cangulatus/04-Evolution_analysis/02-KaKs")

ks_data = read.table("merge_ks.txt",header = F)
colnames(ks_data) <- c('species','ks') # Rename and replace the column names (header = F) of the data frame

#define a function that identify density plot peak
densFindPeak <- function(x) {
  td <- density(x,adjust = 1/2)
  maxDens <- which.max(td$y)  #the position of the element which the maximal value in a vector.
  list(x=td$x[maxDens],y=td$y[maxDens])
}

#CanA_CanA peak
CanA_ks <- ks_data %>%  filter(species == 'CanA_CanA') %>% select(ks) # filter() function, subset a data frame, retaining all rows that satisfy conditions.
CanA_ks_limit1 <- CanA_ks$ks[CanA_ks$ks >= 0 & CanA_ks$ks <=1]
CanA_ks_peak1 = densFindPeak(CanA_ks_limit1) #0.1981212

CanA_ks_limit2 <- CanA_ks$ks[CanA_ks$ks >= 1 & CanA_ks$ks <=2.5]
CanA_ks_peak2 = densFindPeak(CanA_ks_limit2) #2.078022

#Twi_Twi peak
Twi_ks <- ks_data %>%  filter(species == 'Twi_Twi') %>% select(ks) 
Twi_ks_limit1 <- Twi_ks$ks[Twi_ks$ks >= 0 & Twi_ks$ks <=1]
Twi_ks_peak1 = densFindPeak(Twi_ks_limit1) #0.1595298

#loop
#for (i in c ('Twi_Twi_ks','Rco_Rco_ks','Pti_Pti_ks','Vvi_Vvi_ks','CanA_Twi_ks','CanA_Pti_ks','CanA_Rco_ks','CanA_Vvi_ks')) {
 # i <- ks_data %>%  filter(species == 'i') %>% select(ks) 
#  i_limit1 <-i$ks[i_ks$ks >= 0 & i$ks <=1]
#  i_peak1 = densFindPeak(i_limit1)
#} 

#Rco_Rco peak
Rco_ks <- ks_data %>%  filter(species == 'Rco_Rco') %>% select(ks) 
Rco_ks_limit1 <-Rco_ks$ks[Rco_ks$ks >= 0 & Rco_ks$ks <=1]
Rco_ks_peak1 = densFindPeak(Rco_ks_limit1) #0.8350758

#Pti_Pti peak
Pti_ks <- ks_data %>%  filter(species == 'Pti_Pti') %>% select(ks) 
Pti_ks_limit1 <-Pti_ks$ks[Pti_ks$ks >= 0 & Pti_ks$ks <=1]
Pti_ks_peak1 = densFindPeak(Pti_ks_limit1) #0.2299008

#Vvi_Vvi peak
Vvi_ks <- ks_data %>%  filter(species == 'Vvi_Vvi') %>% select(ks) 
Vvi_ks_limit1 <-Vvi_ks$ks[Vvi_ks$ks >= 1.5 & Vvi_ks$ks <=2.5]
Vvi_ks_peak1 = densFindPeak(Vvi_ks_limit1) #1.560698

#CanA_Vvi peak
CanA_Vvi_ks <- ks_data %>%  filter(species == 'CanA_Vvi') %>% select(ks) 
CanA_Vvi_ks_limit1 <-CanA_Vvi_ks$ks[CanA_Vvi_ks$ks >= 1 & CanA_Vvi_ks$ks <=2]
CanA_Vvi_ks_peak1 = densFindPeak(CanA_Vvi_ks_limit1) #1.38778

#CanA_Twi
CanA_Twi_ks <- ks_data %>%  filter(species == 'CanA_Twi') %>% select(ks) 
CanA_Twi_ks_limit1 <- CanA_Twi_ks$ks[CanA_Twi_ks$ks >= 0 & CanA_Twi_ks$ks <=0.6]
CanA_Twi_ks_peak1 = densFindPeak(CanA_Twi_ks_limit1) #0.07694491

#CanA_Pti
CanA_Pti_ks <- ks_data %>%  filter(species == 'CanA_Pti') %>% select(ks) 
CanA_Pti_ks_limit1 <- CanA_Pti_ks$ks[CanA_Pti_ks$ks >= 0 & CanA_Pti_ks$ks <=0.6]
CanA_Pti_ks_peak1 = densFindPeak(CanA_Pti_ks_limit1) #0.5819391

#CanA_Rco
CanA_Rco_ks <- ks_data %>%  filter(species == 'CanA_Rco') %>% select(ks) 
CanA_Rco_ks_limit1 <- CanA_Rco_ks$ks[CanA_Rco_ks$ks >= 0 & CanA_Rco_ks$ks <=0.6]
CanA_Rco_ks_peak1 = densFindPeak(CanA_Rco_ks_limit1) #0.552019

## Ridges plot 山脊图
#define level of species
ks_data$species <- factor(ks_data$species,levels = c('CanA_CanA','Twi_Twi','Rco_Rco',
                                                     'Pti_Pti','Vvi_Vvi','CanA_Twi',
                                                     'CanA_Pti','CanA_Rco','CanA_Vvi'))

ks_data %>% ggplot(aes(x=ks,y=species,fill = species)) + 
  geom_density_ridges(scale = 3, bandwidth = 0.08, color = F) +
  geom_vline(xintercept = 0.1981212, color = 'black', linetype = 'dashed') + 
  #geom_vline(xintercept = 0.6235556, color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 0.1595298,color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 0.8350758,color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 0.2299008,color = 'black', linetype = 'dashed') +
  geom_vline(xintercept = 2.078022,color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 1.38778,color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 0.07694491,color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 0.5819391,color = 'black', linetype = 'dashed') +
  #geom_vline(xintercept = 0.552019,color = 'black', linetype = 'dashed') +
  scale_x_continuous(limits =c(0,2.5),expand = c(0.015,0)) +
  scale_y_discrete(expand = c(0.05,0)) + 
  scale_fill_manual(values = c("#DC143C",'#B0C4DE', "#6495ED", "#FF8C00", '#2E8B57', "#FF6347", "#87CEFA", "#F4A460", '#3CB371')) +
  guides(fill = FALSE) +
  theme_classic() + 
  theme_ridges(font_size = 13, grid = FALSE) +
  theme(axis.title.y = element_blank()) #axis.title delete




