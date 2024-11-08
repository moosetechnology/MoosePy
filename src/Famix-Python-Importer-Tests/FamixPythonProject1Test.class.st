Class {
	#name : 'FamixPythonProject1Test',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonProject1Test class >> resources [

	^ { FamixPythonProject1TestResource }
]

{ #category : 'accessing' }
FamixPythonProject1Test >> model [

	^ FamixPythonProject1TestResource current model
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsClassFromAModule [

	| class class1 import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	class1 := self classNamed: 'Person'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: class1.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsClassFromAPackage [

	| class class1 import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	class1 := self classNamed: 'Room'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: class1.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsFunctionFromAModule [

	| class function import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	function := self functionNamed: 'sort_list'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsFunctionFromAPackage [

	| class function import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	function := self functionNamed: 'return2'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsGlobalVariableFromAModule [

	| class global import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsGlobalVariableFromAPackage [

	| class global import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testClassImportsModule [

	| class import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Person'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3').
	self assert: import sourceText equals: 'import moduleAtRoot3'
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassInPackage [

	| class |

	class := self classNamed: 'ClassInSubpackage'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'ClassInSubpackage'.
	self assert: class typeContainer equals: (self packageNamed: 'subpackage1')
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariableAreDefinedOnlyOnce [
	"We should have only one ivar even if it is assigned multiple times."

	self assert: (self model allAttributes select: [ :attribute | attribute name = 'sound' ]) size equals: 1
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariableNotAtTheBeginningOfTheClass [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'sound'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'sound'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self assert: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariableSourceAnchor [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'sound'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'sound'.
	"The start and end pos should be the one of the first assignation and not the second"
	self assert: variable sourceAnchor startPos equals: 577.
	self assert: variable sourceAnchor endPos equals: 581
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariablesAssignedWithATuple [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'cvarTuple1'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'cvarTuple1'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self assert: variable isClassSide.

	variable := self attributeNamed: 'cvarTuple2'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'cvarTuple2'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self assert: variable isClassSide.

	variable := self attributeNamed: 'cvarTuple3'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'cvarTuple3'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self assert: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariablesWithSameNameButDifferenClass [

	| variables |
	variables := self model allAttributes select: [ :variable | variable name = 'furniture_color' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self classNamed: 'Chair').
			(self classNamed: 'Stool') }
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testConstructor [

	| method |
	self denyEmpty: self model allMethods.

	method := (self classNamed: 'Person') methods detect: [ :m | m name = '__init__' ].

	self assert: method name equals: '__init__'.
	self assert: method isConstructor.

	method := (self classNamed: 'Person') methods detect: [ :m | m name = 'printInfos' ].

	self assert: method name equals: 'printInfos'.
	self deny: method isConstructor
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testFileWithTwoIdenticalImportsProduceTwoImports [

	| module |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleAtRoot2'.
	self assert: (module outgoingImports select: [ :pimport | pimport target name = 'moduleAtRoot' ]) size equals: 2
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFromImportAGlobalWithAnAlias [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	global := self globalVariableNamed: 'moduleAtRoot2Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot2Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import alias equals: 'marv'.
	self assert: import sourceText equals: 'from moduleAtRoot2 import moduleAtRoot2Variable as marv'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFromImportMultipleElementsWithAliases [

	| module class function import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	class := self classNamed: 'Employee'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'Employee' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: class.
	self assert: import alias equals: 'Emp'.
	self assert: import sourceText equals: 'from root2.moduleInRootPackage2 import Employee as Emp, functionWithImportsInRoot2 as fwi, Employee2'.

	function := self functionNamed: 'functionWithImportsInRoot2'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'functionWithImportsInRoot2' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from root2.moduleInRootPackage2 import Employee as Emp, functionWithImportsInRoot2 as fwi, Employee2'.
	
	self assert: import alias equals: 'fwi'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFromImportStubPackages [

	| matplotlib pyglot plot module import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithStubs2'.
	plot := self unknownContainerNamed: 'plot'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'plot' ].

	pyglot := self packageNamed: 'pyplot'.
	matplotlib := pyglot parentPackage.

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: plot.
	self assert: import importedEntity class equals: FamixPythonUnknownImportedEntity.
	self assert: import importedEntity parentPackage equals: pyglot.
	self assert: import importedEntity parentPackage parentPackage equals: matplotlib.
	self assert: import importedEntity isStub.
	self assert: import importedEntity parentPackage isStub.
	self assert: import importedEntity parentPackage parentPackage isStub.
	self assert: import sourceText equals: 'from matplotlib.pyplot import plot'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsClassFromAModule [

	| function class import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	class := self classNamed: 'Person'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsClassFromAPackage [

	| function class import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	class := self classNamed: 'Room'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsFunctionFromAModule [

	| function function1 import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	function1 := self functionNamed: 'sort_list'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: function1.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsFunctionFromAPackage [

	| function function1 import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	function1 := self functionNamed: 'return2'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: function1.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsGlobalVariableFromAModule [

	| function global import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsGlobalVariableFromAPackage [

	| function global import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testFunctionImportsModule [

	| function import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImport'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3').
	self assert: import sourceText equals: 'import moduleAtRoot3'
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionInAFunction [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'inner_function'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'inner_function'.
	self assert: function signature equals: 'inner_function(finput)'.
	self assert: function functionOwner equals: (self functionNamed: 'function_with_inner_function')
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionInAModule [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'functionWithImport'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'functionWithImport'.
	self assert: function signature equals: 'functionWithImport()'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionInAPackage [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'return2'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'return2'.
	self assert: function signature equals: 'return2()'.
	self assert: function functionOwner equals: (self packageNamed: 'subsubpackage1')
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionSourceAnchor [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'sort_list'.

	self assert: function sourceAnchor isNotNil.
	self assert: function sourceText equals: ('def sort_list(list1, list2):
	zipped_pairs = zip(list2, list1)
	z = [x for _, x in sorted(zipped_pairs)]
	return z' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionsWithSameNameButDifferentParents [

	| functions |
	functions := self model allFunctions select: [ :funct | funct name = 'function_with_common_name' ].

	self assert: functions size equals: 2.
	self assertCollection: (functions collect: #functionOwner) hasSameElements: {
			(self moduleNamed: 'moduleAtRoot6').
			(self packageNamed: 'root') }
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testGetterAndSetter [

	| class getter setter |
	self denyEmpty: self model allMethods.

	class := self classNamed: 'Person'.
	getter := class methods detect: [ :m | m name = 'get_name' ].
	setter := class methods detect: [ :m | m name = 'set_name' ].

	self assert: getter name equals: 'get_name'.
	self assert: getter isGetter.
	self deny: getter isSetter.
	self deny: getter isConstructor.

	self assert: setter name equals: 'set_name'.
	self deny: setter isGetter.
	self assert: setter isSetter.
	self deny: setter isConstructor
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableAreDefinedOnlyOnce [
	"We should have only one global even if it is assigned multiple times."

	self assert: (self model allGlobalVariables select: [ :globalVariable | globalVariable name = 'globalAssignedTwice' ]) size equals: 1
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableInModule [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'moduleAtRootVariable'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'moduleAtRootVariable'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot').
	
	self assert: global sourceAnchor isNotNil.
	self assert: global sourceText equals: 'moduleAtRootVariable'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableInPackage [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'rootPackageVariable'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'rootPackageVariable'.
	self assert: global parentScope equals: (self packageNamed: 'root').

	self assert: global sourceAnchor isNotNil.
	self assert: global sourceText equals: 'rootPackageVariable'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableSourceAnchor [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'moduleAtRootVariable'.

	self assert: global sourceAnchor isNotNil.
	self assert: global sourceText equals: 'moduleAtRootVariable'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariablesAssignedWithATuple [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'globalWithTuple1'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'globalWithTuple1'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot').

	global := self globalVariableNamed: 'globalWithTuple2'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'globalWithTuple2'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot').

	global := self globalVariableNamed: 'globalWithTuple3'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'globalWithTuple3'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariablesWithTheSameNameButDifferentParents [

	| globals |
	globals := self model allGlobalVariables select: [ :variable | variable name = 'globalVariableWithCommonName' ].

	self assert: globals size equals: 2.
	self assertCollection: (globals flatCollect: #parents) hasSameElements: {
			(self moduleNamed: 'moduleAtRoot').
			(self moduleNamed: 'moduleAtRoot2') }
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testImportAClassThatHasTheSameNameAsSubpackage [
	"We have a package with a class and a subpackage of the same name and here we check we manage well the imports of those entities"

	| module class import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleAtRoot7'.
	class := self classNamed: 'NameOfSubpackageOrClass'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'NameOfSubpackageOrClass' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from root2 import NameOfSubpackageOrClass'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportAModuleWithAnAlias [

	| module module2 import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	module2 := self moduleNamed: 'moduleAtRoot'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: module2.
	self assert: import alias equals: 'mar'.
	self assert: import sourceText equals: 'import moduleAtRoot as mar'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportASubpackageThatHasTheSameNameAsAClass [
	"We have a package with a class and a subpackage of the same name and here we check we manage well the imports of those entities"

	| module package import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleAtRoot6'.
	package := self packageNamed: 'NameOfSubpackageOrClass'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'NameOfSubpackageOrClass' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: package.
	self assert: import sourceText equals: 'import root2.NameOfSubpackageOrClass'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportASubpackageWithAnAlias [

	| module package import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	package := self packageNamed: 'subsubpackage1'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: package.
	self assert: import alias equals: 'rss'.
	self assert: import sourceText equals: 'import root.subpackage1.subsubpackage1 as rss'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testImportAnEntityThatIsShadowed [
	"I created a module with a name that is shadowed. First it is assigned to a global variable then a class then a function. If we import the entity, the last decalred should win"

	| module function import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInRootPackage21'.
	function := self functionNamed: 'shadowedName'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'shadowedName' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: function.
	self assert: import importedEntity class equals: FamixPythonFunction.
	self assert: import sourceText equals: 'from root2.moduleWithShadowing import shadowedName'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportSourceAnchor [

	| rootModule1 rootModule2 import |
	self denyEmpty: self model allImports.
	rootModule1 := self moduleNamed: 'moduleAtRoot'.
	rootModule2 := self moduleNamed: 'moduleAtRoot2'.
	import := rootModule2 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: rootModule2.
	self assert: import importedEntity equals: rootModule1.
	
	self assert: import sourceAnchor isNotNil.
	self assert: import sourceText equals: 'import moduleAtRoot'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportStubPackages [
	"For now, if we have a stub at the end of an import we create a package all the time and not a module because we cannot know what kind it is and it is the simplest code."

	| matplotlib pyglot module import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithStubs'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'pyplot' ].

	pyglot := self packageNamed: 'pyplot'.
	matplotlib := pyglot parentPackage.

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: pyglot.
	self assert: import sourceText equals: 'import matplotlib.pyplot'.

	self assert: pyglot name equals: 'pyplot'.
	self assert: pyglot class equals: FamixPythonPackage.
	self assert: pyglot isStub.

	self assert: matplotlib name equals: 'matplotlib'.
	self assert: matplotlib class equals: FamixPythonPackage.
	self assert: matplotlib isStub
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportThatIsNotAtTheRootOfAFile [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'root2' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'root2').
	self assert: import sourceText equals: 'import root2'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportTwoStubPackagesOfTheSameName [
	"If two imports import a stub package of the same name, we should not produce multiple stubs."

	| pyplot numpy |
	self assert: (self model allPackages select: [ :package | package name = 'matplotlib' ]) size equals: 1.
	self assert: (self model allPackages select: [ :package | package name = 'pyplot' ]) size equals: 1.
	self assert: (self model allPackages select: [ :package | package name = 'numpy' ]) size equals: 1.

	pyplot := self packageNamed: 'pyplot'.
	numpy := self packageNamed: 'numpy'.

	"We ensure that those two are imported by more than 1 module"
	self assert: ((self moduleNamed: 'moduleAtRoot4') outgoingImports anySatisfy: [ :import | import importedEntity = pyplot ]).
	self assert: ((self moduleNamed: 'moduleAtRoot4') outgoingImports anySatisfy: [ :import | import importedEntity = numpy ]).

	self assert: ((self moduleNamed: 'moduleWithStubs') outgoingImports anySatisfy: [ :import | import importedEntity = pyplot ]).
	self assert: ((self moduleNamed: 'moduleWithStubs') outgoingImports anySatisfy: [ :import | import importedEntity = numpy ])
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariableAreDefinedOnlyOnce [
	"We should have only one ivar even if it is assigned multiple times."

	self assert: (self model allAttributes select: [ :attribute | attribute name = 'dog_color' ]) size equals: 1
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariableDeclaredOutsideOfInit [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'dog_color'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'dog_color'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self deny: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariableSourceAnchor [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'dog_color'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'self.dog_color'.
	"The start and end pos should be the one of the first assignation and not the second"
	self assert: variable sourceAnchor startPos equals: 348.
	self assert: variable sourceAnchor endPos equals: 361
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariablesAssignedWithATuple [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'ivarTuple1'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'ivarTuple1'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self deny: variable isClassSide.

	variable := self attributeNamed: 'ivarTuple2'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'ivarTuple2'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self deny: variable isClassSide.

	variable := self attributeNamed: 'ivarTuple3'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'ivarTuple3'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self deny: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariablesWithSameNameButDifferenClass [

	| variables |
	variables := self model allAttributes select: [ :variable | variable name = 'number_of_legs' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self classNamed: 'Chair').
			(self classNamed: 'Stool') }
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAClass [

	| lambda container |
	container := self classNamed: 'ClassWithLambda'.

	self assert: container class equals: FamixPythonClass.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'toto'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAFunction [

	| lambda container |
	container := self functionNamed: 'function_returning_lambda'.

	self assert: container class equals: FamixPythonFunction.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'a'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInALambda [

	| lambda container |
	container := self functionNamed: 'function_with_lambda_in_lambda'.

	self assert: container class equals: FamixPythonFunction.
	self assert: container lambdas size equals: 1.

	container := container lambdas first.

	self assert: container class equals: FamixPythonLambda.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'y'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAMethod [

	| lambda container |
	container := self methodNamed: 'method_with_lambda'.

	self assert: container class equals: FamixPythonMethod.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'tata'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAModule [

	| lambda container |
	container := self moduleNamed: 'moduleWithLambdas'.

	self assert: container class equals: FamixPythonModule.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'a, b'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAPackage [

	| lambda container |
	container := self packageNamed: 'packageWithLambdas'.
	
	self assert: container class equals: FamixPythonPackage.
	self assert: container lambdas size equals: 1.
	
	lambda := container lambdas anyOne.
	
	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'a'.
	self assert: lambda lambdaContainer equals: container
	
	
	
	
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaSourceAnchor [

	| lambda |
	lambda := (self packageNamed: 'packageWithLambdas') lambdas anyOne.

	self assert: lambda sourceAnchor isNotNil.
	self assert: lambda sourceText equals: 'lambda a: a + 10'
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaWithoutParameters [

	| lambda container |
	container := self functionNamed: 'function_with_lambda_without_parameters'.

	self assert: container class equals: FamixPythonFunction.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: ''.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariableInFunctionSourceAnchor [

	| variable |
	variable := self localVariableNamed: 'local_in_function2'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'local_in_function2'
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariableInMethodSourceAnchor [

	| variable |
	variable := self localVariableNamed: 'local_in_method2'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'local_in_method2'
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInFunctionAssignedWithATuple [

	| global |
	self denyEmpty: self model allLocalVariables.

	global := self localVariableNamed: 'local_in_function_with_tuple1'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_function_with_tuple1'.
	self assert: global parentBehaviouralEntity equals: (self functionNamed: 'function_with_local_variables_and_tuples').

	global := self localVariableNamed: 'local_in_function_with_tuple2'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_function_with_tuple2'.
	self assert: global parentBehaviouralEntity equals: (self functionNamed: 'function_with_local_variables_and_tuples')
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInFunctionWithTheSameNameButDifferentParents [

	| variables |
	variables := self model allLocalVariables select: [ :variable | variable name = 'local_in_function1' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self functionNamed: 'function_with_local_variables').
			(self functionNamed: 'function_with_local_variables2') }
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInMethodAssignedWithATuple [

	| global |
	self denyEmpty: self model allLocalVariables.

	global := self localVariableNamed: 'local_in_method_with_tuple1'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_method_with_tuple1'.
	self assert: global parentBehaviouralEntity equals: (self methodNamed: 'method_with_local_variables_and_tuples').

	global := self localVariableNamed: 'local_in_method_with_tuple2'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_method_with_tuple2'.
	self assert: global parentBehaviouralEntity equals: (self methodNamed: 'method_with_local_variables_and_tuples')
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInMethodWithTheSameNameButDifferentParents [

	| variables |
	variables := self model allLocalVariables select: [ :variable | variable name = 'local_in_method1' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self methodNamed: 'method_with_local_variables').
			(self methodNamed: 'method_with_local_variables2') }
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsClassFromAModule [

	| method class import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	class := self classNamed: 'Person'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsClassFromAPackage [

	| method class import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	class := self classNamed: 'Room'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsFunctionFromAModule [

	| method function import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	function := self functionNamed: 'sort_list'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsFunctionFromAPackage [

	| method function import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	function := self functionNamed: 'return2'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsGlobalVariableFromAModule [

	| method global import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsGlobalVariableFromAPackage [

	| method global import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testMethodImportsModule [

	| method import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'printInfos'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot4' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot4').
	self assert: import sourceText equals: 'import moduleAtRoot4'
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testMethodSourceAnchor [

	| method |
	self denyEmpty: self model allMethods.

	method := self methodNamed: 'printInfos'.

	self assert: method sourceAnchor isNotNil.
	self assert: method sourceText equals: ('def printInfos(self):
        import moduleAtRoot4
        if not moduleAtRoot3.moduleAtRootVariable3:
            print(self.name + moduleAtRoot4.moduleAtRootSpaceString + str(self.age))' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests' }
FamixPythonProject1Test >> testModel [

	self assert: self model isNotEmpty.
	self assert: self model name equals: 'project1'.
	self assert: self model rootFolder equals: FamixPythonBridge parsingExamples / 'project1'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsClassFromAModule [

	| rootModule class import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	class := self classNamed: 'Person'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsClassFromAPackage [

	| rootModule class import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	class := self classNamed: 'Room'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsFunctionFromAModule [

	| rootModule function import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	function := self functionNamed: 'sort_list'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsFunctionFromAPackage [

	| rootModule function import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	function := self functionNamed: 'return2'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModule [

	| rootModule global import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleInAPackageOneLevelHigherRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInSubPackage3'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from ..moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleInASubpackageRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInRootPackage3-2'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from .subpackage3.moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInRootPackage3-2'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleRelativelyWithSpacesInPath [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInSubSubPackage3'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from .. moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAPackage [

	| rootModule global import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsModule [

	| rootModule1 rootModule2 import |
	self denyEmpty: self model allImports.
	rootModule1 := self moduleNamed: 'moduleAtRoot'.
	rootModule2 := self moduleNamed: 'moduleAtRoot2'.
	import := rootModule2 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: rootModule2.
	self assert: import importedEntity equals: rootModule1.
	self assert: import sourceText equals: 'import moduleAtRoot'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsModuleInPackage [

	| importingModule importedModule import |
	self denyEmpty: self model allImports.
	importingModule := self moduleNamed: 'moduleInRootPackage2'.
	importedModule := self moduleNamed: 'moduleInSubPackage1'.
	import := importingModule outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubPackage1' ].

	self assert: import importingEntity equals: importingModule.
	self assert: import importedEntity equals: importedModule.
	self assert: import sourceText equals: 'import root.subpackage1.moduleInSubPackage1'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsMultipleElements [

	| module global class function import import2 import3 |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleImportingMultipleItems'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].
	class := self classNamed: 'ClassInModuleInRoot3'.
	import2 := module outgoingImports detect: [ :pimport | pimport target name = 'ClassInModuleInRoot3' ].
	function := self functionNamed: 'function_in_module_in_root3'.
	import3 := module outgoingImports detect: [ :pimport | pimport target name = 'function_in_module_in_root3' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable, ClassInModuleInRoot3, function_in_module_in_root3'.
	self assert: import2 importingEntity equals: module.
	self assert: import2 importedEntity equals: class.
	self assert: import2 sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable, ClassInModuleInRoot3, function_in_module_in_root3'.
	self assert: import3 importingEntity equals: module.
	self assert: import3 importedEntity equals: function.
	self assert: import3 sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable, ClassInModuleInRoot3, function_in_module_in_root3'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsMultipleModule [

	| module1 module2 module3 import import2 |
	self denyEmpty: self model allImports.
	module1 := self moduleNamed: 'moduleImportingMultipleItems'.
	module2 := self moduleNamed: 'moduleAtRoot'.
	import := module1 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].
	module3 := self moduleNamed: 'moduleAtRoot3'.
	import2 := module1 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: module1.
	self assert: import importedEntity equals: module2.
	self assert: import2 importingEntity equals: module1.
	self assert: import2 importedEntity equals: module3.
	self assert: import sourceText equals: 'import moduleAtRoot, moduleAtRoot3'.
	self assert: import2 sourceText equals: 'import moduleAtRoot, moduleAtRoot3'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsPackage [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'root' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'root').
	self assert: import sourceText equals: 'import root'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsSubPackage [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'subpackage1' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'subpackage1').
	self assert: import sourceText equals: 'import root.subpackage1'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsSubPackageWithSpacesInThePath [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleWithSpacedImports'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'subsubpackage1').
	self assert: import sourceText equals: 'import root .subpackage1 . subsubpackage1'
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testModuleInRootPackage [

	| module |
	self denyEmpty: self model allModules.

	module := self moduleNamed: 'moduleInRootPackage'.

	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: 'moduleInRootPackage'.
	self deny: module isRoot.
	self assert: module parentPackage equals: (self packageNamed: 'root')
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testModuleInSubPackage [

	| module |
	self denyEmpty: self model allModules.

	module := self moduleNamed: 'moduleInSubPackage1'.

	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: 'moduleInSubPackage1'.
	self deny: module isRoot.
	self assert: module parentPackage equals: (self packageNamed: 'subpackage1')
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleInSubpackageImportsGlobalVariableFromAModuleRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInSubPackage3-2'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from .moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testModulesWithTheSameNameAreDifferent [

	| modules rootModule moduleInPackage |
	modules := self model allModules select: [ :module | module name = 'moduleWithCommonName' ].
	rootModule := modules detect: [ :module | module isRoot ].
	moduleInPackage := modules detect: [ :module | module isRoot not ].

	self assert: modules size equals: 2.
	self assert: rootModule isRoot.
	self assert: moduleInPackage parentPackage name equals: 'root'.
	self deny: rootModule identicalTo: moduleInPackage
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsClassFromAModule [

	| package class import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	class := self classNamed: 'Person'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsClassFromAPackage [

	| package class import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	class := self classNamed: 'Room'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: class.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsFunctionFromAModule [

	| package function import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	function := self functionNamed: 'sort_list'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsFunctionFromAPackage [

	| package function import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	function := self functionNamed: 'return2'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: function.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModule [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModuleInAPackageTwoLevelHigherRelatively [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subsubpackage3'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from ...moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModuleInaPackageOneLevelHigherRelatively [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackage3'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from ..moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModuleRelatively [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackage3'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from .moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAPackage [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testPackageImportsModule [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3').
	self assert: import sourceText equals: 'import moduleAtRoot3'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testPackageImportsPackage [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'root' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self packageNamed: 'root').
	self assert: import sourceText equals: 'import root'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testPackageImportsSubSubPackage [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self packageNamed: 'subsubpackage1').
	self assert: import sourceText equals: 'import root.subpackage1.subsubpackage1'
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testPackageSourceAnchor [

	| rootPackage |
	self denyEmpty: self model allPackages.

	rootPackage := self packageNamed: 'root'.

	self assert: rootPackage sourceAnchor mooseModel equals: self model.
	self assert: rootPackage sourceAnchor sourceText equals: (FamixPythonBridge parsingExamples / 'project1' / 'src' / 'root' / '__init__.py') contents
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testRootModule [

	| rootModule |
	self denyEmpty: self model allModules.

	rootModule := self moduleNamed: 'moduleAtRoot'.

	self assert: rootModule class equals: FamixPythonModule.
	self assert: rootModule name equals: 'moduleAtRoot'.
	self assert: rootModule isRoot.
	self assert: rootModule parentPackage isNil
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testRootPackage [
	| rootPackage |
	self denyEmpty: self model allPackages.
	
	rootPackage := self packageNamed: 'root'.
	
	self assert: rootPackage class equals: FamixPythonPackage.
	self assert: rootPackage name equals: 'root'.
	self assert: rootPackage isRoot
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testShadowableFunction [

	| function shadowable |
	function := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow' ]) asOrderedCollection detectMax: [ :funct |
		            funct sourceAnchor startPos ].
	shadowable := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow' ]) asOrderedCollection detectMin: [ :funct |
		              funct sourceAnchor startPos ].

	self assert: function name equals: 'function_to_shadow'.
	self deny: function isShadowed.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assert: function shadowedEntity equals: shadowable.
	self assert: function sourceText equals: ('def function_to_shadow():
    return 2' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testShadowableFunctionWithDifferentParameter [

	| function shadowable |
	function := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMax: [ :funct |
		            funct sourceAnchor startPos ].
	shadowable := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMin: [ :funct |
		              funct sourceAnchor startPos ].

	self assert: function name equals: 'function_to_shadow_with_different_signature'.
	self deny: function isShadowed.
	self assert: function signature equals: 'function_to_shadow_with_different_signature(age)'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assert: function shadowedEntity equals: shadowable.
	self assert: function sourceText equals: ('def function_to_shadow_with_different_signature(age):
    return age' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testShadowedFunction [

	| function shadower |
	function := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow' ]) asOrderedCollection detectMin: [ :funct |
		            funct sourceAnchor startPos ].
	shadower := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow' ]) asOrderedCollection detectMax: [ :funct |
		            funct sourceAnchor startPos ].

	self assert: function name equals: 'function_to_shadow'.
	self assert: function isShadowed.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assert: function shadowingEntity equals: shadower.
	self assert: function sourceText equals: ('def function_to_shadow():
    return 1' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testShadowedFunctionCreatesDifferentFunctions [

	| functions |
	functions := self model allFunctions select: [ :function | function name = 'function_to_shadow' ].
	self assert: functions size equals: 2.

	functions do: [ :function | self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6') ]
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testShadowedFunctionWithDifferentParameter [

	| function shadower |
	function := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMin: [ :funct |
		            funct sourceAnchor startPos ].
	shadower := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMax: [ :funct |
		            funct sourceAnchor startPos ].

	self assert: function name equals: 'function_to_shadow_with_different_signature'.
	self assert: function isShadowed.
	self assert: function signature equals: 'function_to_shadow_with_different_signature()'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assert: function shadowingEntity equals: shadower.
	self assert: function sourceText equals: ('def function_to_shadow_with_different_signature():
    return 7' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testSimpleClass [

	| class |
	self denyEmpty: self model allClasses.

	class := self classNamed: 'Person'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Person'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleAtRoot2')
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testSimpleClassVariable [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'kind'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'kind'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self assert: variable isClassSide
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testSimpleFunction [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'sort_list'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'sort_list'.
	self assert: function signature equals: 'sort_list(list1, list2)'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testSimpleInstanceVariable [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'dog_name'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'dog_name'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self deny: variable isClassSide
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testSimpleLocalVariableInFunction [

	| variable |
	variable := self localVariableNamed: 'local_in_function2'.

	self assert: variable class equals: FamixPythonLocalVariable.
	self assert: variable name equals: 'local_in_function2'.
	self assert: variable parentBehaviouralEntity equals: (self functionNamed: 'function_with_local_variables')
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testSimpleLocalVariableInMethod [

	| variable |
	variable := self localVariableNamed: 'local_in_method2'.

	self assert: variable class equals: FamixPythonLocalVariable.
	self assert: variable name equals: 'local_in_method2'.
	self assert: variable parentBehaviouralEntity equals: (self methodNamed: 'method_with_local_variables')
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testSimpleMethod [

	| method |
	self denyEmpty: self model allMethods.

	method := self methodNamed: 'printInfos'.

	self assert: method class equals: FamixPythonMethod.
	self assert: method name equals: 'printInfos'.
	self assert: method signature equals: 'printInfos(self)'.
	self assert: method parentType equals: (self classNamed: 'Person')
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testSourceAnchorModule [

	| module |
	self denyEmpty: self model allModules.

	module := self moduleNamed: 'moduleToTestSourceAnchor'.

	self assert: module sourceAnchor isNotNil.
	self assert: module sourceText equals:('# DO NOT UPDATE THIS MODULE CONTENT THIS IS TO TEST SOURCE ANCHOR

def fibonacci(n):

    # Check if input is 0 then it will
    # print incorrect input
    if n < 0:
        print("Incorrect input")

    # Check if n is 0
    # then it will return 0
    elif n == 0:
        return 0

    # Check if n is 1,2
    # it will return 1
    elif n == 1 or n == 2:
        return 1

    else:
        return fibonacci(n - 1) + fibonacci(n - 2)


# Driver Program
print(fibonacci(9))
' copyReplaceAll: String cr with: String lf)
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testSubPackage [

	| rootPackage subPackage subSubPackage |
	self denyEmpty: self model allPackages.

	rootPackage := self packageNamed: 'root'.
	subPackage := self packageNamed: 'subpackage1'.

	self assert: subPackage class equals: FamixPythonPackage.
	self assert: subPackage name equals: 'subpackage1'.
	self deny: subPackage isRoot.
	self assert: subPackage parentPackage equals: rootPackage.

	subSubPackage := self packageNamed: 'subsubpackage1'.

	self assert: subSubPackage class equals: FamixPythonPackage.
	self assert: subSubPackage name equals: 'subsubpackage1'.
	self deny: subSubPackage isRoot.
	self assert: subSubPackage parentPackage equals: subPackage
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testSuperclass [

	| class |
	class := self classNamed: 'Student'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Student'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleAtRoot2').
	self assert: class superclass equals: (self classNamed: 'Person').
	self deny: class isStub.
	self deny: class superclass isStub
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testSuperclass2 [
	"Compared to the first test on superclasses, the order of parsing make it important that symbol resolution works in this case."

	| class |
	self assert: (self model allClasses select: [ :aClass | aClass name = 'AbstractAnimal' ]) size equals: 1.
	self assert: (self model allClasses select: [ :aClass | aClass name = 'Animal' ]) size equals: 1.
	self assert: (self model allClasses select: [ :aClass | aClass name = 'Fish' ]) size equals: 1.

	class := self classNamed: 'Animal'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Animal'.
	self assert: class typeContainer equals: (self packageNamed: 'root').
	self assert: class superclass equals: (self classNamed: 'AbstractAnimal').
	self deny: class isStub.
	self deny: class superclass isStub.

	class := self classNamed: 'Fish'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Fish'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleAtRoot2').
	self assert: class superclass equals: (self classNamed: 'Animal').
	self deny: class isStub.
	self deny: class superclass isStub
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testlocalVariableInFunctionAreDefinedOnlyOnce [
	"We should have only one global even if it is assigned multiple times."

	self assert: (self model allLocalVariables select: [ :variable | variable name = 'local_in_function3' ]) size equals: 1
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testlocalVariableInMethodAreDefinedOnlyOnce [
	"We should have only one global even if it is assigned multiple times."

	self assert: (self model allLocalVariables select: [ :variable | variable name = 'local_in_method3' ]) size equals: 1
]
