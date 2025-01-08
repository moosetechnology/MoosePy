import moduleAtRoot as mar
import root.subpackage1.subsubpackage1 as rss
from root2.moduleInRootPackage2 import Employee as Emp, functionWithImportsInRoot2 as fwi, Employee2
from moduleAtRoot2 import moduleAtRoot2Variable as marv

print(mar.moduleAtRootVariable)
print(rss.subSubPackage1Variable)
print(Emp)
print(fwi)
print(fwi())
print(marv)
print(Employee2)
