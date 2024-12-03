"
I reperesent a specialization of `PyVariableExpressionNode`. A placeholder variable is the use of `_` instead of a variable to declare a variable to ignore.
"
Class {
	#name : 'FamixPythonPlaceholderVariableNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonPlaceholderVariableNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitPlaceholderVariable: self
]
