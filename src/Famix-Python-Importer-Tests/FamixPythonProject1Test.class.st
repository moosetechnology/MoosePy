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

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testClassImportsModule [

	| class import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Person'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3')
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testFunctionImportsModule [

	| function import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImport'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3')
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
	self assert: import importedEntity equals: (self packageNamed: 'root2')
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testMethodImportsModule [

	| method import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'printInfos'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot4' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot4')
]

{ #category : 'tests' }
FamixPythonProject1Test >> testModel [

	self assert: self model isNotEmpty.
	self assert: self model name equals: 'project1'.
	self assert: self model rootFolder equals: FamixPythonBridge parsingExamples / 'project1'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsModuleInPackage [

	| importingModule importedModule import |
	self denyEmpty: self model allImports.
	importingModule := self moduleNamed: 'moduleInRootPackage2'.
	importedModule := self moduleNamed: 'moduleInSubPackage1'.
	import := importingModule outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubPackage1' ].

	self assert: import importingEntity equals: importingModule.
	self assert: import importedEntity equals: importedModule
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

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testPackageSourceAnchor [

	| rootPackage |
	self denyEmpty: self model allPackages.

	rootPackage := self packageNamed: 'root'.

	self assert: rootPackage sourceAnchor mooseModel equals: self model.
	self assert: rootPackage sourceAnchor sourceText equals: (FamixPythonBridge parsingExamples / 'project1' / 'root' / '__init__.py') contents
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

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testRootModuleImportsRootModule [

	| rootModule1 rootModule2 import |
	self denyEmpty: self model allImports.
	rootModule1 := self moduleNamed: 'moduleAtRoot'.
	rootModule2 := self moduleNamed: 'moduleAtRoot2'.
	import := rootModule2 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: rootModule2.
	self assert: import importedEntity equals: rootModule1
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testRootModuleImportsRootPackage [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'root' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'root')
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testRootModuleImportsSubPackage [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'subpackage1' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'subpackage1')
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

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testRootPackageImportsRootModule [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3')
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testRootPackageImportsRootPackage [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'root' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self packageNamed: 'root')
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testRootPackageImportsSubSubPackage [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self packageNamed: 'subsubpackage1')
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

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testSimpleFunction [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'functionWithImport'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'functionWithImport'.
	self assert: function signature equals: ''.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testSimpleMethod [

	| method |
	self denyEmpty: self model allMethods.

	method := self methodNamed: 'printInfos'.

	self assert: method class equals: FamixPythonMethod.
	self assert: method name equals: 'printInfos'.
	self assert: method signature equals: 'self'.
	self assert: method parentType equals: (self classNamed: 'Person')
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
