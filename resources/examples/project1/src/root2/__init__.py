import root
import root.subpackage1.subsubpackage1
import root.subpackage1.moduleInSubPackage1
import moduleAtRoot3

print(root.subpackage1.moduleInSubPackage1.moduleInSubpackage1Variable)

print(root.rootPackageVariable)
print(root.subpackage1.subsubpackage1.subSubPackage1Variable)
print(moduleAtRoot3.moduleAtRootVariable3)

rootPackage2Variable = 99


class NameOfSubpackageOrClass:
    class_var = "test"
