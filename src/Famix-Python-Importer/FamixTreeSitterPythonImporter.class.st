Class {
	#name : 'FamixTreeSitterPythonImporter',
	#superclass : 'FamixPythonImporter',
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'api' }
FamixTreeSitterPythonImporter >> importPythonFile: aFileReference [

	| parser tree |
	('Importing ' , aFileReference pathString) traceCr.
	"(aFileReference basename = #'moduleAtRoot11.py') ifTrue: [ 1halt ]."

	parser := TSParser new.
	parser language: TSLanguage python.
	visitor fileReference: aFileReference.
	tree := parser parseString: visitor sourceText.
	tree rootNode accept: visitor
]

{ #category : 'accessing' }
FamixTreeSitterPythonImporter >> visitorClass [

	^ FamixPythonTreeSitterVisitor
]
