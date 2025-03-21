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

{ #category : 'tests - attributes' }
FamixPythonImporterWithClassesTest >> testAttribute [

	| class |
	class := self classNamed: 'Player'.
	self assert: class attributes size equals: 5.
	class attributes do: [ :attributes | self assert: (#( width height my_joystick image rect ) anySatisfy: [ :name | name = attributes name ]) ]
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
	self assert: cl methods first signature equals: '__init__(self, x, y, joystick_no)'
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

{ #category : 'tests' }
FamixPythonImporterWithClassesTest >> testIsModel [

	self model entityNamed: 'pygame'
	"Yes mom this is smoke test"
]

{ #category : 'tests - module' }
FamixPythonImporterWithClassesTest >> testKnowsItsModule [

	| import module |
	import := self importNamed: 'pygame'.
	module := self moduleNamed: self moduleName.
	self assert: import importingEntity equals: module
]

{ #category : 'tests - methods' }
FamixPythonImporterWithClassesTest >> testMethod [

	| mth |
	mth := (self classNamed: 'Player') methods detect: [ :m | m name = '__init__' ].
	self assert: mth class equals: FamixPythonMethod.
	self assert: mth parents anyOne name equals: 'Player'.
	self assert: mth name equals: '__init__'.
	self assert: mth signature equals: '__init__(self, x, y, joystick_no)'
]

{ #category : 'tests - methods' }
FamixPythonImporterWithClassesTest >> testMethodIsInModel [

	self assert: self model allModelMethods size equals: 5
]

{ #category : 'tests - methods' }
FamixPythonImporterWithClassesTest >> testMethodKnowsItsClass [

	| mth cl |
	mth := (self classNamed: 'Player') methods detect: [ :m | m name = '__init__' ].
	cl := self classNamed: 'Player'.
	self assert: mth parentType equals: cl.
	self assert: mth parentType class equals: FamixPythonClass
]

{ #category : 'tests - methods' }
FamixPythonImporterWithClassesTest >> testMethodWithParameter [

	| param mth |
	mth := (self classNamed: 'Player') methods detect: [ :m | m name = '__init__' ].
	param := mth parameters detect: [ :p | p name = 'y' ].

	mth := param parentBehaviouralEntity.

	self assert: mth class equals: FamixPythonMethod.

	self assert: (mth signature includesSubstring: 'y').

	self assert: param isNotNil
]

{ #category : 'tests - methods' }
FamixPythonImporterWithClassesTest >> testMethods [

	self assert: self model allModelMethods size equals: 5.
	self assert: ((self classNamed: 'Ball') methods anySatisfy: [ :method | method name = 'update' ]).
	self assert: ((self classNamed: 'Wall') methods anySatisfy: [ :method | method name = '__init__' ]).
	self assert: ((self classNamed: 'Player') methods anySatisfy: [ :method | method name = '__init__' ])
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
	self assert: module imports size equals: 2
	"does not work probably because of the bidirectional slots 
		self assert: module incomingImports size equals: 2."
]

{ #category : 'tests - parameters' }
FamixPythonImporterWithClassesTest >> testParameter [

	| param |
	param := self parameterNamed: 'joystick_no'.

	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'joystick_no'.
	self assert: param parentBehaviouralEntity equals: ((self classNamed: 'Player') methods detect: [ :m | m name = '__init__' ]).
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
	self assert: import importingEntity equals: module.
	self assert: import2 importingEntity equals: module.
	self assert: import importingEntity equals: import2 importingEntity
]
