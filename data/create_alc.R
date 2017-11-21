# title: "Learning data"
# author: "Dimitrios Tsallos"
# date: "09/11/2017"
# This file contains the learning data that I am going to use in this course.


library(dplyr)
#set working directory
setwd( "/Users/dtsallos/Desktop/OneDrive - University of Helsinki/GitHub/IODS-project/data")

# read the math class questionaire data into memory
math <- read.table("student-mat.csv", sep = ";" , header=TRUE)

# read the portuguese class questionaire data into memory
por <- read.table("student-por.csv", sep = ";", header = TRUE)

# look at the structure of both data
str(math)
str(por)

# look at the column names of both data
colnames(math)
colnames(por)

# join tables using the following variables as student identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# see the new column names
colnames(math_por)

# glimpse at the data
glimpse(math_por)



# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by] # duplicated data

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining
for(column_name in notjoined_columns) {
    # select two columns from 'math_por' with the same original name
    two_columns <- select(math_por, starts_with(column_name))
    # select the first column vector of those two columns
    first_column <- select(two_columns, 1)[[1]]
    
    # if that first column vector is numeric
    if(is.numeric(first_column)) {
        # take a rounded average of each row of the two columns and
        # add the resulting vector to the alc data frame
        alc[column_name] <- round(rowMeans(two_columns))
    } else { # else if it's not numeric
        # add the first column vector to the alc data frame
        alc[column_name] <- first_column
    }
}

# glimpse at the new combined data
glimpse(alc)

# Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' 
# to the joined data. Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' 
# is greater than 2 (and FALSE otherwise). (1 point)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)


# glimpse at the new combined data
glimpse(alc)
dim(alc) #The joined data should now have 382 observations of 35 variables. 

# Save the joined and modified data set to the ‘data’ folder, using for example write.csv() or write.table() functions.
write.csv(alc, file = "student-combined.csv" )

