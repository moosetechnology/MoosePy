# I contain multiple cases of invocations I cannot manage and I am used to test we do not create anything for them

def function_to_invoke():
    pass


my_dict = {'a': function_to_invoke, 'b': 2, 'c': 3}
my_dict['a']()


def function_returning_function():
    return function_to_invoke


function_returning_function()()

