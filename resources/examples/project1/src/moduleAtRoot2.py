import moduleAtRoot
import moduleAtRoot
import moduleAtRoot3

moduleAtRoot2Variable = 42

print(moduleAtRoot.moduleAtRootVariable)


class Person:
    import moduleAtRoot3

    def __init__(self, name, age):
        self.name = name
        self.age = age

    def printInfos(self):
        import moduleAtRoot4
        if not moduleAtRoot3.moduleAtRootVariable3:
            print(self.name + moduleAtRoot4.moduleAtRootSpaceString + str(self.age))

    def get_name(self):
        return self.name

    def set_name(self, name):
        self.name = name


p1 = Person("John", 36)
p1.printInfos()
