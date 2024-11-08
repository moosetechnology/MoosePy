Extension { #name : 'PyLambdaExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyLambdaExpressionNode >> signatureString [

	^ self parameters
		ifEmpty: [ '' ]
		ifNotEmpty: [ :params | (self completeSource copyFrom: params first startPosition to: params last stopPosition) asString ]
]
