Extension { #name : 'TPyRootNodeVisitor' }

{ #category : '*Famix-Python-Importer' }
TPyRootNodeVisitor >> visitFunctionCallReceiverVariable: aFunctionCallReceiverVariable [

	^ self visitVariableExpression: aFunctionCallReceiverVariable
]

{ #category : '*Famix-Python-Importer' }
TPyRootNodeVisitor >> visitImportVariableExpression: anImportVariableExpression [

	^ self visitVariableExpression: anImportVariableExpression
]

{ #category : '*Famix-Python-Importer' }
TPyRootNodeVisitor >> visitPlaceholderVariable: aPlaceholderVariable [

	^ self visitVariableExpression: aPlaceholderVariable
]

{ #category : '*Famix-Python-Importer' }
TPyRootNodeVisitor >> visitReservedLiteral: aReservedLiteral [

	^ self visitVariableExpression: aReservedLiteral
]
