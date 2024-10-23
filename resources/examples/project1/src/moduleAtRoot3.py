moduleAtRootVariable3 = False

class Dog:

    kind = 'canine'         #class variable shared by all instances

    def __init__(self, name):
        self.dog_name = name    #Inst var declared in the init

    def set_dog_color(self, color_name):
        self.dog_color = color_name     #Inst var declared outside the init

    sound = "woof"          #class var not at the beginning

    def get_dog_color(self):
        return self.dog_color


dog = Dog("Stolys")
dog.dog_color = "Black and blue"
print(dog.dog_name)
print(dog.get_dog_color())
print(dog.__dict__)