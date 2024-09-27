import root.subpackage1.moduleInSubPackage1

print(root.subpackage1.moduleInSubPackage1.moduleInSubpackage1Variable)


class Employee:
    from root import rootPackageVariable
    from moduleAtRoot import moduleAtRootVariable
    from moduleAtRoot2 import Person
    from moduleAtRoot import sort_list
    from root.subpackage1.subsubpackage1 import Room
    from root.subpackage1.subsubpackage1 import return2

    print(rootPackageVariable)
    print(moduleAtRootVariable)

    p1 = Person("Imen", 37)
    p1.printInfos()

    x = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    y = [0, 1, 1, 0, 1, 2, 2, 0, 1]

    print(sort_list(x, y))

    # create object of Room class
    study_room = Room()
    # assign values to all the properties
    study_room.length = 42.5
    study_room.breadth = 30.8
    # access method inside class
    study_room.calculate_area()

    print(return2())

    def __init__(self, name, age):
        self.name = name
        self.age = age

    def print_info(self):
        print(self.name + " " + str(self.age))


p1 = Employee("John", 36)
p1.print_info()

class Employee2:
    from root import rootPackageVariable
    from moduleAtRoot import moduleAtRootVariable
    from moduleAtRoot2 import Person
    from moduleAtRoot import sort_list
    from root.subpackage1.subsubpackage1 import Room
    from root.subpackage1.subsubpackage1 import return2

    print(rootPackageVariable)
    print(moduleAtRootVariable)

    p1 = Person("Imen", 37)
    p1.printInfos()

    x = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    y = [0, 1, 1, 0, 1, 2, 2, 0, 1]

    print(sort_list(x, y))

    # create object of Room class
    study_room = Room()
    # assign values to all the properties
    study_room.length = 42.5
    study_room.breadth = 30.8
    # access method inside class
    study_room.calculate_area()

    print(return2())

    def __init__(self, name, age):
        self.name = name
        self.age = age

    def print_info(self):
        print(self.name + " " + str(self.age))


p2 = Employee2("John", 36)
p2.print_info()

def functionWithImportsInRoot2():
    class Employee3:
        from root import rootPackageVariable
        from moduleAtRoot import moduleAtRootVariable
        from moduleAtRoot2 import Person
        from moduleAtRoot import sort_list
        from root.subpackage1.subsubpackage1 import Room
        from root.subpackage1.subsubpackage1 import return2

        print(rootPackageVariable)
        print(moduleAtRootVariable)

        p1 = Person("Imen", 37)
        p1.printInfos()

        x = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        y = [0, 1, 1, 0, 1, 2, 2, 0, 1]

        print(sort_list(x, y))

        # create object of Room class
        study_room = Room()
        # assign values to all the properties
        study_room.length = 42.5
        study_room.breadth = 30.8
        # access method inside class
        study_room.calculate_area()

        print(return2())

        def __init__(self, name, age):
            self.name = name
            self.age = age

        def print_info(self):
            print(self.name + " " + str(self.age))

    p3 = Employee("John", 36)
    p3.print_info()
