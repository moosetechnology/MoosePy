from __future__ import generator_stop
from __future__ import annotations as annot


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
print(generator_stop)
print(annot)


class ClassWithSelfNotCalledSelf:

    def method_with_first_parameter_not_called_self(this):
        this.instance_variable_with_receiver_not_called_self = 3

    def method_invoking_local_method_without_parameter_called_self(this):
        return this.method_with_first_parameter_not_called_self()
