Class {
	#name : 'FamixPythonAbstractResource',
	#superclass : 'TestResource',
	#instVars : [
		'model'
	],
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonAbstractResource >> model [

	^ model
]

{ #category : 'running' }
FamixPythonAbstractResource >> setUp [

	super setUp.

	model := FamixPythonImporter import:
		         FamixPythonBridge parsingExamples / ((self class name withoutPrefix: 'FamixPython') withoutSuffix: 'Resource') uncapitalized
]

{ #category : 'running' }
FamixPythonAbstractResource >> tearDown [

	model := nil.
	super tearDown
]
