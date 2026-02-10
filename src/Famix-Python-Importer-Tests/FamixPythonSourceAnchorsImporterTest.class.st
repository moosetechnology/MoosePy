Class {
	#name : 'FamixPythonSourceAnchorsImporterTest',
	#superclass : 'FamixPythonAbstractSnippetImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'tests' }
FamixPythonSourceAnchorsImporterTest >> testTinyModule [

	| module |
	self import: 'print(1 + 1)'.

	self assert: model allModules size equals: 1.
	module := model allModules anyOne.
	self assert: module sourceText equals: 'print(1 + 1)'.
	self assert: module sourceAnchor startByte equals: 1.
	self assert: module sourceAnchor endByte equals: 12.
	self assert: module sourceAnchor startPos equals: 1.
	self assert: module sourceAnchor endPos equals: 12
]
