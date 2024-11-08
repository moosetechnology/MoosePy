Extension { #name : 'PyFieldAccessExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> isSelf [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyFieldAccessExpressionNode >> name [
	^ self nameToken value
]
