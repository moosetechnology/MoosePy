import pandas as pd

# Sample DataFrame with currency-formatted strings
data = pd.DataFrame({
    'Price': ['$1,000.00', '$2,500.50', '$3,750.99']
})

# Specify the column to clean
curr_col = 'Price'

# Remove dollar signs and commas
data[curr_col] = data[curr_col].replace('[\$,]', '', regex=True)

print(data)

from scipy.stats import skew
from scipy.stats.stats import pearsonr

print(skew)
print(pearsonr)
