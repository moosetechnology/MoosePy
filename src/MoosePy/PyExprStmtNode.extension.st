Extension { #name : #PyExprStmtNode }

{ #category : #'*MoosePy' }
PyExprStmtNode >> isAssignment [

	^self assigns isNotEmpty
]

{ #category : #'*MoosePy' }
PyExprStmtNode >> isLambda [
	"Checks if this statement node is a lambda."

	^self testlist lambdaToken isNotNil
]
