Extension { #name : 'FamixPythonEntity' }

{ #category : '*Famix-Python-Importer' }
FamixPythonEntity >> canHaveImports [

	^ false
]

{ #category : '*Famix-Python-Importer' }
FamixPythonEntity >> reachableEntitiesNamed: aString ofKinds: aCollection [

	| entities |
	entities := Set new.

	self canHaveImports ifTrue: [
			self imports do: [ :import | "It is possible for the imported entity to be nil in case it was not yet resolved.
		Imagine you reference something and later in the file there is an import. We resolve things in the order they appear, so the import might not yet be resolved. But in that case we can just ignore it."
					import importedEntity ifNotNil: [ :entity | "In case the import has an alias, we add the imported entity. "
							import alias = aString
								ifTrue: [ entities add: import importedEntity ]
								ifFalse: [ entities addAll: (entity definedEntitiesNamed: aString ofKinds: aCollection) ] ] ] ].

	entities addAll: (self definedEntitiesNamed: aString ofKinds: aCollection).

	^ entities
]
