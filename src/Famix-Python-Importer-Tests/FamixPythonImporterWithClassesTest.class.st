Class {
	#name : 'FamixPythonImporterWithClassesTest',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonImporterWithClassesTest class >> resources [
	^ { FamixPythonWithClassesTestResource }
]

{ #category : 'accessing' }
FamixPythonImporterWithClassesTest >> model [
	^ FamixPythonWithClassesTestResource current model
]

{ #category : 'tests' }
FamixPythonImporterWithClassesTest >> testClass [

	| ballClass wallClass |
	ballClass := self classNamed: 'Ball'.
	self assert: ballClass class equals: FamixPythonClass.
	self assert: ballClass name equals: 'Ball'.
	self deny: ballClass isStub.

	wallClass := self classNamed: 'Wall'.
	self assert: wallClass name equals: 'Wall'.
	self deny: wallClass isStub
]

{ #category : 'tests - classes' }
FamixPythonImporterWithClassesTest >> testClassKnowsItsMethods [

	| cl |
	cl := self classNamed: 'Player'.
	self assert: cl methods first name equals: '__init__'.
	self assert: cl methods first signature equals: 'self, x, y, joystick_no'
]

{ #category : 'tests - classes' }
FamixPythonImporterWithClassesTest >> testClassSuperclass [

	| class |
	class := self classNamed: 'Player'.
	self assert: class class equals: FamixPythonClass.
	self assert: class superclass isNotNil.
	self assert: class superclass name equals: 'Sprite'
]

{ #category : 'tests - classes' }
FamixPythonImporterWithClassesTest >> testClasses [

	self assert: self model allClasses size equals: 4.
	self assert: (self classNamed: 'Ball') isNotNil.
	self assert: (self classNamed: 'Player') isNotNil
]

{ #category : 'tests - module' }
FamixPythonImporterWithClassesTest >> testKnowsItsModule [

	| import module |
	import := self importNamed: 'pygame'.
	module := self moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module
]

{ #category : 'tests - module' }
FamixPythonImporterWithClassesTest >> testModule [

	| module |
	module := self moduleNamed: self moduleName.

	self assert: module isNotNil.
	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: self moduleName
]

{ #category : 'tests - module' }
FamixPythonImporterWithClassesTest >> testModuleKnowsItsImport [

	| module |
	module := self moduleNamed: self moduleName.
	self assert: module manualIncomingImports size equals: 2
	"does not work probably because of the bidirectional slots 
		self assert: module incomingImports size equals: 2."
]

{ #category : 'tests - classes' }
FamixPythonImporterWithClassesTest >> testRightNumberOfClasses [

	self assert: self model numberOfClasses equals: 4
]

{ #category : 'tests - module' }
FamixPythonImporterWithClassesTest >> testTwoSiblingImportsHaveTheSameModule [

	| import module import2 |
	import := self importNamed: 'pygame'.
	import2 := self importNamed: 'random'.
	module := self moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module.
	self assert: import2 manualImportingEntity equals: module.
	self assert: import manualImportingEntity equals: import2 manualImportingEntity
]
