"
I reperesent a specialization of `PyFieldAccessExpressionNode`. I represent a read access to an instance variable inside its class declaration with `self` as receiver.
"
Class {
	#name : 'FamixPythonInternalInstanceVariableAccessNode',
	#superclass : 'PyFieldAccessExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonInternalInstanceVariableAccessNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitInternalInstanceVariableAccess: self
]
