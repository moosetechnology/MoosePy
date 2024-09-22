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

{ #category : 'tests' }
FamixPythonProject1Test >> testModel [

	self assert: self model isNotEmpty.
	self assert: self model name equals: 'project1'.
	self assert: self model rootFolder equals: FamixPythonBridge parsingExamples / 'project1'
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
	rootPackage := self packageNamed: 'root'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot')
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
