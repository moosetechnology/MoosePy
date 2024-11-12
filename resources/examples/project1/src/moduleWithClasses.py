def function_with_class_inside():
    class ClassInFunction:
        def __init__(self):
            self.varInClassInFunction = False

    c = ClassInFunction()
    return c.__dict__


print(function_with_class_inside())


class ClassWithClasses:
    class ClassInClass:
        def __init__(self):
            self.varInClassInClass = 3

    print(ClassInClass())

    def __init__(self):
        class ClassInMethod:
            def __init__(self):
                self.varInClassInMethod = 5

        print(ClassInMethod().varInClassInMethod)
        self.varInClassWithClasses = 4


c = ClassWithClasses()
print(c.__dict__)
