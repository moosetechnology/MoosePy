Class {
	#name : 'FamixPythonMethodInvocationResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'resolution' }
FamixPythonMethodInvocationResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	^ (aScope entity withAllParents flatCollectAsSet: [ :anEntity | anEntity reachableEntitiesNamed: identifier ofKinds: { FamixPythonMethod } ])
		  ifNotEmpty: [ :methods | entity := methods ]
		  ifEmpty: [ SRNoResolutionPossible signal ]
]
