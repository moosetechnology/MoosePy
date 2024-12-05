"
I reperesent a specialization of `PyVariableExpressionNode`. I am a superclass declaration.
"
Class {
	#name : 'FamixPythonSuperclassNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonSuperclassNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitSuperclass: self
]
