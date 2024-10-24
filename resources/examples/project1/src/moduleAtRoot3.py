# Please do not touch too much this file. We use the positions of the text to test source anchors

moduleAtRootVariable3 = False


class Dog:
    kind = 'canine'  # class variable shared by all instances

    def __init__(self, name):
        self.dog_name = name  # Inst var declared in the init

    def set_dog_color(self, color_name):
        self.dog_color = color_name  # Inst var declared outside the init

    def update_dog_color(self, color_name):
        self.dog_color = color_name  # Second assignation to be sure we do not duplicate source anchors of ivars

    sound = "woof"  # class var not at the beginning

    def get_dog_color(self):
        return self.dog_color

    sound = "Waoof"  # Second assignation to be sure we do not duplicate source anchors of class vars


dog = Dog("Stolys")
dog.dog_color = "Black and blue"
print(dog.dog_name)
print(dog.get_dog_color())
print(dog.__dict__)
Dog.newClassVar = 1
print(dog.newClassVar)
print(Dog.newClassVar)
print(dog.sound)


class Chair:

    furniture_color = "Blue"

    def __init__(self):
        self.number_of_legs = 4


class Stool:

    furniture_color = "Red"

    def __init__(self):
        self.number_of_legs = 3
