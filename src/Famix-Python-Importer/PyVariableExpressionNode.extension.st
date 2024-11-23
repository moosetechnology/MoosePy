Extension { #name : 'PyVariableExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isLeftSideOfAssignation [

	^ self parent
		  ifNil: [ false ]
		  ifNotNil: [ :node | node isLeftSideOfAssignation: self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isSelf [

	^ self name = #self
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> name [

	^ self nameToken value
]
