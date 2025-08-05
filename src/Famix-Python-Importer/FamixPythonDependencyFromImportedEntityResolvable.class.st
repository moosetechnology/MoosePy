Class {
	#name : 'FamixPythonDependencyFromImportedEntityResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#instVars : [
		'import'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonDependencyFromImportedEntityResolvable class >> identifier: aString import: anImport [

	^ (self identifier: aString)
		  import: anImport;
		  yourself
]

{ #category : 'accessing' }
FamixPythonDependencyFromImportedEntityResolvable >> import [
	^ import
]

{ #category : 'accessing' }
FamixPythonDependencyFromImportedEntityResolvable >> import: anObject [
	import := anObject
]

{ #category : 'resolution' }
FamixPythonDependencyFromImportedEntityResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	(self import importedEntity definedEntitiesNamed: identifier ofKinds: {
			 FamixPythonFunction.
			 FamixPythonClass }) ifEmpty: [ SRNoResolutionPossible signal ] ifNotEmpty: [ :entities |
			| matchingEntities |
			self flag: #todo. "This could probably be simplified? Or at least remove duplication with sibling classes.."
			self flag: #todo. "Do we need the sorting? If no update also the other resolvable with this code."
			matchingEntities := entities sorted: [ :anEntity | anEntity sourceAnchor startPos ] ascending.
			(matchingEntities collectAsSet: #class) size = 1
				ifTrue: [ "This is an instantiation"
						matchingEntities last isClass ifTrue: [ ^ self result: matchingEntities last ].

						self result: matchingEntities ]
				ifFalse: [
						self result: (matchingEntities last isClass
								 ifTrue: [ matchingEntities last ]
								 ifFalse: [ { matchingEntities last } ]) ] ]
]
