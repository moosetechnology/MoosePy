from root2 import NameOfSubpackageOrClass

print(NameOfSubpackageOrClass)

def function_with_inner_function():
    result = 3

    def inner_function(finput):
        return finput + 2

    result = result + inner_function(result)

    return result

print(function_with_inner_function())