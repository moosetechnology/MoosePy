from root2 import NameOfSubpackageOrClass
import pandas

pandas.read_csv("https://raw.githubusercontent.com/cs109/2014_data/master/countries.csv")

print(NameOfSubpackageOrClass)

def function_with_inner_function():
    result = 3

    def inner_function(finput):
        inner_local_variable = 4
        return finput + 2 + inner_local_variable

    result = result + inner_function(result)

    return result

print(function_with_inner_function())


dataB = {
    'A': ['foo', 'bar', 'baz', 'qux'],
    'B': [1, 2, 3, 4],
    'C': ['cat', 'dog', 'cat', 'dog']
}

df = pandas.DataFrame(dataB)

# Convert column 'C' to a categorical type
col = 'C'
# The next line is there to ensure we can find that a node is on left side of an assignation in a node that have a field containing multiple nodes
df.loc[:, col] = df[col].astype('category')
