from moduleAtRoot9 import AbstractAnimal

rootPackageVariable = 33

print(rootPackageVariable)


def function_with_common_name():
    return False


class Animal(AbstractAnimal):

    def eat(self):
        print("I can eat")


print(Animal())