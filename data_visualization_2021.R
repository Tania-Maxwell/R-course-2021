#Source script for LOVE'R course: ggplot2 and data visualization 
#PB Stats 2021

#https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf


#####Install packages and libraries #####
# install packages that are not already installed
if (!require(datasets)) install.packages('datasets')
if (!require(ggplot2)) install.packages('ggplot2')
if (!require(plyr)) install.packages('plyr')
if (!require(ggpubr)) install.packages('ggpubr')


# potential errors for non windows users with these (non-essential)
if (!require(rvg)) install.packages('rvg')
if (!require(svglite)) install.packages('svglite')
if (!require(officer)) install.packages('officer') #needed for the sans serif font
if (!require(extrafont)) install.packages('extrafont')


library(ggplot2)
library(datasets)
library(dplyr)
library(ggpubr)
library(ggThemeAssist)

#Installation for windows only, not essential
library(rvg) 
library(svglite)
library(officer)
library(extrafont)

theme_intro<-   theme_classic()+
  theme(axis.title.x=element_text(angle=0, size=40, family="serif",color = "black"),
        axis.text.x = element_text(size=40,family="serif",color = "black"),
        axis.title.y=element_text(angle=0, size=40, hjust=.5, vjust=.5,family="serif",color = "black"),
        axis.text.y = element_text(size=40,family="serif",color = "black"),
        legend.title=element_text(size=40, face="bold", hjust=.5, family="serif"), #editing the legend
        legend.text=element_text(size=40, family="serif"),
        legend.background = element_rect(linetype="solid", colour ="black"),
        legend.key.size = unit(1.5,"line"),
        legend.position = c(0.6, 0.2))



######Getting started#########

#The data we will be working with comes in the datasets package
?Orange

#download the dataset (available from the package "datasets")
tab<- Orange
str(tab) #look at the structure of your data


#1. Basic ggplot - setting up a canvas on which to add your work
# aes = aesthetics are a group of parameters that specify what and how data is displayed
p<- ggplot(tab, aes(x=age, y=circumference)) 
p

# ggsave("1_basic.emf", plot = p,width=6, height=6, dpi=300, device="emf")
# x11()
# p

#once your canvas is ready, you can add different layers. 

#Use a geom to represent data points
#use the geom's aesthetic properties to represent variables.
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point()#scatterplot #aes --> without "aes", ggplot will not group them by the Tree factor
p

#ggsave("2_basic.emf", plot = p,width=6, height=6, dpi=300, device="emf")

#####How do you want to present your data?#####

##by different colors?
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, color=Tree))#scatterplot #aes --> how to group your points
#here you group your data points by Tree
p

levels(tab$Tree)


tab$Tree <-factor(tab$Tree, levels = c("1","2","3","4","5"))

#ggsave("3_color2.emf", plot = p,width=6, height=6, dpi=300, device="emf")

#importance of which color you choose
#see website:
#http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette 

#creating your own palette; ex:colorblind palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, color=Tree))+#scatterplot #aes --> how to group your points 
  scale_color_manual(name = "Tree ID",values=cbPalette)
p

#ggsave("4_color.emf", plot = p,width=6, height=6, dpi=300, device="emf")

#hard to distinguish some points: 
#using your own chosen colors in the hexadecimal color code chart
#increase the point size

#tips on choosing your colors
#http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3

p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, color=Tree), size =2.5)+
  scale_color_manual(name = "Tree ID",
                     values=c("#999999", "#E69F00", "#56B4E9", "#D55E00", "#CC79A7"))
p

#ggsave("5_color.emf", plot = p,width=6, height=6, dpi=300, device="emf")

#by shapes?
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree),size=2.5)#shape - how to distinguish your points
p
#ggsave("6_shape.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#manually selecting the shapes
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree), size=2.5) + 
  scale_shape_manual(name = "Tree ID",values=c(0,1,2,3,4)) #manually adding the shapes
p

