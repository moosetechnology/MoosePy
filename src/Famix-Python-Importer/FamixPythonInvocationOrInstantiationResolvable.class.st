Class {
	#name : 'FamixPythonInvocationOrInstantiationResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'identifier',
		'entity'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationResolvable class >> identifier: anIdentifierString [

	^ self new
		  identifier: anIdentifierString;
		  yourself
]

{ #category : 'hooks' }
FamixPythonInvocationOrInstantiationResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [

	self entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationResolvable >> entity [

	^ entity
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationResolvable >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationResolvable >> identifier: anObject [

	identifier := anObject
]

{ #category : 'resolution' }
FamixPythonInvocationOrInstantiationResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	| matchingEntities |
	(self expectedKinds anySatisfy: [ :expectedPossibility | aScope canContainsEntitiesOfType: expectedPossibility ]) ifFalse: [ NotFound signal ].

	matchingEntities := (aScope reachableEntitiesNamed: self identifier ofKinds: self expectedKinds) ifEmpty: [ NotFound signal ].

	matchingEntities := matchingEntities sorted: [ :entity | entity sourceAnchor startPos ] ascending.
	(matchingEntities collectAsSet: #class) size = 1
		ifTrue: [ "This is an instantiation"
			matchingEntities last isClass ifTrue: [ ^ self entity: matchingEntities last ].

			^ self entity: matchingEntities ]
		ifFalse: [
			^ self entity: (matchingEntities last isClass
					   ifTrue: [ matchingEntities last ]
					   ifFalse: [ { matchingEntities last } ]) ]
]
