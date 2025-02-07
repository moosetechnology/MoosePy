from moduleAtRoot import moduleAtRootVariable
import root.subpackage1.subsubpackage1
import root2 . subpackageInRoot2

print(moduleAtRootVariable)

print(root.subpackage1.subsubpackage1.function_with_function_ref())

print(root2. subpackageInRoot2. function_returning_75())

def functionReturningSomething():
	return 8
