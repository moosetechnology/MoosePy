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