Class {
	#name : 'FamixPythonProject1TestResource',
	#superclass : 'TestResource',
	#instVars : [
		'model'
	],
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonProject1TestResource >> model [

	^ model
]

{ #category : 'running' }
FamixPythonProject1TestResource >> setUp [

	super setUp.

	model := FamixPythonImporter import: FamixPythonBridge parsingExamples / 'project1'
]

{ #category : 'running' }
FamixPythonProject1TestResource >> tearDown [

	model := nil.
	super tearDown
]
