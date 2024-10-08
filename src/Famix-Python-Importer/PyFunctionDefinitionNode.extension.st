Extension { #name : 'PyFunctionDefinitionNode' }

{ #category : '*Famix-Python-Importer' }
PyFunctionDefinitionNode >> name [

	^ self fname value
]

{ #category : '*Famix-Python-Importer' }
PyFunctionDefinitionNode >> signatureString [

	^ parameters ifEmpty: [ '' ] ifNotEmpty: [ self sourceFrom: parameters first startPosition to: parameters last stopPosition ]
]
