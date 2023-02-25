# Dimensionality-Reduction-With-PCA

In this practice, I’ve handled one of the most popular dimensionality reduction method, which is Principal Component Analysis.

The practice includes a dataset, which has 86 observations with 37 attributes. As every data scientist candidate knows, the real life datasets are not even similar to datasets than we handled our projects. There will be lots of variables to analyze. Therefore, understanding the dimensionality reduction methods are extremely important to build our projects. 

Relationship between statistics and data science to use depends on a person, who call himself as a data scientist. At this point, knowledge of statistics of someone is going to take himself steps further.

When we decide to build a machine learning model to predict something, we analyze our dataset to select independent variable for creating a model. There are lots of way to select our independent variables. We can use information gain method (Entropy), variation etc. 

In principal component analysis, we are using the explainable variation rates. When we have lots of variable to build a model, it might leads model to face different type of problems such as Multicollinearty, Overfitting, etc.  Except the technical things, it may cause too many problem in real life such as cost, wasted time by collecting data, etc. Thus, the main aim of us has to be building a model, which has few variables as much as we can.


Summary:

I’ve used Principal Component Analysis to realize the importance of variables. Practice does not contain the part of using machine learning algorithms.
First of all, I’ve prepared the data for analyzing part. I’ve visualized data with different types of plots. After analyzing data, PCA have been built.

Dataset Summary:

Meter A contains 87 instances of diagnostic parameters for an 8-path liquid ultrasonic flow meter (USM). It has 37 attributes and 2 classes or health states:

Class '1' - Healthy
Class '2' - Installation effects

All attributes are continuous, with the exception of the class attribute.

(1) -- Flatness ratio

(2) -- Symmetry

(3) -- Crossflow

(4)-(11) -- Flow velocity in each of the eight paths

(12)-(19) -- Speed of sound in each of the eight paths

(20) -- Average speed of sound in all eight paths

(21)-(36) -- Gain at both ends of each of the eight paths

(37) -- Class attribute or health state of meter: 1,2

Let’s skip to the code section.
