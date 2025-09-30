import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Activation, BatchNormalization, Dropout
from keras.optimizers import Adam

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

locals()

# Compiling the ANN
optimizer = Adam(lr=0.001, beta_1=0.9, beta_2=0.999)
model.compile(optimizer = optimizer, loss = 'binary_crossentropy', metrics = ['accuracy'])

# Train the ANN
history = model.fit(X_train, Y_train, batch_size = 32, epochs = 300, validation_data = (X_val,Y_val))

# Predict the values from the validation dataset
y_pred = model.predict(X_val)
y_final = (y_pred > 0.5).astype(int).reshape(X_val.shape[0])

import pandas as pd

train_orj = pd.read_csv("../input/train.csv", header=0)
test_orj = pd.read_csv("../input/test.csv", header=0)
train_orj.head()

train_orj.info()
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


def local_func(aParameter):
   a =	aParameter.inParamFunc()
   a = a.mean()
   print(a)
   return a

local_func(X_train)
	
	

