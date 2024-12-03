"
I am a specialization of a `PyVariableExpressionNode`. I represent a reserved literal node of Python such as True, False, None...
"
Class {
	#name : 'FamixPythonReservedLiteralNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonReservedLiteralNode >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReservedLiteral: self
]
