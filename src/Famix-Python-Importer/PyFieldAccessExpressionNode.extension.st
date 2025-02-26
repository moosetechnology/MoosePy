Extension { #name : 'PyFieldAccessExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> hasReceiver [

	^ self receiver isNotNil
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isInstanceVariableAssignation [

	self parent
		ifNil: [ ^ false ]
		ifNotNil: [ :node | (node isLeftSideOfAssignation: self) ifFalse: [ ^ false ] ].

	^ self receiver isSelf
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isInstantiationOrInvocationWithReceiver: aPyVariableExpressionNode [

	^ self parent isNotNil and: [ self parent isFunctionCallExpression and: [ self receiver = aPyVariableExpressionNode ] ]
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isInternalInstanceVariableAccess [

	(self parent isFunctionCallExpression and: [ self parent receiver = self ]) ifTrue: [ "In that case we are in a method invocation" ^ false ].
	^ self receiver isSelf
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isReceiverOfFunctionCall [

	^ self parent isFunctionCallExpression and: [ self parent receiver = self ]
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> name [
	^ self nameToken value
]
