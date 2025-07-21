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