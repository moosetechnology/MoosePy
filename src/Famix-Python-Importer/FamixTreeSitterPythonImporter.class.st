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

	parser := TSParser new.
	parser language: TSLanguage python.
	visitor fileReference: aFileReference.
	tree := parser parseString: visitor sourceText.
	
	"(aFileReference basename = #'moduleInRootPackage2.py') ifTrue: [ 1halt ]."
	
	FamixPythonTSRootNodeWrapper new
		tsNode: tree rootNode;
		source: visitor sourceText;
		accept: visitor
]

{ #category : 'accessing' }
FamixTreeSitterPythonImporter >> visitorClass [

	^ FamixPythonTreeSitterVisitor
]
