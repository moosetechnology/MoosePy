from nonexisting import StubClass

class ClassWithStubSuperclass(StubClass):
    pass

import StubClass

#This import does not exists but has the name of a stub that exists
print(StubClass)