#Import data to R
dbp_data <- read_excel("dbp_data.xlsx") #you have to import according to the directory of the data in your computer
head(dbp_data)

#call the tidyverse package
library(tidyverse)
#reshape data into long format
dbp_data <- pivot_longer(dbp_data, cols = starts_with("dbp_"),
                         names_to = "time",
                         values_to = "dbp",
                         names_prefix = "dbp_")
dbp_data$time = as.numeric(dbp_data$time)
dbp_data <- as.data.frame(dbp_data) #save data as data frame
head(dbp_data)


#plotting the DBP of each individual across the five time points.
# first install lattice package if not already installed
#call the package
library(lattice)
xyplot(dbp ~ as.factor(time) | factor(id),
       data = dbp_data,
       type = "o",
       lwd = 1.5,
       layout = c(10, 5),
       xlab = "Time Points",
       ylab = "Diastolic Blood Pressure",
       groups = dbp_data$treatment, # Color lines by treatment group
       auto.key = list(space = "right", title = "Treatment", lines = TRUE, points = FALSE),
       par.settings = list(superpose.line = list(col = c("blue", "red"))), # Define colors for the groups
       strip = strip.custom(bg = "lightblue")
)


#Let us plot the average DBP at the 5 time points separately for treatment A and B and plot it against time.

mean_dbp <- dbp_data %>%
  group_by(time, treatment) %>%
  summarise(meandbp = mean(dbp)) %>%
  ungroup()


ggplot(mean_dbp, aes(x = time, y = meandbp, color = treatment, group = treatment)) +
  geom_line(size = 1) +                    
  geom_point(size = 2) +                    
  labs(x = "Time Point",
       y = "Average Diastolic Blood Pressure",
       color = "Treatment") +                 # Label the plot
  theme_bw()


#Runnig Fixed Effect Regression
install.packages("plm")
library(plm)

m1.fe <- plm(dbp ~ time, data = dbp_data, index = c("id", "time"), 
             model = "within")
summary(m1.fe)

#Running fixed effect regression with interaction between time and treatmetn

#making treatment "B" as the reference treatment for better interpretation
dbp_data$treatment <- relevel(factor(dbp_data$treatment), ref = "B")

#running the model with interaction term
m2.fe <- plm(dbp ~ time*treatment, data = dbp_data, index = c("id", "time"), 
             model = "within")
summary(m2.fe)


#Running Random Effect Regression Model
#with time and treatment as covariate

m1.re <- plm(dbp ~ time + treatment, data = dbp_data, index = c("id", "time"), 
             model = "random")
summary(m1.re)

#with interaction between time and treatment

m2.re <- plm(dbp ~ time*treatment, data = dbp_data, index = c("id", "time"), 
             model = "random")
summary(m2.re)

#with sex and age as covariates

m3.re <- plm(dbp ~ time*treatment + age + sex, data = dbp_data, index = c("id", "time"), 
             model = "random")
summary(m3.re)

#Hausman Test Example

# Example data
data("Grunfeld", package = "plm")

# Fixed effects model
fe_model <- plm(inv ~ value + capital, data = Grunfeld, model = "within")

# Random effects model
re_model <- plm(inv ~ value + capital, data = Grunfeld, model = "random")

# Hausman test
hausman_test <- phtest(fe_model, re_model)
print(hausman_test)



