class AbstractAnimal:
    name = ""


class AClassToReference:
    pass


class AClassReferencingAClass:
    cvar_referencing_class = AClassToReference

    def method_referencing_class(self):
        return AClassToReference


def function_referencing_class():
    return AClassToReference


def function_with_lambda_referencing_class():
    return lambda: AClassToReference


print(function_referencing_class())
print(AClassReferencingAClass().method_referencing_class())
print(function_with_lambda_referencing_class()())
