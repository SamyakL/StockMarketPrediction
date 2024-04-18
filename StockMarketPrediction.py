# -*- coding: utf-8 -*-
"""Untitled0.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1brfsIo4vT4fkYT77Lx-3zphc5yxVehyB
"""

#import necessary libraries
import pandas as pd
import xgboost as xbg
import matplotlib.pyplot as plt

#load the dataset S&P500
data = pd.read_csv('V_data.csv')

data

from google.colab import drive
drive.mount('/content/drive')

#show the data visually
data['close'].plot()

#split the data into training and testing dataset
train_data = data.iloc[:int(0.80*len(data)),:]
test_data = data.iloc[:int(0.80*len(data)):, :]

#define the features and target the variable
features = ['open','volume']
target = ['close']

#create and train the model
model = xbg.XGBRegressor()
model.fit(train_data[features],train_data[target])

#Make and show the predictions on the test data
predictions = model.predict(test_data[features])
print("Model predictions: ")
print( predictions)

#show the actual values
print("actual values: ")
print(test_data[target])

#show the model accuracy
accuracy = model.score(test_data[features],test_data[target])
print("accuracy")
print(accuracy)

#plot the predictions and the close price
plt.plot(data['close'],label ='Close Price')
plt.plot(test_data[target].index,predictions,label ='Predictions')
plt.legend()
plt.show()