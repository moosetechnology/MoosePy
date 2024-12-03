"
I reperesent a specialization of `PyVariableExpressionNode`. I am used when the variable is the receiver of a function call.
"
Class {
	#name : 'FamixPythonFunctionCallReceiverVariableNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonFunctionCallReceiverVariableNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitFunctionCallReceiverVariable: self
]
