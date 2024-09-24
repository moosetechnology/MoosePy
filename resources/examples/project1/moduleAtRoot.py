import root
import root.subpackage1

moduleAtRootVariable = 12

print(root.rootPackageVariable)
print(root.subpackage1.subPackage1Variable)

#============================================================
# Python program to sort
# one list using
# the other list

def sort_list(list1, list2):

	zipped_pairs = zip(list2, list1)

	z = [x for _, x in sorted(zipped_pairs)]

	return z


# driver code
x = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
y = [0, 1, 1, 0, 1, 2, 2, 0, 1]

print(sort_list(x, y))

x = ["g", "e", "e", "k", "s", "f", "o", "r", "g", "e", "e", "k", "s"]
y = [0, 1, 1, 0, 1, 2, 2, 0, 1]

print(sort_list(x, y))

#============================================================

import root2
print(root2.rootPackage2Variable)


#============================================================

def functionWithImport():
	import moduleAtRoot3
	return not moduleAtRoot3.moduleAtRoot3Variable