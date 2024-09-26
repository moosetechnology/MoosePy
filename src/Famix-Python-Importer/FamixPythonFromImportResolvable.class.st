Class {
	#name : 'FamixPythonFromImportResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'path',
		'entityName',
		'entity'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'accessing' }
FamixPythonFromImportResolvable class >> path: aStringPath entityName: anEntityName [

	^ self new
		  path: aStringPath;
		  entityName: anEntityName;
		  yourself
]

{ #category : 'hooks' }
FamixPythonFromImportResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [

	self entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> entity [
	^ entity
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> entityName: anObject [
	entityName := anObject
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> identifier [
	^ self path
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> path [
	^ path
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> path: anObject [
	path := anObject
]

{ #category : 'resolution' }
FamixPythonFromImportResolvable >> resolveAbsolutePathFor: currentEntity [

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
	possibleEntities ifEmpty: [ NotFound signal ].
	
	possibleEntities size = 1 ifFalse: [ self error: 'There should be only one possible entity to import.' ].
	
	possibleEntities := possibleEntities anyOne allChildren select: [ :child | child isNamedEntity and: [ child name = entityName ] ].
	"It is possible that we have multiple entities with the same name and in that case, python select the last one declared. So we sort by source anchor position to find this one."
	^ possibleEntities detectMax: [ :possibleEntity | possibleEntity sourceAnchor startPos ]
]

{ #category : 'resolution' }
FamixPythonFromImportResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"If we have a dot at first, we have a relative path. Else it's an absolute path"

	entity := (path beginsWith: '.')
		          ifTrue: [ 1 halt ]
		          ifFalse: [ self resolveAbsolutePathFor: currentEntity ]
]
