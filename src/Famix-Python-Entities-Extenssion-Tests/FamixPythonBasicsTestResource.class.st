Class {
	#name : 'FamixPythonBasicsTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'model'
	],
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'accessing' }
FamixPythonBasicsTestResource >> model [

	^ model
]

{ #category : 'running' }
FamixPythonBasicsTestResource >> setUp [

	super setUp.
	model := FamixPythonImporter import: FamixPythonBridge parsingExamples / 'marius/basics.py'
]

{ #category : 'running' }
FamixPythonBasicsTestResource >> tearDown [

	model := nil.
	super tearDown
]
