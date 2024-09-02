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
FamixPythonImporterWithClassesTest >> classNamed: aName [

	^ self model allClasses detect: [ :class | class name = aName ]
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

{ #category : 'tests - classes' }
FamixPythonImporterWithClassesTest >> testRightNumberOfClasses [

	self assert: self model numberOfClasses equals: 4
]
