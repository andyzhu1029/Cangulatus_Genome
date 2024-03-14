rm(list = ls())
setwd("/Users/andy_zhu/Downloads/01-Recent_Tasks/01-AGIS/02-Cangulatus/04-Evolution_Analysis/02-Synteny_Analysis/02-4DTv")
library(ggplot2)
dat <- read.table("merge_4dtv.txt",header = T)
p <- ggplot(dat, aes(x=dtv,color= Species,linetype = ortholog)) +
  geom_density(lwd=1, alpha=0.5) +
  scale_color_manual(values = c("CanA_CanA"='#FF0000',"Twi_Twi"='#FF00FF',"CanA_Twi"='#008000',
                                "Vvi_Vvi"='#800080','CanA_Vvi'='#0000FF',
                                'Rco_Rco'='#FF8C00','CanA_Rco'='#7CFC00',
                                'Pti_Pti'='#FF1493','CanA_Pti'='#1f78b4')) +
  scale_linetype_manual(values = c("paralog" = 'solid', "ortholog"='dashed'))+
  labs(x='4DTv value',y='Density')+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(size = 0.7, colour = "black"),
        axis.ticks.length.x = unit(0.2,'cm'),
        axis.text.x = element_text(size = 10, family = "serif", colour = 'black',face = 'bold'),
        axis.title.x = element_text(size = 20,family = 'serif', colour = 'black',face = 'bold'),
        axis.ticks.length.y = unit(0.2, 'cm'),
        axis.text.y = element_text(size = 10, family = 'serif', colour = 'black',face = 'bold'),
        axis.title.y = element_text(size = 20,family = 'serif', colour = 'black',face = 'bold'),
        legend.position = c(0.8,0.6),
        legend.key = element_rect(fill = "transparent", color = NA),
        legend.title=element_blank())+
        scale_y_continuous(breaks = seq(0,4,1),limits =c(0,4),expand = c(0,0))+
        scale_x_continuous(breaks = seq(0,1.5,0.5),limits =c(0,1.5),expand = c(0,0))
p
ggsave(p, file="4DTv.pdf", width=8, height=7) 
