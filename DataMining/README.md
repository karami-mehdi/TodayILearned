# Numeric Prediction (*Price of a New Car*)

As part of our university data mining course, we individually collected a dataset of *206* car prices from **Divar**, a popular platform for buying and selling products, including vehicles. These individual records were then combined into a unified dataset.

Since the data came in mixed formats (Persian, Arabic, and English values), we needed a robust preprocessing pipeline. 
This involved thorough steps such as normalization, standardization, and other cleaning processes to ensure consistency before feeding the data into our prediction algorithms.

The dataset is available [here](./data.csv), and further details can be found in the accompanying [notebook](./numeric_prediction.ipynb) file.

In this project, we applied `KNN`, `DecisionTree`, `RandomForest`, and `GradientBoosting` algorithms. However, you can easily extend it with other models by adding them to the baseline_models dictionary.
