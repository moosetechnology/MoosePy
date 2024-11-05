Class {
	#name : 'FamixPythonImportResolvable',
	#superclass : 'FamixPythonAbstractImportResolvable',
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

{ #category : 'accessing' }
FamixPythonImportResolvable >> entity [
	^ entity
]

{ #category : 'accessing' }
FamixPythonImportResolvable >> entity: anObject [

	entity := anObject
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

	entity := self findTargetEntityFor: path from: currentEntity mooseModel
]
