from moduleAtRoot9 import AbstractAnimal
from root2 import moduleInRootPackage2
from root2 import subpackageInRoot2

print(moduleInRootPackage2.Employee)
print(subpackageInRoot2.return2)

rootPackageVariable = 33

print(rootPackageVariable)


def function_with_common_name():
    return False


class Animal(AbstractAnimal):

    def eat(self):
        print("I can eat")


print(Animal())