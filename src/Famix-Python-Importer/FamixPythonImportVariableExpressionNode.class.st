"
I reperesent a specialization of `PyVariableExpressionNode`. I represent what needs to be imported, or in the case we have a path for the import, I represent the receiver (first element) of this path
"
Class {
	#name : 'FamixPythonImportVariableExpressionNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonImportVariableExpressionNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitImportVariableExpression: self
]
