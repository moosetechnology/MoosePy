Class {
	#name : 'FamixPythonImportResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'path',
		'entity'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'accessing' }
FamixPythonImportResolvable class >> path: aStringPath [

	^ self new
		  path: aStringPath;
		  yourself
]

{ #category : 'hooks' }
FamixPythonImportResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [

	self entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
FamixPythonImportResolvable >> entity [
	^ entity
]

{ #category : 'accessing' }
FamixPythonImportResolvable >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
FamixPythonImportResolvable >> identifier [
	^ self path
]

{ #category : 'accessing' }
FamixPythonImportResolvable >> path [
	^ path
]

{ #category : 'accessing' }
FamixPythonImportResolvable >> path: anObject [
	path := anObject
]

{ #category : 'resolution' }
FamixPythonImportResolvable >> resolveAbsolutePathFor: currentEntity [

	| possibleEntities splittedPath |
	possibleEntities := currentEntity mooseModel rootEntities.
	splittedPath := path splitOn: $..
	possibleEntities := possibleEntities select: [ :possibleEntity | possibleEntity name = splittedPath first ].
	splittedPath removeFirst.
	[ splittedPath isNotEmpty ] whileTrue: [
		| childName |
		childName := splittedPath anyOne.
		splittedPath removeFirst.
		possibleEntities := possibleEntities flatCollect: [ :possibleEntity |
			                    possibleEntity children select: [ :child | (child isPackage or: [ child isModule ]) and: [ child name = childName ] ] ] ].
	possibleEntities size = 1 ifFalse: [ self error: 'There should be only one possible entity to import.' ].
	^ possibleEntities anyOne
]

{ #category : 'resolution' }
FamixPythonImportResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"If we have a dot at first, we have a relative path. Else it's an absolute path"

	entity := (path beginsWith: '.')
		          ifTrue: [ 1 halt ]
		          ifFalse: [ self resolveAbsolutePathFor: currentEntity ]
]
