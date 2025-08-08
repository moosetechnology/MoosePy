from nonexisting import StubClass


class ClassWithStubSuperclass(StubClass):

    def method_calling_missing_super(self):
        self.missing_super_method()


import StubClass

# This import does not exists but has the name of a stub that exists
print(StubClass)
