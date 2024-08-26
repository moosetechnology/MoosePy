Extension { #name : 'PyExprStmtNode' }

{ #category : '*Famix-Python-Importer' }
PyExprStmtNode >> isAssignment [

	^self assigns isNotEmpty
]

{ #category : '*Famix-Python-Importer' }
PyExprStmtNode >> isLambda [
	"Checks if this statement node is a lambda."

	^ (self testlist respondsTo: #lambdaToken)
		  ifTrue: [ self testlist lambdaToken isNotNil ]
		  ifFalse: [ false ]
]
