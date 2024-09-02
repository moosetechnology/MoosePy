Class {
	#name : 'FamixPythonImporterWithFunctionsTest',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonImporterWithFunctionsTest class >> resources [
	^ { FamixPythonWithFunctionsTestResource }
]

{ #category : 'accessing' }
FamixPythonImporterWithFunctionsTest >> functionNamed: aName [

	^ self model allFunctions detect: [ :function | function name = aName ]
]

{ #category : 'accessing' }
FamixPythonImporterWithFunctionsTest >> model [
	^ FamixPythonWithFunctionsTestResource current model
]

{ #category : 'accessing' }
FamixPythonImporterWithFunctionsTest >> moduleNamed: aName [

	^ self model allModules detect: [ :module | module name = aName ]
]

{ #category : 'tests - functions' }
FamixPythonImporterWithFunctionsTest >> testFunction [

	| func |
	func := self functionNamed: 'tryToPlaceWord'.
	self assert: func class equals: FamixPythonFunction.
	self assert: func signature equals: 'grid,word'
]

{ #category : 'tests - functions' }
FamixPythonImporterWithFunctionsTest >> testFunctionKnowsItsModule [

	| func module |
	func := self functionNamed: 'tryToPlaceWord'.
	module := self moduleNamed: 'sprite_collect_blocks'.
	self assert: func functionOwner equals: module.
	self assert: func functionOwner class equals: FamixPythonModule
]

{ #category : 'tests - functions' }
FamixPythonImporterWithFunctionsTest >> testFunctionWithParameter [

	| param func |
	param := (self functionNamed: 'tryToPlaceWord') parameters detect: [ :parameter | parameter name = 'word' ].
	func := param parentBehaviouralEntity.

	self assert: func class equals: FamixPythonFunction.
	self assert: (func signature includesSubstring: 'word') equals: true.

	self assert: param isNotNil
]