#ggsave("7_shape.emf", plot = p,width=6, height=6, dpi=300, device="emf")

library(ggThemeAssist)
#how about by both?
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree), size=2.5) + 
  #if you want the shapes to be able to be filled, need to choose appropiate shape values (21,22,etc)
  scale_shape_manual(name = "Tree ID",values=c(21,22,23,24,25))+ #manually adding the shapes
  scale_fill_manual(name="Tree ID", values=c("#999999", "#E69F00", "#56B4E9", "#D55E00", "#CC79A7")) +#same values as the color
  theme(axis.ticks = element_line(colour = "black"),
    axis.text = element_text(size = 16),
    panel.background = element_rect(fill = "khaki2"))
p 
#ggsave("8_shape_color.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#however, only use color when necessary
#here, we can easily give the information in black and white 
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree), size=2.5) + 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ #manually adding the shapes
  scale_fill_manual(name="Tree ID",
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF")) #same values as the color
p

#ggsave("9_shape_color.emf", plot = p,width=6, height=6, dpi=300, device="emf")



######axis labels############
#a reader/audience should be able to understand the figure without the caption
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree), size=2.5) + #scatterplot #aes --> how to group your points 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ #manually adding the shapes
  scale_fill_manual(name="Tree ID", values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ #same values as the color
  labs(x="Age (days)", y="Tree trunk circumference (mm) ")
p

#ggsave("10_axis.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#####Adding a theme#####

#themes by ggplot
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree), size=2.5) + #scatterplot #aes --> how to group your points 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ #manually adding the shapes
  scale_fill_manual(name="Tree ID", 
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ #same values as the color
  labs(x="Age (days)", y="Tree trunk circumference (mm) ")+
  theme_classic()
p

#ggsave("11_theme.emf", plot = p,width=6, height=6, dpi=300, device="emf")

#starting to personalize it
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree), size=2.5) + #scatterplot #aes --> how to group your points 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ #manually adding the shapes
  scale_fill_manual(name="Tree ID", 
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ #same values as the color
  labs(x="Age (days)", y="Tree trunk circumference (mm) ")+
  theme_classic()+
  theme(panel.border = element_rect(linetype = "solid", fill = "NA"))+ #box drawn around the figure
  #now to manually edit the axes
  #angle = 0 horizontoal; angle = 30 sideways, =90 vertical
  #size= font size - increase this for presentations 
  #color= "black" - R uses a dark grey by deffault
  #family = "serif" for Times New Roman, "sans" for Arial, "mono" for Courrier monospaced
  #hjust = 0.5 in the middle
  theme(axis.title.x=element_text(angle=0, size=14, family="serif",color = "black"), #x-axis title
        axis.text.x = element_text(angle =0, size=12,family="serif",color = "black"), #x-axis text 
        axis.title.y=element_text(angle=90, size=14, hjust=.5, vjust=.5,family="serif",color = "black"), #y-axis title
        axis.text.y = element_text(size=12,family="serif",color = "black")) #y-axis text 
p

#ggsave("12_theme.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#personalizing your theme continued: the legend
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree),size=2.5) + #scatterplot #aes --> how to group your points 
  #if you want to change the legend title, you do it in all places where it is called:
  #in the scale_shape_manual(name=" "), scale_shape_fill(name=" ") AND labs( fill = " ")
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ #manually adding the shapes
  
  scale_fill_manual(name="Tree ID", 
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ #same values as the color
  labs(fill="Tree ID", x="Age (days)", y="Tree trunk circumference (mm) ")+
  theme_classic()+
  theme(panel.border = element_rect(linetype = "solid", fill = "NA"))+
  theme(axis.title.x=element_text(angle=0, size=14, family="serif",color = "black"), #x-axis title
        axis.text.x = element_text(angle =0, size=12,family="serif",color = "black"), #x-axis text 
        axis.title.y=element_text(angle=90, size=14, hjust=.5, vjust=.5,family="serif",color = "black"),
        axis.text.y = element_text(size=12,family="serif",color = "black"), 
        #continuing with the theme, can specify the theme for the legend 
        legend.title=element_text(size=12, face="bold", hjust=.5, family="serif"), #legend title
        legend.text=element_text(size=14, family="serif"), #legend text (the tree numbers)
        legend.background = element_rect(linetype="solid", colour ="black"), #box around the legend
        legend.key.size = unit(0.5,"cm"), #legend height 
        legend.key.width = unit(0.8, "cm"), #legend width
        legend.position = c(0.9, 0.2))#position of legend within the figure 
p

#ggsave("13_theme.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#saving your theme - NOTE: you can only save items which all fit within the "theme()" function
#for example, can't save + labs() 
newtheme_print<-     theme_classic()+
  theme(panel.border = element_rect(linetype = "solid", fill = "NA"))+
  theme(axis.title.x=element_text(angle=0, size=14, family="serif",color = "black"), 
        axis.text.x = element_text(angle =0, size=12,family="serif",color = "black"),  
        axis.title.y=element_text(angle=90, size=14, hjust=.5, vjust=.5,family="serif",color = "black"),
        axis.text.y = element_text(size=12,family="serif",color = "black"), 
        legend.title=element_text(size=12, face="bold", hjust=.5, family="serif"), 
        legend.text=element_text(size=14, family="serif"), 
        legend.background = element_rect(linetype="solid", colour ="black"), 
        legend.key.size = unit(0.5,"cm"), 
        legend.key.width = unit(0.8, "cm"), 
        legend.position = c(0.9, 0.2))

#lets also make a theme for presentations with larger text
newtheme_pres<-   theme_classic()+
  theme(panel.border = element_rect(linetype = "solid", fill = "NA"))+
  #increase all font sizes 
  theme(axis.title.x=element_text(angle=0, size=20, family="serif",color = "black"), 
        axis.text.x = element_text(angle =0, size=18,family="serif",color = "black"), 
        axis.title.y=element_text(angle=90, size=20, hjust=.5, vjust=.5,family="serif",color = "black"),
        axis.text.y = element_text(size=18,family="serif",color = "black"), 
        legend.title=element_text(size=18, face="bold", hjust=.5, family="serif"), 
        legend.text=element_text(size=20, family="serif"), 
        legend.background = element_rect(linetype="solid", colour ="black"), 
        legend.key.size = unit(0.5,"cm"), 
        legend.key.width = unit(0.8, "cm"), 
        legend.position = c(0.9, 0.2))


#looking at our new themes with our previous script
#theme for print
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree),size=2.5) + 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ 
  scale_fill_manual(name="Tree ID", 
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ 
  labs(fill="Tree ID", x="Age (days)", y="Tree trunk circumference (mm) ")+
  newtheme_print
p

#ggsave("13_theme.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#theme for presentations (larger text)
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree),size=2.5) + 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ 
  scale_fill_manual(name="Tree ID",
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ 
  labs(fill="Tree ID", x="Age (days)", y="Tree trunk circumference (mm) ")+
  newtheme_pres
p

#ggsave("14_theme.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#####changing axis scales#####

#how abour presenting the age in years and the tree trunk circumference in cm
p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree),size=2.5) + 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ 
  scale_fill_manual(name="Tree ID", 
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ #same values as the color
  labs(fill="Tree ID")+ # x="Age (days)", y="Tree trunk circumference (mm) " dont need this anymore, we rewrite it
  newtheme_pres+
  #the name will overright what was written in your "labs"line
  #limits = c(,) sets the minimum and maximum of your axes
  #expand = c(0,0) places the lower limit of x and y at the bottom left corner
  #because we set our lower limits to 0, this is the 0,0 --> important for reading your graph
  #breaks - you can set where the tick marks will be and what the text below it should say
  #the break numbers refer to the data which ggplot for x (here, the age in days) and for y (the circumference in mm)
  #you can change the tick labels using " "
  scale_x_continuous(name="Age (years)", limits=c(0,1700), expand=c(0,0), breaks=c(0,365,730,1095,1450), labels=c("0","1", "2", "3","4"))+
  scale_y_continuous(name="Tree trunk circumference (cm)",limits=c(0,220),  expand=c(0,0),
                     breaks=c(0,50,100,150,200), labels=c("0","5", "10", "15","20"))
p

#ggsave("15_scale.emf", plot = p,width=6, height=6, dpi=300, device="emf")


######multiple graphs#######

#let's say you have two graphs to present
#ex: temperature data 

#use new data frame: this is yearly temperature in New Haven, Connecticut
?nhtemp
tab2<-as.data.frame(nhtemp)
date<-list(1912:1971)
tab_temp<-cbind(date,tab2)
#change column names
colnames(tab_temp) <- c("Year","Temperature")
tab_temp

#using our customized theme and setting the axes
r<-ggplot(tab_temp, aes(x=Year, y=Temperature))+
  geom_line()+
  newtheme_pres+
  scale_y_continuous(name="Temperature (F)")+
  scale_x_continuous(name="Year", limits = c(1912,1971),breaks=c(1920,1930,1940,1950,1960),
                     labels=c("1920","1930","1940","1950","1960") )
r
#ggsave("16_temp.emf", plot = r,width=6, height=6, dpi=300, device="emf")


#adding special symbols to graph axes
ylab <- expression("Temperature "~( degree~F))

r<-ggplot(tab_temp, aes(x=Year, y=Temperature))+
  geom_line()+
  newtheme_pres+
  scale_y_continuous(name=ylab)+
  scale_x_continuous(name="Year", limits = c(1912,1971),breaks=c(1920,1930,1940,1950,1960),
                     labels=c("1920","1930","1940","1950","1960") )
r

#ggsave("17_temp.emf", plot = r,width=6, height=6, dpi=300, device="emf")


#adding text to the graph
r<-ggplot(tab_temp, aes(x=Year, y=Temperature))+
  geom_line()+
  newtheme_pres+
  scale_y_continuous(name=ylab)+
  scale_x_continuous(name="Year", limits = c(1912,1971),breaks=c(1920,1930,1940,1950,1960),
                     labels=c("1920","1930","1940","1950","1960") )+
  geom_text(x=1953, y=54.8, label="This was a warm year", size=5, color="black", family="serif")
r

#ggsave("18_temp.emf", plot = r,width=6, height=6, dpi=300, device="emf")


#now let's put both graphs together 
figure<-ggarrange(p, r,
                  labels = c("A)", "B)"), font.label = list (size=14,family="serif"),
                  ncol = 2, nrow = 1)
x11()
figure

#ggsave("19_both.emf", plot = figure,width=14, height=6, dpi=300, device="emf")


######extra figures##########
###new: using dplyr within ggplot2 
library(dplyr)
p<- tab %>%
  group_by(age) %>%
  summarise_each(funs( n = n(), mean = mean(.), se = sd(.)/sqrt(n())), "circumference") %>%
  ggplot(aes(x=age, y=mean))+
  geom_line() + 
  geom_point(size=2.5,shape=16)+
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), size= 0.3, width=15)+
  newtheme_print+
  scale_x_continuous(name="Age (years)", limits=c(0,1700), expand=c(0,0), breaks=c(0,365,730,1095,1450), labels=c("0","1", "2", "3","4"))+
  scale_y_continuous(name="Tree trunk circumference (cm)",limits=c(0,220),  expand=c(0,0),
                     breaks=c(0,50,100,150,200), labels=c("0","5", "10", "15","20"))+
  labs(title="Average circumference of five trees")+
  theme(plot.title = element_text(angle=0, size=18, family="serif",color = "black",hjust=0.5))
