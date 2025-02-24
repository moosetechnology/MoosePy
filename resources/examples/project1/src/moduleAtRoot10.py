from package import subpackage

subpackage.function([1, 2, 3, 4])


def function_to_try_keywords_parameters(param1, param2):
    return param1 + param2


print(function_to_try_keywords_parameters(param2=2, param1=5))
