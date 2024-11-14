shadowedName = 3


class shadowedName:
    shadowedNameVar = 2


def shadowedName():
    print("I'm the last one so I win")


def function_shadowed_by_class():
    return 2


class function_shadowed_by_class:
    pass


class ClassShadowedByOtherClass:
    c_var_of_shadowed_class = True


print(ClassShadowedByOtherClass().__class__.__dict__)


class ClassShadowedByOtherClass:

    def __init__(self):
        self.i_var_of_shadowed_class = 3


print(ClassShadowedByOtherClass().__class__.__dict__)

global_then_function_then_global_then_class = 13

print(global_then_function_then_global_then_class)


def global_then_function_then_global_then_class():
    print(14)


global_then_function_then_global_then_class()
print(global_then_function_then_global_then_class)

global_then_function_then_global_then_class = 15

print(global_then_function_then_global_then_class)


class global_then_function_then_global_then_class:
    def __init__(self):
        print(16)


global_then_function_then_global_then_class()
print(global_then_function_then_global_then_class)


class ClassShadowedByGlobal:
    pass


ClassShadowedByGlobal = True
