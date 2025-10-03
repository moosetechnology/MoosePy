Class {
	#name : 'FamixPythonAbstractImportResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'path'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'testing' }
FamixPythonAbstractImportResolvable class >> isAbstract [

	^ self = FamixPythonAbstractImportResolvable
]

{ #category : 'resolution' }
FamixPythonAbstractImportResolvable >> findTargetEntityFor: aPath from: startEntities [

	| possibleEntities splittedPath |
	"We need to trim because we can have spaces between the dots."
	splittedPath := (aPath splitOn: $.) collect: [ :segment | segment trim ].
	possibleEntities := startEntities select: [ :possibleEntity | possibleEntity name = splittedPath first and: [ possibleEntity isStub not ] ].
	splittedPath removeFirst.
	[ splittedPath isNotEmpty ] whileTrue: [
			| childName |
			childName := splittedPath anyOne.
			splittedPath removeFirst.
			possibleEntities := possibleEntities flatCollect: [ :possibleEntity |
				                    possibleEntity containedEntities select: [ :child | (child isPackage or: [ child isModule ]) and: [ child name = childName ] ] ] ].
	possibleEntities ifEmpty: [ SRNoResolutionPossible signal ].

	possibleEntities size = 1 ifFalse: [ self error: 'There should be only one possible entity to import.' ].

	^ possibleEntities anyOne
]

{ #category : 'accessing' }
FamixPythonAbstractImportResolvable >> identifier [
	^ self path
]

{ #category : 'accessing' }
FamixPythonAbstractImportResolvable >> path [
	^ path
]

{ #category : 'accessing' }
FamixPythonAbstractImportResolvable >> path: anObject [
	path := anObject
]
