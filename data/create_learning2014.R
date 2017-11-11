# title: "Learning data"
# author: "Dimitrios Tsallos"
# date: "09/11/2017"
# This file contains the learning data that I am going to use in this course.

library(dplyr)
# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# here is the dimensions of the data
dim(lrn14)

# here is the structure of the data
str(lrn14)

# Columns "gender", "Age", "Attitude", "Points" are already part of the table
# I need to collect the columns that correspond to deep, surface and strategic questions

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)


# choose the columns of interest
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# exclude zero values
learning2014 <- filter(learning2014, Points != 0)

# see the stucture of the new dataset
str(learning2014)

write.csv(learning2014, file = "data/learning2014.csv" )
