

# Exploring Dataset

## Preparing Dataset for Analysis

#Importing our dataset into RStudio, then looking at summary of dataset

df <- read.delim("C:/Users/dogukan1/Desktop/Meter A")

dim(df) 
str(df)
summary(df)
colnames(df)
sum(is.na(df))

#We can clearly say that our dataset is not perfect to see. Our dependent variable, which is going to
#be predicted by our models is named as x1. At this point, our independent variables have named
#strangely. That’s why we are going to start with changing the names of variables.

names(df) <- paste("x", 1:ncol(df), sep = "");

colnames(df)[37] <- "y"

summary(df)

#It looks better now. You are going to see the descriptions of variables in ReadME file. 
#Therefore, If you've not checked it yet, you would be able to give your 2 minutes to understand the meanings of variables.

#Now we're going to trasnform our dependent variable from integer to factor. 
#After that one, We're going to use "revalue" function to change names of categories of our dependent variable.

library(plyr)

df2 = df 

df$y <- as.factor(df$y)

dc = revalue(df$y, c("1" = "Healthy", "2" = "Installation effects"))

df2$y = dc

#We've created a new dataframe, which have named as df2. 
#The point on this that when we are going to calculate the correlations between variables, 
#It would not be calculated when some variables are with chr type as you guys know. 
#So we're going to use df one, when we're going to skip to correlation part.
#Let's continue to describing our dataset by using the labels of our dependent variable.

library(summarytools)

by(df2, df2$y, summary) #Summary of dataset by labels of our dependent variable. 
#If you want to summarize specific independent variable by labels of dependent variable, 
#you can change df2 to df2$(Ýndependentvariableyouwant)


stby(
  data = df2,
  INDICES = df2$y, # by dependent variable
  FUN = descr, # descriptive statistics
  stats = "common" # most common descr. stats
)

#Doing this by using dplyr with pipes

library(dplyr)

group_by(df2, y) %>%
  summarise(
    mean = mean(x12, na.rm = FALSE),
    sd = sd(x12, na.rm = FALSE)
  )


## Data Visualization

#Firstly, we are going to visualize our dependent variable by percentage of its 2 classes.

library(scales)
library(ggplot2)

ysummary = table(df2$y)

ysummary = data.frame(ysummary)

colnames(ysummary) = c("y","Freq")

perc = ysummary$Freq/sum(ysummary$Freq)

ysummary$perc = perc

ysummary$percentage = percent(perc)

ggplot(ysummary, aes(x = "", y = perc, fill = y)) +
  geom_col(color = "black") +
  geom_label(aes(label = percentage), color = c("black", "black"),
             position = position_stack(vjust = 0.5),
             show.legend = FALSE) +
  guides(fill = guide_legend(title = "Y Variable")) +
  scale_fill_viridis_d() +
  coord_polar(theta = "y") + 
  scale_fill_manual(values = c("yellow", "forestgreen"))+
  theme_void()

#Now I'm going to continue with typical data visualization so that you can pick the plots whatever you desire.
#You can change the independent variable that you are going to deal with as you wish. I'm going to continue with x12.


library(tidyverse)
library(rstatix)
library(ggpubr)

# Compute summary statistics
summary.stats <- df2 %>%
  group_by(y) %>%
  get_summary_stats() %>%
  select(y, n, median, iqr)
summary.stats

# Create a boxplot
bxp <- ggboxplot(
  df, x = "y", y = "x12", add = "jitter", 
  ggtheme = theme_bw()
)

# Visualize the summary statistics
summary.plot <- ggsummarytable(
  summary.stats, x = "y", y = c("n", "median", "iqr"),
  ggtheme = theme_bw()
) +
  clean_table_theme()

# Combine the boxplot and the summary statistics plot
ggarrange(
  bxp, summary.plot, ncol = 1, align = "v",
  heights = c(0.80, 0.20)
)

#basic box plot

ggsummarystats(
  df2, x = "y", y = "x12", 
  ggfunc = ggboxplot, add = "jitter",
  color = "y", palette = "npg"
)


#Box plot with violin type

ggsummarystats(
  df2, x = "y", y = "x12", 
  ggfunc = ggviolin, add = c("jitter", "median_iqr"),
  color = "y", palette = "npg"
)

#At this time, I'm going to use pairsplot to see relationship between some variables.

library(GGally)

ggpairs(df2[,c(1,12,21)])


#Now, its time for dotplots.

p<-ggplot(df2, aes(x=y, y=x12)) + 
  geom_dotplot(binaxis='y', stackdir='center')
