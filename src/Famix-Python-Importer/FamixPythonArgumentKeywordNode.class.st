"
I reperesent a specialization of `PyVariableExpressionNode`. I am a keyword when we give parameters to an invocation.
"
Class {
	#name : 'FamixPythonArgumentKeywordNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonArgumentKeywordNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitArgumentKeyword: self
]
