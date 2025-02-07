import moduleAtRoot as mar
import root.subpackage1.subsubpackage1 as rss
from root2.moduleInRootPackage2 import Employee as Emp, functionWithImportsInRoot2 as fwi, Employee2
from moduleAtRoot2 import moduleAtRoot2Variable as marv

print(mar.moduleAtRootVariable)
print(mar.sort_list(["a", "b", "c", "d", "e", "f", "g", "h", "i"], [0, 1, 1, 0, 1, 2, 2, 0, 1]))
print(rss.subSubPackage1Variable)
print(Emp)
print(fwi)
print(fwi())
print(marv)
print(Employee2)
print(Emp("Imen", 37))
