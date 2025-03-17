Class {
	#name : 'FamixPythonFromImportResolvable',
	#superclass : 'FamixPythonAbstractImportResolvable',
	#instVars : [
		'entityName'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'accessing' }
FamixPythonFromImportResolvable class >> path: aStringPath entityName: anEntityName [

	^ self new
		  path: aStringPath;
		  entityName: anEntityName;
		  yourself
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> entityName [
	^ entityName
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> entityName: anObject [
	entityName := anObject
]

{ #category : 'accessing' }
FamixPythonFromImportResolvable >> identifier [

	^ super identifier , ' -> ' , self entityName
]

{ #category : 'resolution' }
FamixPythonFromImportResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"If we have a dot at first, we have a relative path. Else it's an absolute path"

	| possibleEntities remainingPath targetModule |
	(path beginsWith: '.')
		ifTrue: [
			| currentPackage |
			"In case of a relative path we need to find the origin package for the resolution"
			remainingPath := path allButFirst.
			currentPackage := (currentEntity query ancestors ofType: FamixTPackage) anyOne. "If we have a module, we need to start with its parent package. If we have a package, it starts in itself."
			[ remainingPath beginsWith: '.' ] whileTrue: [
				currentPackage := currentPackage parentPackage.
				remainingPath := remainingPath allButFirst ].
			possibleEntities := currentPackage children ]
		ifFalse: [ "If we have an absolute path we just start at the root."
			remainingPath := path.
			possibleEntities := currentEntity mooseModel modelRootEntities ].

	"We trim the path because we can have spaces after the dots in relativ paths."
	targetModule := self findTargetEntityFor: remainingPath trim from: possibleEntities.

	"If we have an import all then we import the targeted module directly."
	possibleEntities := entityName = '*'
		                    ifTrue: [ { targetModule } ]
		                    ifFalse: [ targetModule allChildren select: [ :child | child isNamedEntity and: [ child name = entityName ] ] ].

	"It is possible that we have multiple entities with the same name and in that case, python select the last one declared. So we sort by source anchor position to find this one."
	entity := possibleEntities detectMax: [ :possibleEntity | possibleEntity sourceAnchor startPos ]
]
