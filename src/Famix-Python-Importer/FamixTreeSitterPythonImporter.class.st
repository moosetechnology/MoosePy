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

	"(aFileReference basename = #'modulesReferencingThings.py') ifTrue: [ 1halt ]."

	self flag: #todo. "A tool to list possible nodes, possible parents and possible children"
	FamixTSRootNodeWrapper new
		tsNode: tree rootNode;
		accept: visitor
]

{ #category : 'accessing' }
FamixTreeSitterPythonImporter >> visitorClass [

	^ FamixPythonTreeSitterVisitor
]
