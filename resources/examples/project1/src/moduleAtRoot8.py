from moduleAtRoot import moduleAtRootVariable
import root.subpackage1.subsubpackage1
import root2.subpackageInRoot2
import pandas as pd

pd.read_csv("https://raw.githubusercontent.com/cs109/2014_data/master/countries.csv")

print(moduleAtRootVariable)

print(root.subpackage1.subsubpackage1.function_with_function_ref())

print(root2. subpackageInRoot2. function_returning_75())


def functionReturningSomething():
    return 8


class CustomMetaclass(type):

    def __init__(cls, name, bases, dct):
        cls.base = 100


class ClassUsingMetaclass(metaclass=CustomMetaclass):
    pass


x = ClassUsingMetaclass()
print(x.base)