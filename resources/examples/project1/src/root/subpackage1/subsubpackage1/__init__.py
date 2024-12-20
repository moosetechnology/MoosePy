import packagesToReference.packagesToReference1
import packagesToReference.moduleToReference1

subSubPackage1Variable = True

# create a class
class Room:
    length = 0.0
    breadth = 0.0

    # method to calculate area
    def calculate_area(self):
        print("Area of Room =", self.length * self.breadth)


print(Room)


def return2():
    return 2


print(return2)


class ClassWithFunctionReference:
    functionRefCVar = return2

    def method_with_function_ref(self):
        return return2


def function_with_function_ref():
    return return2


def function_with_lambda_with_function_ref():
    return lambda: return2


function_with_lambda_with_function_ref()()

print(packagesToReference.packagesToReference1)
print(packagesToReference.moduleToReference1)
