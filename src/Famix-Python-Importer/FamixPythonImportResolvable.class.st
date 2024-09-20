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
FamixPythonImportResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"If we have a dot at first, we have a relative path. Else it's an absolute path"

	(path beginsWith: '.')
		ifTrue: [ 1 halt ]
		ifFalse: [
			| rootEntities splittedPath |
			rootEntities := currentEntity mooseModel rootEntities.
			splittedPath := path splitOn: $..
			splittedPath size > 1 ifTrue: [ 1 halt ].
			entity := rootEntities detect: [ :entity | entity name = splittedPath first ] ]
]