p


#####average and se of trees
cdata <- ddply(tab, c("age"), summarise,
               N    = sum(!is.na(circumference)),
               mean = mean(circumference, na.rm=T),
               sd   = sd(circumference, na.rm=T),
               se   = sd / sqrt(N)
)
cdata


p<- ggplot(cdata, aes(x=age, y=mean))+
  geom_line() + 
  geom_point(size=2.5,shape=16)+
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), size= 0.3, width=15)+
  newtheme_print+
  scale_x_continuous(name="Age (years)", limits=c(0,1700), expand=c(0,0), breaks=c(0,365,730,1095,1450), labels=c("0","1", "2", "3","4"))+
  scale_y_continuous(name="Tree trunk circumference (cm)",limits=c(0,220),  expand=c(0,0),
                     breaks=c(0,50,100,150,200), labels=c("0","5", "10", "15","20"))+
  labs(title="Average circumference of five trees")+
  theme(plot.title = element_text(angle=0, size=18, family="serif",color = "black",hjust=0.5))
p

#####fitting a logistical regression

#logistical model fitted to the mean of the trees;
#could also do this per individual tree
logistical_mod <- nls(mean ~ SSlogis(age, Asym, xmid, scal),
                      data = tab_mean)

cdata<- tab %>%
  group_by(age) %>%
  summarise_each(funs( n = n(), mean = mean(.), se = sd(.)/sqrt(n())), "circumference")

  nls(mean ~ SSlogis(age, Asym, xmid, scal))

