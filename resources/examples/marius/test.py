import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Activation, BatchNormalization, Dropout
from keras.optimizers import Adam

model = Sequential()

# layers
model.add(
    Dense(
        units=128,
        kernel_initializer="uniform",
        activation="relu",
        input_dim=X_train.shape[1],
    )
)
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(units=64, kernel_initializer="uniform", activation="relu"))
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(units=32, kernel_initializer="uniform", activation="relu"))
model.add(BatchNormalization())
model.add(Dropout(0.5))
model.add(Dense(units=16, kernel_initializer="uniform", activation="relu"))
model.add(Dropout(0.3))
model.add(Dense(units=1, kernel_initializer="uniform", activation="sigmoid"))

locals()

# Compiling the ANN
optimizer = Adam(lr=0.001, beta_1=0.9, beta_2=0.999)
model.compile(optimizer=optimizer, loss="binary_crossentropy", metrics=["accuracy"])

# Train the ANN
history = model.fit(
    X_train, Y_train, batch_size=32, epochs=300, validation_data=(X_val, Y_val)
)

# Predict the values from the validation dataset
y_pred = model.predict(X_val)
y_final = (y_pred > 0.5).astype(int).reshape(X_val.shape[0])

import pandas as pd

train_orj = pd.read_csv("../input/train.csv", header=0)
test_orj = pd.read_csv("../input/test.csv", header=0)
train_orj.head()

train_orj.info()
train = train_orj.copy().drop(["PassengerId"], axis=1)
train = preprocess(train)
train = group_titles(train)
train = train.drop(["Name"], axis=1)
train.head()

train.info()

plt.figure(figsize=(10, 5))
sns.countplot(train.Age, palette="icefire")

x = train.iloc[:, 1 : train.shape[1]].values
y = train.Survived.values

from sklearn.model_selection import train_test_split

X_train, X_val, Y_train, Y_val = train_test_split(x, y, test_size=0.1, random_state=2)
print("x_train shape", X_train.shape)
print("x_test shape", X_val.shape)
print("y_train shape", Y_train.shape)
print("y_test shape", Y_val.shape)


def local_func(aParameter):
    # First version
    a = aParameter.inParamFunc()
    a = a.mean()
    print(a)
    return a


def local_func(aParameter):
    # Second version
    a = aParameter.inParamFunc()
    a = a.mean()
    print(a)
    return a


local_func(X_train)


def on_epoch_end():
    pass


base_features = [x for x in train_orj.columns.values.tolist() if x.startswith("var_")]


class roc_auc_callback(Callback):
    def __init__(self, training_data, validation_data):
        self.x = training_data[0]
        self.y = training_data[1]
        self.x_val = validation_data[0]
        self.y_val = validation_data[1]

    def on_train_begin(self, logs={}):
        return

    def on_train_end(self, logs={}):
        return

    def on_epoch_begin(self, epoch, logs={}):
        return

    def on_epoch_end(self, epoch, logs={}):
        y_pred = self.model.predict_proba(self.x, verbose=0)
        roc = roc_auc_score(self.y, y_pred)
        logs["roc_auc"] = roc_auc_score(self.y, y_pred)
        logs["norm_gini"] = (roc_auc_score(self.y, y_pred) * 2) - 1
        y_pred_val = self.model.predict_proba(self.x_val, verbose=0)
        roc_val = roc_auc_score(self.y_val, y_pred_val)
        logs["roc_auc_val"] = roc_auc_score(self.y_val, y_pred_val)
        logs["norm_gini_val"] = (roc_auc_score(self.y_val, y_pred_val) * 2) - 1
        print(
            "\rroc_auc: %s - roc_auc_val: %s - norm_gini: %s - norm_gini_val: %s"
            % (
                str(round(roc, 5)),
                str(round(roc_val, 5)),
                str(round((roc * 2 - 1), 5)),
                str(round((roc_val * 2 - 1), 5)),
            ),
            end=10 * " " + "\n",
        )
        return

    def fit(self, x, y, validation_data=None, **kwargs):
        # I do nothing, I am here to pollute the candidates of the fit(s) invocations
        self.x = x
        self.y = y
        self.x_val = validation_data[0]
        self.y_val = validation_data[1]
        return

    def on_batch_begin(self, batch, logs={}):
        return

    def on_batch_end(self, batch, logs={}):
        return


not_nice = roc_auc_callback(
    training_data=(x_train_fold, y_train_fold), validation_data=(x_val_fold, y_val_fold)
)

on_epoch_end()


def local_func(aParameter):
    # Third version
    a = aParameter.inParamFunc()
    a = a.mean()
    print(a)
    return a


# Second invocation of fit, one of the candates should be from the local class
model.fit(X_train, Y_train, batch_size=32, epochs=300, validation_data=(X_val, Y_val))
