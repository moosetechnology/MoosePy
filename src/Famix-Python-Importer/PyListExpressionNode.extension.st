Extension { #name : 'PyListExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyListExpressionNode >> isLeftSideOfAssignation: aNode [

	^ self parent
		  ifNil: [ false ]
		  ifNotNil: [ :node | node isLeftSideOfAssignation: self ]
]
