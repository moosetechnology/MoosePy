"
I reperesent a specialization of `PyFieldAccessExpressionNode`. I represent a path in an import.
"
Class {
	#name : 'FamixPythonImportPathNode',
	#superclass : 'PyFieldAccessExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonImportPathNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitImportPath: self
]
