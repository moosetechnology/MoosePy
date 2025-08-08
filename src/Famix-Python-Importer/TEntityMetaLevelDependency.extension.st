Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*Famix-Python-Importer' }
TEntityMetaLevelDependency >> allEffectiveImports [
	"Return all the imports effective in this entity."

	^ self withAllParents flatCollect: [ :entity | entity query outgoing local dependenciesOfType: FamixPythonImport ]
]

{ #category : '*Famix-Python-Importer' }
TEntityMetaLevelDependency >> allEffectiveSimpleImports [
	"Return all the imports effective in this entity, but not from imponts."

	^ self allEffectiveImports reject: #isFromImport
]