mod.predict <- cbind(data=tab_mean, predict(logistical_mod, interval = 'confidence'))
colnames(mod.predict) <- c("Age","N","mean","se","Predicted_values")
mod.predict

p<- ggplot(tab, aes(x=age, y=circumference))+
  geom_point(aes(group=Tree, shape=Tree,fill=Tree),size=2.5) + 
  scale_shape_manual(name = "Tree ID",values=c(21,21,22,24,24))+ 
  scale_fill_manual(name="Tree ID",
                    values=c("#FFFFFF", "#000000", "#FFFFFF", "#000000", "#FFFFFF"))+ 
  labs(fill="Tree ID")+ 
  newtheme_print+
  scale_x_continuous(name="Age (years)", limits=c(0,1700), expand=c(0,0), breaks=c(0,365,730,1095,1450), labels=c("0","1", "2", "3","4"))+
  scale_y_continuous(name="Tree trunk circumference (cm)",limits=c(0,220),  expand=c(0,0),
                     breaks=c(0,50,100,150,200), labels=c("0","5", "10", "15","20"))+
  #here is where we add the model data - need to specify that we're using data not from the original data frame called in the script
  geom_line(data=mod.predict, aes(x=Age, y=Predicted_values))
p

#ggsave("20_model.emf", plot = p,width=6, height=6, dpi=300, device="emf")


#####exporting your figure########
#several options
#device = "tiff", "png", "jpeg","bmp": bit-map, pixel-based
#device = "pdf", "svg", "eps" can be editer later (in Inkscape, for example)

#this will save in your working directory

# ggsave("Figure_juxtaposition.pdf",plot = figure,device="pdf") #caution with legend placement / bordering parts of your graph may be displaced
# ggsave("Figure_logmod.emf", plot = p,  width=6, height=6, dpi=300, device="emf") #can adjust width, height, dpi = resolution
# 
 ggsave("Figure_juxtaposition.emf", plot = figure ,  width=6, height=6, dpi=300, device="emf") 
ggsave("Figure_juxtaposition.pdf",plot = figure,device="pdf") #caution with legend placement / bordering parts of your graph may be displaced
# 



#Windows users
#options for those without image editors: saving within Microsoft Powerpoint

doc <- read_pptx()
doc <- add_slide(doc, layout = "Title and Content", master = "Office Theme")
myplot <- figure
doc <- ph_with_vg(doc, code = print(myplot) , type = "body")
print(doc, target= "Final_figure.pptx")
#high quality image output 

