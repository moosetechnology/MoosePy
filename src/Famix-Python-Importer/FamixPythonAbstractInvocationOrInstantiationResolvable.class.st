Class {
	#name : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'identifier'
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

{ #category : 'accessing' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
FamixPythonAbstractInvocationOrInstantiationResolvable >> identifier: anObject [

	identifier := anObject
]
