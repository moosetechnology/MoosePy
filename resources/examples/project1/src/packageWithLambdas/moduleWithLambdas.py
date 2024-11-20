moduleVariableLambda = lambda a, b: a * b + 10

print(moduleVariableLambda(10, 5))


def function_returning_lambda(n):
    return lambda a: a * n


mydoubler = function_returning_lambda(2)
mytripler = function_returning_lambda(3)

print(mydoubler(11))
print(mytripler(11))


class ClassWithLambda:
    classVarWithLambda = lambda toto: print(toto.upper())

    def method_with_lambda(self, param):
        tempVar = lambda tata: not tata
        return tempVar(param)


c = ClassWithLambda()
print(c.method_with_lambda(False))
c.__class__.classVarWithLambda("cyril")


def function_with_lambda_in_lambda(n):
    mul = lambda x: (lambda y: y * x + n)
    return mul(4)


print(function_with_lambda_in_lambda(2)(4))


def function_with_lambda_without_parameters():
    return lambda: 10


def function_with_lambda_with_temporary():
    return lambda: (
        temporary_in_lambda := "Hello world",
        print(temporary_in_lambda + "\n")
    )[-1]


function_with_lambda_with_temporary()()
