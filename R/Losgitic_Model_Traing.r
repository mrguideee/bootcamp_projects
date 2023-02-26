# Install Library
```{r}
install.packages("titanic",repos = "http://cran.us.r-project.org")
install.packages("dplyr",repos = "http://cran.us.r-project.org")
```

## Load Library
```{r}
library(titanic)
library(dplyr)
```
## Explore Data
```{r}
glimpse(titanic_train)
```

## Drop NULL Values 
```{r}
titanic_train <- na.omit(titanic_train)
```

## Change Data Types
```{r}
titanic_train$Survived <- as.factor(titanic_train$Survived)
```

## Data Training

### Split Data

```{r}
set.seed(42)
n <- nrow(titanic_train)
id <- sample(1:n, size=n*0.7) ## 70% Train 30% Test
train_data <- titanic_train[id, ]
test_data <- titanic_train[-id, ]
```

### Train Model
```{r}
model1 <- glm(Survived ~ Pclass + Age + Sex, data = train_data, family = "binomial")
p_train <- predict(model1, type="response")
train_data$pred <- if_else(p_train >= 0.5, 1,0)
```
## Evaluate Model Confusion Matrix (Train Model)
```{r}
conM_train <- table(train_data$pred,train_data$Survived, 
              dnn=c("Predicted","Actual"))
accuracy_train <- (conM_train[1,1] + conM_train[2,2]) / sum(conM_train)
precision_train <- (conM_train[2,2]) / (conM_train[2,1] + conM_train[2,2])
recall_train <- conM_train[2,2] / (conM_train[1,2] + conM_train[2,2])
f1_train <- 2*((precision_train * recall_train) / (precision_train + recall_train))
cat("Accuracy:", accuracy_train, "\nPrecision:", precision_train,
    "\nRecall:", precision_train,"\nF1:", f1_train)

```

### Test Model
```{r}
p_test <- predict(model1, newdata = test_data, type="response")
test_data$pred <- if_else(p_test >= 0.5, 1,0)
mean(test_data$Survived == test_data$pred)
```

## Evaluate Model Confusion Matrix (Test Model)
```{r}
conM_test <- table(test_data$pred,test_data$Survived,
                   dnn = c("Predicted","Acutual"))
accuracy_test <- (conM_test[1,1] + conM_test[2,2]) / sum(conM_test)
precision_test <- (conM_test[2,2]) / (conM_test[2,1] + conM_test[2,2])
recall_test <- (conM_test[2,2]) / (conM_test[1,2] + conM_test[2,2])
f1_test <- 2*(precision_test * recall_test) / (precision_test + recall_test)
cat("Accuracy_test:",accuracy_test,"\nPrecision_test:",precision_test,
    "\nRecall_test",recall_test,"\nF1:",f1_test)
```
