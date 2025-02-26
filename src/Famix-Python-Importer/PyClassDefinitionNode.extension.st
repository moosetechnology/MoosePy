Extension { #name : 'PyClassDefinitionNode' }

{ #category : '*Famix-Python-Importer' }
PyClassDefinitionNode >> isClassDefinition [

	^ true
]

{ #category : '*Famix-Python-Importer' }
PyClassDefinitionNode >> isMetaclass [
	"A metaclass is a class inheriting from type"

	^ self superClasses anySatisfy: [ :superclass | superclass name = 'type' ]
]

{ #category : '*Famix-Python-Importer' }
PyClassDefinitionNode >> pythonClassName [

	^ self cname value
]
