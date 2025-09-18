import pandas as pd

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

train_orj = pd.read_csv("../input/train.csv", header=0)
test_orj = pd.read_csv("../input/test.csv", header=0)
train_orj.head()
train_orj.info()

test_orj.head()
test_orj.info()

print('test')
