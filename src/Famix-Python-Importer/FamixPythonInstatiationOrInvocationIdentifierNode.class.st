"
I reperesent a specialization of `PyVariableExpressionNode`.

If we have an invocation or instantiation such as `print(3)` or `AClass()`, then I represent the identifier `print` or `AClass`.""
"
Class {
	#name : 'FamixPythonInstatiationOrInvocationIdentifierNode',
	#superclass : 'PyVariableExpressionNode',
	#category : 'Famix-Python-Importer-Nodes',
	#package : 'Famix-Python-Importer',
	#tag : 'Nodes'
}

{ #category : 'generated' }
FamixPythonInstatiationOrInvocationIdentifierNode >> acceptVisitor: aRootVisitor [

	^ aRootVisitor visitInstantiationOrInvocationIdentifier: self
]

{ #category : 'testing' }
FamixPythonInstatiationOrInvocationIdentifierNode >> hasReceiver [

	^ false
]
