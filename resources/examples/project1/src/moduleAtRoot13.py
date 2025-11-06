variableIdentifier = 34


class ClassWithVariableAttribute:
    variableAttribute = 35


variableSubscript = [1, 2]
variableSubscript[1] = 3

(variableTuplePattern1, variableTuplePattern2) = 1, 2

[variableListPattern1, variableListPattern2] = [1, 2]

variablePatternListIdentifier1, variablePatternListIdentifier2 = 36, 37

variableAugmentedAssignmentIdentifier = 1
variableAugmentedAssignmentIdentifier += 4


class ClassWithAugmentedAssignment:
    variableAugmentedAssignmentAttribute = 2
    variableAugmentedAssignmentAttribute -= 3


variableAugmentedAssignmentSubscript = [1, 2]
variableAugmentedAssignmentSubscript[1] += 3

while (namedExpressionVariableInWhileCondition := input("Enter something (empty to quit): ")) != "":
    print(f"You entered: {namedExpressionVariableInWhileCondition}")

if (namedExpressionVariableInIfCondition := input("What's your name? ")) != "":
    print(f"Hello, {namedExpressionVariableInIfCondition}!")

print(f"The double of value is {(namedExpressionVariableInInterpolation := 2)}")

# Assign and compare in a single expression
if ((namedExpressionVariableInParenthesizedExpression := len([1, 2, 3])) > 2):
    print(f"List is long enough ({namedExpressionVariableInParenthesizedExpression} elements)")


def function_to_be_called_with_named_expression(length):
    print(f"Length is {length}")


# Named expression in argument list
function_to_be_called_with_named_expression((namedExpressionVariableInArgumentList := len("hello")))

# Named expression inside a tuple
tupleWithNamedExpression = (namedExpressionVariableInTuple := 1, y := 2)

variableToAccessInBinaryOperator = 2
var = variableToAccessInBinaryOperator + 3

variableToAccessInComparisonOperator = 4
print(variableToAccessInComparisonOperator == 5)

variableInUnaryOperator = 5
var = ~variableInUnaryOperator

variableInBooleanOperator = True
var = variableInBooleanOperator and False


def function_to_invoke_in_interpolation():
    return "Cyril"


print(f"Hello ({function_to_invoke_in_interpolation()})")

variableToAccessInPair = 3

{
    'Paire': variableToAccessInPair
}

variableToAccessInLisSplat = [1, 2, 3]

print(*variableToAccessInLisSplat)


def sum3(a, b):
    return a + b


variableToAccessInDictionarySplat = {'a': 1, 'b': 2}
sum3(**variableToAccessInDictionarySplat)  # = sum3(a=1, b=2) = 3, as c is using the default value (0)

variableToAccessInDefaultParameter = 4


def function_with_variable_accessed_in_default_parameter(
        argument_with_default_access=variableToAccessInDefaultParameter):
    return argument_with_default_access + 4


variableToAccessInTypedDefaultParameter = 1


def function_with_variable_accessed_in_typed_default_parameter(
        arg: int = variableToAccessInTypedDefaultParameter) -> int:
    return arg


variableToAccessInLambdaDefaultParameter = 2

lambda lambda_access_parameter=variableToAccessInLambdaDefaultParameter: lambda_access_parameter

variableToAccessInAssertStatement = 3

assert variableToAccessInAssertStatement < 4

variableToAccessInLambdaBody = 3

lambda: variableToAccessInLambdaBody + 5

variableWithDictionaryToAccessInDictionarySplat = {"name": "Alice", "age": 30}
extended = {**variableWithDictionaryToAccessInDictionarySplat, "location": "Paris"}

variableToAccessInDictionaryComprehension = 3
variableToAccessInDictionaryComprehensionForInClause = 10
variableToAccessInDictionaryComprehensionIfClause = [4, 8, 15, 16, 23, 42]

# Use 'multiplier' before the 'for', and 'threshold' after it
result = {
    localVarToAccessInDictionaryComprehension * variableToAccessInDictionaryComprehension: localVarToAccessInDictionaryComprehension
    for localVarToAccessInDictionaryComprehension in variableToAccessInDictionaryComprehensionForInClause if
    localVarToAccessInDictionaryComprehension > variableToAccessInDictionaryComprehensionIfClause}

variableToAccessInListComprehensionIfClause = 10
variableToAccessInListComprehensionForInClause = [4, 7, 11, 15, 3]

# List comprehension accessing the global variable 'limit'
large_numbers = [localVarToAccessInListComprehension for localVarToAccessInListComprehension in
                 variableToAccessInListComprehensionForInClause if
                 localVarToAccessInListComprehension > variableToAccessInListComprehensionIfClause]

variableToAccessInList = 5
my_list = [1, 2, variableToAccessInList, 4]

variableToAccessInListSplat = [3, 4, 5]
my_list2 = [1, 2, *variableToAccessInListSplat, 6]

print(localVarToAccessInGeneratorExpression for localVarToAccessInGeneratorExpression in range(5))

variableToAccessInConcatenatedString = "Hello"

var = "To say:\n" \
      f" ({variableToAccessInConcatenatedString})"

"String with escaped interpolation {{notAVariable}}"

my_list = [1, 2, 3, 4, 5]


def function_to_invoke_in_subscript_in_assignment():
    return 2


my_list[function_to_invoke_in_subscript_in_assignment()] = 10


def function_to_invoke_in_parenthesized_expression():
    return 3


(function_to_invoke_in_parenthesized_expression)()


def function_to_invoke_in_list_splat(indices):
    return [slice(start, end) for start, end in zip(indices[:-1], indices[1:])]


indices = [0, 2, 4, 6, 8]

var = [*function_to_invoke_in_list_splat(slice, indices[:-1], indices[1:])]

variableToAccessInTuple = 7
aTuple = (1, 2, variableToAccessInTuple, 4)

def variable_to_access_in_tuple_return():
    variableToAccessInTuple = 8
    return 0, variableToAccessInTuple

def function_with_keyword_argument(arg0, arg1=10):
    return arg0 + arg1

variableToAccessInKeywordArgumentCall = 42
function_with_keyword_argument(1, arg1 = variableToAccessInKeywordArgumentCall)

variableToAccessInKeywordArgumentCallInParenthesis = 42 
function_with_keyword_argument(1, arg1 = (variableToAccessInKeywordArgumentCallInParenthesis))


def variable_to_access_in_array_slice_1():
    variableToAccessInArraySlice = 2
    my_array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    return my_array[:variableToAccessInArraySlice]

def variable_to_access_in_array_slice_2():
    variableToAccessInArraySlice = 5
    my_array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    return my_array[1:variableToAccessInArraySlice]

def variable_to_access_in_array_slice_3():
    variableToAccessInArraySlice = 2
    my_array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    return my_array[::variableToAccessInArraySlice]

def variable_to_access_in_array_slice_with_parentheses():
    variableToAccessInArraySlice = 3
    my_array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    return my_array[1:(variableToAccessInArraySlice)]
