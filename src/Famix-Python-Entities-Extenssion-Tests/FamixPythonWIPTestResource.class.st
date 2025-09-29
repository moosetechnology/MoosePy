Class {
	#name : 'FamixPythonWIPTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'model'
	],
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'accessing' }
FamixPythonWIPTestResource >> model [

	^ model
]

{ #category : 'running' }
FamixPythonWIPTestResource >> setUp [

	super setUp.
	model := FamixPythonImporter import: FamixPythonBridge parsingExamples / 'marius/test.py'
]

{ #category : 'running' }
FamixPythonWIPTestResource >> tearDown [

	model := nil.
	super tearDown
]
