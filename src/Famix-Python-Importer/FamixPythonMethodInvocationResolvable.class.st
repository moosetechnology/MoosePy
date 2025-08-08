"
I resolve invocations or instantiations in the form of `y.x()` when I'm sure  `y` is not an imported entity.
"
Class {
	#name : 'FamixPythonMethodInvocationResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#instVars : [
		'receiver'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonMethodInvocationResolvable class >> identifier: aString receiver: anotherString [

	^ (self identifier: aString)
		  receiver: anotherString;
		  yourself
]

{ #category : 'accessing' }
FamixPythonMethodInvocationResolvable >> receiver: anObject [
	receiver := anObject
]

{ #category : 'resolution' }
FamixPythonMethodInvocationResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	| reacheableClasses |
	reacheableClasses := aScope reachableEntities select: [ :entity | entity isOfType: FamixTClass ].

	reacheableClasses do: [ :class |
			class methods
				detect: [ :method | method name = identifier ]
				ifFound: [ :method | ^ self result: method ] ].

	NotFound signal
]
