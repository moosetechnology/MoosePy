Extension { #name : #PyExprStmtNode }

{ #category : #'*MoosePy' }
PyExprStmtNode >> isAssignment [

	^self assigns isNotEmpty
]
