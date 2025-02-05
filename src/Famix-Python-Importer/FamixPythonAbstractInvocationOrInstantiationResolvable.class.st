Class {
	#name : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
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
FamixPythonAbstractInvocationOrInstantiationResolvable class >> identifier: anIdentifierString [

	^ self new
		  identifier: anIdentifierString;
		  yourself
]

{ #category : 'hooks' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [

	self entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> entity [

	^ entity
]

{ #category : 'accessing' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> identifier: anObject [

	identifier := anObject
]