p
# Change dotsize and stack ratio
ggplot(df2, aes(x=y, y=x12)) + 
  geom_dotplot(binaxis='y', stackdir='center',
               stackratio=1.5, dotsize=1.2)
# Rotate the dot plot
p + coord_flip()




#dot plots by built mean and median values with different colors.

# dot plot with mean points
p + stat_summary(fun.y=mean, geom="point", shape=18,
                 size=3, color="red")
# dot plot with median points
p + stat_summary(fun.y=median, geom="point", shape=18,
                 size=3, color="red")


#Change dot plot colors by groups

p<-ggplot(df2, aes(x=y, y=x12, fill=y)) +
  geom_dotplot(binaxis='y', stackdir='center') +
  ggtitle("Dot plot of x12 variable by health states (Dependent variable)") +
  labs(y = "Speed of sound in each of the eight paths", x = "Health States")


p


## Correlations Between Variables

#After data visualization, We're going to check the relationship between our variables. 
#The point on this is when we decide to build a model to predict health states of observations, 
#we can face with a problem, which is multicollinearity. 

#My aim in this practice is discover the importance of variables instead of building a perfect model for predicting our dependent variable 
#so let's go deep to our variables as much as we can.

library(corrplot)
library(ggcorrplot)

df$y = as.numeric(df$y)
correl = cor(df)

corrplot(correl, method = "circle")


#We can clearly say that If we are going to build a model for prediction, 
#we have to reduce the number of independent variables in model. At this point, statistics has entered our practice.

#Dimensionality Reduction methods are the one of the most useful techniques for understanding the importance of variables. 
#In the real life datasets have lots of variables to analyze unlike the datasets that we use in our projects. 
#Therefore, I've tried find a dataset which has lots of attributes like our dataset in this practice. 


## Principal Component Analysis (PCA)

#we are going to use PCA in order to start for detecting variables that can be useful for our classification models.

#What is PCA? 
  
#Principal component analysis (PCA) is a popular technique for analyzing large datasets containing a
#high number of dimensions/features per observation, increasing the interpretability of data while
#preserving the maximum amount of information, and enabling the visualization of multidimensional
#data.

#Formally, PCA is a statistical technique for reducing the dimensionality of a dataset. This is
#accomplished by linearly transforming the data into a new coordinate system where (most of) the
#variation in the data can be described with fewer dimensions than the initial data. Many studies use
#the first two principal components in order to plot the data in two dimensions and to visually identify
#clusters of closely related data points.

#So let's have a started


library(data.table)


datanew <- copy(df2)

datanew$y = "NULL"

datanew = subset(datanew, select = -c(y))

pca <- prcomp(datanew, scale. = TRUE)

pca_1_2 <- data.frame(pca$x[, 1:2]) # Generally, The first two pca can clarify the highest variation over 0.6. Therefore, I just look at the first pca

plot(pca$x[,1], pca$x[,2], xlab = "1st PCA", ylab = "2nd PCA")

#the plot seems like our suggestion did not work. Its OK. 
#Let's look at the all pca parts with their explained variation rates.


pca_var <- pca$sdev^2

pca_var_perc <- round(pca_var/sum(pca_var) * 100, 1)

barplot(pca_var_perc, main = "Variation plot", xlab = "PCS", ylab = "Percentage Variance", ylim = c(0,100))



#In first PCA explained the variation of our dataset with 70,9%.
#When we continue to other pca part, 2nd PCA explained the variation of our dataset with 86,4%.

#So we can say that the numbers never lie :).

#Now we're going to see which variables are vital for the explanation rates.

PC1 <- pca$rotation[,1]

PC1_scores <- abs(PC1)

PC1_scores_ordered <- sort(PC1_scores, decreasing = TRUE)

names(PC1_scores_ordered)

#According to first PCA, the importance of X6 variable is explaining the higher variation than others.

#If we wonder what happens when we are going to continue PCA parts (If you say that 70,9 is not enough for me), 
#We can continue with the 2nd PCA.

PC2 <- pca$rotation[,2]

PC2_scores <- abs(PC2)

PC2_scores_ordered <- sort(PC2_scores, decreasing = TRUE)

names(PC2_scores_ordered)


#2nd part of PCA says that x25 and x1 are explaining the higher variation than others.



#At this time, we can built some classification algorithms to understanding the dynamics of the variables. 
#However, this practice does not include the comparing of classification algorithms.

#All in all, in this practice we handled the one of the most popular Dimensionality Reduction method, 
#which is Principal Component Analysis. 



































































