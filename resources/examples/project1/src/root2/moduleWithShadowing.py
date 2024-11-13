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