import seaborn as sns

iris_dataset = sns.load_dataset("iris")

X = iris_dataset.values[:, 0:4].astype(np.float64)
y = iris_dataset.values[:, 4]

if not (iris_dataset.species.isnull().sum() == 0):
    print("Empty values found in dataset")