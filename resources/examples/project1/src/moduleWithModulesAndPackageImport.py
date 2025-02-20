from root import moduleInRootPackage
from root import subpackage1

print(moduleInRootPackage.moduleInRootVariable)
print(subpackage1.subPackage1Variable)


def function_importing_module():
    from root.subpackage1 import moduleInSubPackage1
    return moduleInSubPackage1.moduleInSubpackage1Variable


def function_importing_package():
    from root2 import subpackageInRoot2
    return subpackageInRoot2.function_returning_75


class ClassImportingModule:
    from root import moduleToTestSourceAnchor

    var_of_class_importing_module = moduleToTestSourceAnchor.fibonacci

    def method_importing_module(self):
        from root.subpackage1 import moduleInSubPackage1
        return moduleInSubPackage1.moduleInSubpackage1Variable


class ClassImportingPackage:
    from root2 import subpackageInRoot2

    var_of_class_importing_package = subpackageInRoot2.function_returning_75()

    def method_importing_package(self):
        from root.subpackage1 import subsubpackage1
        return subsubpackage1.return2()
