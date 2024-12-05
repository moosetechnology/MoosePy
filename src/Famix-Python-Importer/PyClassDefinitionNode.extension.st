Extension { #name : 'PyClassDefinitionNode' }

{ #category : '*Famix-Python-Importer' }
PyClassDefinitionNode >> isClassDefinition [

	^ true
]

{ #category : '*Famix-Python-Importer' }
PyClassDefinitionNode >> pythonClassName [

	^ self cname value
]
