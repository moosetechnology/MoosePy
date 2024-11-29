Extension { #name : 'PyVariableExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isInImport [

	^ self parent isImport
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isLeftSideOfAssignation [

	^ self parent
		  ifNil: [ false ]
		  ifNotNil: [ :node | node isLeftSideOfAssignation: self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isReceiverOfFunctionCall [

	^ self parent isFunctionCallExpression and: [ self parent receiver = self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isReservedLiteral [

	^ #( True False None NotImplemented Ellipsis __debug__ ) includes: self name
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isSelf [

	^ self name = #self
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> name [

	^ self nameToken value
]
