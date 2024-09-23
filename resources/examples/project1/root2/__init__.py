import root
import root.subpackage1.subsubpackage1
import root.subpackage1.moduleInSubPackage1
import moduleAtRoot

print(root.subpackage1.moduleInSubPackage1.moduleInSubpackage1Variable)

print(root.rootPackageVariable)
print(root.subpackage1.subsubpackage1.subSubPackage1Variable)
print(moduleAtRoot.moduleAtRootVariable)

rootPackage2Variable = 99