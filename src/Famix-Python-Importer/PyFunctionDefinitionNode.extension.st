Extension { #name : 'PyFunctionDefinitionNode' }

{ #category : '*Famix-Python-Importer' }
PyFunctionDefinitionNode >> name [

	^ self fname value
]

{ #category : '*Famix-Python-Importer' }
PyFunctionDefinitionNode >> signatureString [

	^ (self completeSource copyFrom: self fname startPosition to: self rparenToken stopPosition) asString
]
