Extension { #name : 'PyFieldAccessExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isInstanceVariableAssignation [

	self parent
		ifNil: [ ^ false ]
		ifNotNil: [ :node | (node isLeftSideOfAssignation: self) ifFalse: [ ^ false ] ].

	^ self receiver isSelf
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isSelf [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> name [
	^ self nameToken value
]
