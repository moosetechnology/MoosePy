import packagesToReference.packagesToReference2
import packagesToReference.packagesToReference7 as package
import packagesToReference.moduleToReference2
import packagesToReference.moduleToReference7 as module

print(packagesToReference.packagesToReference2)
print(package)


class ClassReferencingAPackage:
    import packagesToReference.packagesToReference3
    varReferencingPackage = packagesToReference.packagesToReference3

    def method_referencing_package(self):
        import packagesToReference.packagesToReference4
        return packagesToReference.packagesToReference4


def function_referencing_package():
    import packagesToReference.packagesToReference5
    return packagesToReference.packagesToReference5


def function_with_lambda_with_package_ref():
    import packagesToReference.packagesToReference6
    return lambda: packagesToReference.packagesToReference6


print(function_with_lambda_with_package_ref()())

print(packagesToReference.moduleToReference2)
print(module)


class ClassReferencingAModule:
    import packagesToReference.moduleToReference3
    varReferencingModule = packagesToReference.moduleToReference3

    def method_referencing_module(self):
        import packagesToReference.moduleToReference4
        return packagesToReference.moduleToReference4


def function_referencing_module():
    import packagesToReference.moduleToReference5
    return packagesToReference.moduleToReference5


def function_with_lambda_with_module_ref():
    import packagesToReference.moduleToReference6
    return lambda: packagesToReference.moduleToReference6


print(function_with_lambda_with_module_ref()())
