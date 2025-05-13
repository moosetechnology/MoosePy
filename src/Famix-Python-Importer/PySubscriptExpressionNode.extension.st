Extension { #name : 'PySubscriptExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PySubscriptExpressionNode >> isLeftSideOfAssignation: aNode [

	^ self parent
		  ifNil: [ false ]
		  ifNotNil: [ :node | "If we are in the table, we do not consider it as a variable at the left side of the assignation."
			  aNode = self receiver and: [ node isLeftSideOfAssignation: self ] ]
]

{ #category : '*Famix-Python-Importer' }
PySubscriptExpressionNode >> isSubscriptExpression [

	^ true
]
