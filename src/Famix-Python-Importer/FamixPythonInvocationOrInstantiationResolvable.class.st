Class {
	#name : 'FamixPythonInvocationOrInstantiationResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'resolution' }
FamixPythonInvocationOrInstantiationResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	| matchingEntities |
	(self expectedKinds anySatisfy: [ :expectedPossibility | aScope canContainsEntitiesOfType: expectedPossibility ]) ifFalse: [ NotFound signal ].

	matchingEntities := (aScope reachableEntitiesNamed: self identifier ofKinds: self expectedKinds) ifEmpty: [ NotFound signal ].

	matchingEntities := matchingEntities sorted: [ :anEntity | anEntity sourceAnchor startPos ] ascending.
	(matchingEntities collectAsSet: #class) size = 1
		ifTrue: [ "This is an instantiation"
			matchingEntities last isClass ifTrue: [ ^ self entity: matchingEntities last ].

			^ self entity: matchingEntities ]
		ifFalse: [
			^ self entity: (matchingEntities last isClass
					   ifTrue: [ matchingEntities last ]
					   ifFalse: [ { matchingEntities last } ]) ]
]
