import moduleAtRoot
import moduleAtRoot
import moduleAtRoot3

moduleAtRoot2Variable = 42
globalVariableWithCommonName = False

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


class Student(Person):
    pass


s = Student("Stolys", 19)
s.printInfos()


class ClassWithTuples:
    cvarTuple1, cvarTuple2, cvarTuple3 = ("a", "b", "c")

    def __init__(self, tuple_attr):
        self.ivarTuple1, self.ivarTuple2, self.ivarTuple3 = tuple_attr

    def set_tuples(self, tuple_attr):
        self.ivarTuple1, self.ivarTuple2 = tuple_attr


t = (1, 2, 3)
c1 = ClassWithTuples(t)
print(c1.__dict__)
t2 = (4, 5)
c1.set_tuples(t2)
print(c1.__dict__)
print(c1.__class__.__dict__)


class ClassToTestLocalVariables:

    def method_with_local_variables(self):
        local_in_method1 = 1
        local_in_method2 = 2
        local_in_method3 = True
        if local_in_method3:
            local_in_method3 = 4
        return local_in_method1 + local_in_method2 + local_in_method3

    def method_with_local_variables2(self):
        local_in_method1 = 1
        return local_in_method1

    def method_with_local_variables_and_tuples(self):
        local_in_method_with_tuple1, local_in_method_with_tuple2 = (1, 2)
        return local_in_method_with_tuple1 + local_in_method_with_tuple2
