from moduleAtRoot9 import AbstractAnimal
from root2 import moduleInRootPackage2

print(moduleInRootPackage2.Employee)

rootPackageVariable = 33

print(rootPackageVariable)


def function_with_common_name():
    return False


class Animal(AbstractAnimal):

    def eat(self):
        print("I can eat")


print(Animal())