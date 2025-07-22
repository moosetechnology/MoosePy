# I'll  contain a lot of examples of parameters

def function_with_identifier_parameters(identifier_parameter1, identifier_parameter2):
    return identifier_parameter1 + identifier_parameter2


print(function_with_identifier_parameters(1, 3))


def function_with_default_parameter(default_parameter=1):
    return default_parameter + 3


print(function_with_default_parameter())


def function_with_list_splat(*list_splat_parameter):
    for name in list_splat_parameter:
        print(name)


function_with_list_splat("Cyril", "Benoit")


def function_with_dictionary_splat(**dictionary_splat_pattern_parameter):
    for key, value in dictionary_splat_pattern_parameter.items():
        print(key + " " + value)


function_with_dictionary_splat(name="Cyril", location="Lille")


def function_with_keyword_separator(arg1, arg2, *, arg3, arg4):
    return arg1 + arg2 + arg3 + arg4


function_with_keyword_separator(1, 2, arg4=3, arg3=4)


def function_with_positional_separator(arg1, arg2, /, arg3):
    return arg1 + arg2 + arg3


function_with_positional_separator(1, 2, 3)


def function_with_typed_parameter(typed_parameter: int) -> int:
    return typed_parameter


function_with_typed_parameter(1)


def function_with_typed_default_parameter(default_typed_parameter: int = 5) -> int:
    return default_typed_parameter + 5


function_with_typed_default_parameter()


def function_with_combo_parameters(a, b, /, c, *, d, **kwargs):
    return a, b, c, d, kwargs


lambda lambda_parameter_identifier: lambda_parameter_identifier

lambda lambda_default_parameter=1: lambda_default_parameter

lambda *lambda_parameter_list_splat: lambda_parameter_list_splat[1]

lambda **lambda_parameter_dictionary_splat: lambda_parameter_dictionary_splat["name"]

lambda arg1, *, arg2: arg1 + arg2

lambda arg1, /, arg2: arg1 + arg2
