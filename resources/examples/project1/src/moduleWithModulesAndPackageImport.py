from root import moduleInRootPackage

print(moduleInRootPackage.moduleInRootVariable)


def function_importing_module():
    from root.subpackage1 import moduleInSubPackage1
    return moduleInSubPackage1.moduleInSubpackage1Variable


class ClassImportingModule:
    from root import moduleToTestSourceAnchor

    var_of_class_importing_module = moduleToTestSourceAnchor.fibonacci

    def method_importing_module(self):
        from root.subpackage1 import moduleInSubPackage1
        return moduleInSubPackage1.moduleInSubpackage1Variable
