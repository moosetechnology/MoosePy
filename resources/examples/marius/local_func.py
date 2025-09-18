import numpy as np
import pandas as pd
import seaborn as sns

from keras.regularizers import l1
from keras import backend as K

from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from scipy.stats import skew
from scipy.stats.stats import pearsonr

import matplotlib.pyplot as plt

import csv
import re

from keras.models import Sequential
from keras.layers import Dense, Activation, BatchNormalization, Dropout
from keras.callbacks import ModelCheckpoint
from keras.optimizers import Adam

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

import os

train_orj = pd.read_csv("../input/train.csv", header=0)
test_orj = pd.read_csv("../input/test.csv", header=0)
train_orj.head()

train_orj.info()


def preprocess(data):

    #Kabin
    data.Cabin.fillna('9', inplace=True)
    #data['Cabin'].replace('0', 9, inplace=True)
    data.loc[data.Cabin.str[0] == 'A', 'Cabin'] = 1
    data.loc[data.Cabin.str[0] == 'B', 'Cabin'] = 2
    data.loc[data.Cabin.str[0] == 'C', 'Cabin'] = 3
    data.loc[data.Cabin.str[0] == 'D', 'Cabin'] = 4
    data.loc[data.Cabin.str[0] == 'E', 'Cabin'] = 5
    data.loc[data.Cabin.str[0] == 'F', 'Cabin'] = 6
    data.loc[data.Cabin.str[0] == 'G', 'Cabin'] = 7
    data.loc[data.Cabin.str[0] == 'T', 'Cabin'] = 8
    data = data.drop(["Cabin"],axis=1)

    # Cinsiyeti tam sayıya çevirelim
    data['Sex'].replace('female', 1, inplace=True)
    data['Sex'].replace('male', 2, inplace=True)

    # Gemiye biniş limanlarını tam sayıya çevirelim
    data['Embarked'].replace('S', 1, inplace=True)
    data['Embarked'].replace('C', 2, inplace=True)
    data['Embarked'].replace('Q', 3, inplace=True)

    # Olmayan (NA) yaş değerlerini medyan ile dolduralım
    data['Age'].fillna(data['Age'].median(), inplace=True)
    #data['Age'] = [0 if each >= 60 else 1 if each >= 35 else 2 if each >= 18 else 3 if each >= 12 else 4 if each >= 5 else 5 for each in data['Age']]

    data['Fare'].fillna(data['Fare'].median(), inplace=True)
    data['Embarked'].fillna(data['Embarked'].median(), inplace=True)

    data = data.drop(["Ticket"],axis=1)
    data = data.drop(["Fare"],axis=1)
    data['SibSp'].replace(0, 9, inplace=True)
    data['Parch'].replace(0, 9, inplace=True)
    return data

def group_titles(data):
    #data['Names'] = data['Name'].map(lambda x: len(re.split(' ', x)))
    data['Title'] = data['Name'].map(lambda x: re.search(', (.+?) ', x).group(1))
    data['Title'].replace('Master.', 1, inplace=True)
    data['Title'].replace('Mr.', 2, inplace=True)
    data['Title'].replace(['Ms.','Mlle.', 'Miss.'], 3, inplace=True)
    data['Title'].replace(['Mme.', 'Mrs.'], 4, inplace=True)
    data['Title'].replace(['Dona.', 'Lady.', 'the Countess.', 'Capt.', 'Col.', 'Don.', 'Dr.', 'Major.', 'Rev.', 'Sir.', 'Jonkheer.', 'the'], 5, inplace=True)
    return data


train = train_orj.copy().drop(["PassengerId"],axis=1)
train=preprocess(train)
train=group_titles(train)
train = train.drop(["Name"],axis=1)
train.head()

train.info()

plt.figure(figsize=(10,5))
sns.countplot(train.Age, palette="icefire")

x = train.iloc[:,1:train.shape[1]].values
y = train.Survived.values

from sklearn.model_selection import train_test_split
X_train, X_val, Y_train, Y_val = train_test_split(x, y, test_size = 0.1, random_state=2)
print("x_train shape",X_train.shape)
print("x_test shape",X_val.shape)
print("y_train shape",Y_train.shape)
print("y_test shape",Y_val.shape)


plt.figure(figsize=(10,5))
sns.countplot(Y_train, palette="icefire")
plt.title("Number of Survived classes")


model = Sequential()

# layers
model.add(Dense(units = 128, kernel_initializer = 'uniform', activation = 'relu', input_dim = X_train.shape[1]))
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(units = 64, kernel_initializer = 'uniform', activation = 'relu'))
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(units = 32, kernel_initializer = 'uniform', activation = 'relu'))
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(units = 16, kernel_initializer = 'uniform', activation = 'relu'))
model.add(Dropout(0.3))
model.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))

# Compiling the ANN
optimizer = Adam(lr=0.001, beta_1=0.9, beta_2=0.999)
model.compile(optimizer = optimizer, loss = 'binary_crossentropy', metrics = ['accuracy'])

# Train the ANN
history = model.fit(X_train, Y_train, batch_size = 32, epochs = 300, validation_data = (X_val,Y_val))

scores = model.evaluate(X_train, Y_train, verbose=0)
print("%s: %.3f%%" % (model.metrics_names[1], scores[1]*100))

plt.plot(history.history['val_loss'], color='b', label="validation loss")
plt.xlabel("Number of Epochs")
plt.ylabel("Loss")
plt.legend()
plt.show()

import seaborn as sns
from sklearn.metrics import confusion_matrix
# Predict the values from the validation dataset
y_pred = model.predict(X_val)
y_final = (y_pred > 0.5).astype(int).reshape(X_val.shape[0])
# compute the confusion matrix
confusion_mtx = confusion_matrix(Y_val, y_final)
# plot the confusion matrix
f,ax = plt.subplots(figsize=(8, 8))
sns.heatmap(confusion_mtx, annot=True, linewidths=0.01,cmap="Greens",linecolor="gray", fmt= '.1f',ax=ax)
plt.xlabel("Predicted Label")
plt.ylabel("True Label")
plt.title("Confusion Matrix")
plt.show()


test = test_orj.copy()
test=preprocess(test)
