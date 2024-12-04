"
I reperesent a specialization of `PyFieldAccessExpressionNode`. I am an instance variable that is getting assigned.
"
Class {
	#name : 'FamixPythonAssignedInstanceVariableNode',
	#superclass : 'PyFieldAccessExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonAssignedInstanceVariableNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitAssignedInstanceVariable: self
]
