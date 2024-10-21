moduleAtRootVariable3 = False

class Dog:

    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.dog_name = name