Extension { #name : 'PySubscriptExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PySubscriptExpressionNode >> isLeftSideOfAssignation: aNode [

	^ self parent
		  ifNil: [ false ]
		  ifNotNil: [ :node | node isLeftSideOfAssignation: self ]
]

{ #category : '*Famix-Python-Importer' }
PySubscriptExpressionNode >> isSubscriptExpression [

	^ true
]
