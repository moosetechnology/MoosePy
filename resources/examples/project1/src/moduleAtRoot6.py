import root2.NameOfSubpackageOrClass

print(root2.NameOfSubpackageOrClass)


def function_with_multiple_assignations():
    local_multiple1 = local_multiple2 = local_multiple3 = 2
    local_multiple1 = 3
    return local_multiple1 + local_multiple2 + local_multiple3


print(function_with_multiple_assignations())
