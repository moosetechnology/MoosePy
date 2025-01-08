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
FamixPythonImporterWithFunctionsTest >> model [
	^ FamixPythonWithFunctionsTestResource current model
]

{ #category : 'tests - functions' }
FamixPythonImporterWithFunctionsTest >> testFunction [

	| func |
	func := self functionNamed: 'tryToPlaceWord'.
	self assert: func class equals: FamixPythonFunction.
	self assert: func signature equals: 'tryToPlaceWord(grid,word)'
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

{ #category : 'tests - functions' }
FamixPythonImporterWithFunctionsTest >> testFunctions [

	self assert: (self model allFunctions reject: #isStub) size equals: 4.

	self assert: (self functionNamed: 'tryToPlaceWord') isNotNil.
	self assert: (self functionNamed: 'printGrid') isNotNil
]

{ #category : 'tests - parameters' }
FamixPythonImporterWithFunctionsTest >> testParameter [

	| param |
	param := (self functionNamed: 'tryToPlaceWord') parameters detect: [ :p | p name = 'word' ].
	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'word'.
	self assert: param parentBehaviouralEntity equals: (self functionNamed: 'tryToPlaceWord')
]
