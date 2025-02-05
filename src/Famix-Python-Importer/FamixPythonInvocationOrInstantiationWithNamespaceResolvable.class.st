Class {
	#name : 'FamixPythonInvocationOrInstantiationWithNamespaceResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#instVars : [
		'import'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonInvocationOrInstantiationWithNamespaceResolvable class >> identifier: aString import: anImport [

	^ (self identifier: aString)
		  import: anImport;
		  yourself
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationWithNamespaceResolvable >> import: anObject [
	import := anObject
]

{ #category : 'resolution' }
FamixPythonInvocationOrInstantiationWithNamespaceResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	import importedEntity name = identifier ifTrue: [ ^ self entity: import importedEntity ].

	^ (import importedEntity definedEntitiesNamed: identifier ofKinds: self expectedKinds) ifEmpty: [ SRNoResolutionPossible signal ] ifNotEmpty: [ :entities |
		  | matchingEntities |
		  self flag: #todo. "This could probably be simplified? Or at least remove duplication with sibling classes.."
		  matchingEntities := entities sorted: [ :anEntity | anEntity sourceAnchor startPos ] ascending.
		  (matchingEntities collectAsSet: #class) size = 1
			  ifTrue: [ "This is an instantiation"
				  matchingEntities last isClass ifTrue: [ ^ self entity: matchingEntities last ].

				  self entity: matchingEntities ]
			  ifFalse: [
				  self entity: (matchingEntities last isClass
						   ifTrue: [ matchingEntities last ]
						   ifFalse: [ { matchingEntities last } ]) ] ]
]
