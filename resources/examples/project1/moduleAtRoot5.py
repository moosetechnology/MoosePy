from root import rootPackageVariable
from moduleAtRoot import moduleAtRootVariable
from moduleAtRoot2 import Person
from moduleAtRoot import sort_list

print(rootPackageVariable)
print(moduleAtRootVariable)

p1 = Person("Imen", 37)
p1.printInfos()

x = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
y = [0, 1, 1, 0, 1, 2, 2, 0, 1]

print(sort_list(x, y))