import moduleAtRoot
import moduleAtRoot
import moduleAtRoot3
import moduleAtRoot8

# Comment in module at root 2

moduleAtRoot2Variable = 42  # Comment after global
globalVariableWithCommonName = False

moduleAtRoot.sort_list(["a", "b", "c", "d", "e", "f", "g", "h", "i"], [0, 1, 1, 0, 1, 2, 2, 0, 1])

# Comment with wide string ぁ

print(moduleAtRoot.moduleAtRootVariable)

"""
Multiline
Comment
Before single line
"""
# Single line comment after multiline

"""
Multiline
Comment
Followed by other multiline
"""
"""
Following
Multiline
Comment
"""


def function_with_comment_inside():
    # Comment in function
    return 42


def function_with_inner_function_with_comment_inside():
    def inner_function_with_comment_inside():
        # Comment in inner function
        return 31

    return inner_function_with_comment_inside()


def function_with_single_lines_comments_to_merge():
    # Comment line 1
    # Comment line 2
    # Comment line 3

    # Other comment line 4
    # Other comment line 5
    return "String"


# Comment before function
def function_with_comment_before():
    return True


def function_with_locale_with_comment():
    # Comment before temp
    temp_after_comment = False
    temp_before_comment = True  # Comment after temp
    return temp_after_comment | temp_before_comment


def function_with_conflicting_comment_attribution():
    temp_conflicting_1 = True  # Comment to attribute to temp 1 and not 2
    temp_conflicting_2 = False
    return temp_conflicting_2 & temp_conflicting_1


# Comment before global
globalInModuleAtRoot2 = False


class Person:
    import moduleAtRoot3

    # Comment in Class

    def __init__(self, name, age):
        self.set_name(name)
        self.age = age  # Comment after ivar

    def printInfos(self):
        import moduleAtRoot4
        if not moduleAtRoot3.moduleAtRootVariable3:
            print(self.get_name() + moduleAtRoot4.moduleAtRootSpaceString + str(self.age))

    # Comment before method
    def set_name(self, name):
        # Comment before ivar
        self.name = name

    def get_name(self):
        # Comment in method
        return self.name


p1 = Person("John", 36)
p1.printInfos()


# Comment before class
class Student(Person):
    pass


print(Student)
s = Student("Stolys", 19)
s.printInfos()

# The parser should probably import the module before the root package. Here I want to check the symbol resolution of superclasses
from root import Animal


class Fish(Animal):
    pass


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


"""
Multiline
Comment
In module
"""

"""
Multiline
Comment
Before global
"""
global_with_multiline_comment = 3

"""
Multiline
Comment
Before function
"""
def function_containing_multiline_comment():
    """
    Multiline
    Comment
    In function
    """

    """
    Multiline
    Comment
    Before temp
    """
    temp_with_multiline_comment_before = 3

    return temp_with_multiline_comment_before


"""
Multiline
Comment
Before class
"""
class ClassWihtComments():
    """
    Multiline
    Comment
    In Class
    """

    def __init__(self):
        """
        Multiline
        Comment
        Before ivar
        """
        self.ivar_commented = 3

    """
    Multiline
    Comment
    Before method
    """
    def get_ivar_commented(self):
        """
        Multiline
        Comment
        In method
        """
        return self.ivar_commented


class ClassUsingImportedMetaclass(metaclass=moduleAtRoot8.CustomMetaclass2):
    pass


not moduleAtRoot3.moduleAtRootVariable3

augmentedAssignmentVar = 1
augmentedAssignmentVar += 3
