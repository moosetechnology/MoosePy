"
I reperesent a specialization of `PyVariableExpressionNode`. I am a variable that is getting assigned.
"
Class {
	#name : 'FamixPythonAssignedVariableNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonAssignedVariableNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitAssignedVariable: self
]
