Class {
	#name : 'FamixPythonLocalFunctionTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'model'
	],
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'accessing' }
FamixPythonLocalFunctionTestResource >> model [

	^ model
]

{ #category : 'running' }
FamixPythonLocalFunctionTestResource >> setUp [

	super setUp.
	model := FamixPythonImporter import: FamixPythonBridge parsingExamples / 'marius/local_func.py'
]

{ #category : 'running' }
FamixPythonLocalFunctionTestResource >> tearDown [

	model := nil.
	super tearDown
]
