"
I resolve invocations or instantiations in the form of `y.x()` when I'm sure  `y` is not an imported entity.
"
Class {
	#name : 'FamixPythonMethodInvocationResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'identifier'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonMethodInvocationResolvable class >> identifier: anIdentifierString [

	^ self new
		  identifier: anIdentifierString;
		  yourself
]

{ #category : 'accessing' }
FamixPythonMethodInvocationResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
FamixPythonMethodInvocationResolvable >> identifier: anObject [

	identifier := anObject
]

{ #category : 'resolution' }
FamixPythonMethodInvocationResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	| reacheableClasses candidates |
	reacheableClasses := aScope entity withAllParents flatCollect: [ :entity | entity reachableEntities select: #isClass ].
	candidates := OrderedCollection new.

	reacheableClasses do: [ :class |
			self flag: #todo. "Should be #allMethods"
			class methods
				detect: [ :method | method name = identifier ]
				ifFound: [ :method | candidates add: method ] ].

	candidates ifNotEmpty: [ ^ self result: candidates ].

	SRNoResolutionPossible signal
]
