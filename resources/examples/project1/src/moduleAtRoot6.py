import root2.NameOfSubpackageOrClass

print(root2.NameOfSubpackageOrClass)


def function_with_multiple_assignations():
    local_multiple1 = local_multiple2 = local_multiple3 = 2
    local_multiple1 = 3
    return local_multiple1 + local_multiple2 + local_multiple3


print(function_with_multiple_assignations())


def function_to_shadow():
    return 1


print(function_to_shadow())


def function_to_shadow():
    return 2


print(function_to_shadow())


def function_to_shadow_with_different_signature():
    return 7


print(function_to_shadow_with_different_signature())


def function_to_shadow_with_different_signature(age):
    return age


print(function_to_shadow_with_different_signature(3))


def function_with_common_name():
    return True


def function_with_local_variables():
    local_in_function1 = 1
    local_in_function2 = 2
    return local_in_function1 + local_in_function2


def function_with_local_variables2():
    local_in_function1 = 1
    return local_in_function1


def function_with_local_variables_and_tuples():
    local_in_function_with_tuple1, local_in_function_with_tuple2 = (1, 2)
    return local_in_function_with_tuple1 + local_in_function_with_tuple2

