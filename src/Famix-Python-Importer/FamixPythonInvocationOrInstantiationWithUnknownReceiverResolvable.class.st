"
I resolve invocations or instantiations in the form of `y.x()` when I'm not sure if `y` is an imported module or package or an instance of a class.

There are two cases possible. 

Either `y` is an imported module or package and I need to create an invocation/instantiation of the entity coming from it. 
Or `y` is the instance of a class and we are doing a method invocation. 

I cannot know before the symbol resolution which case it is because it requires to know what is the imported entity of the imports and this is done only at the symbol resolution.
"
Class {
	#name : 'FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#instVars : [
		'receiver',
		'correspondingImport'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable class >> identifier: aString receiver: anotherString [

	^ (self identifier: aString)
		  receiver: anotherString;
		  yourself
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable >> correspondingImport [
	^ correspondingImport
]

{ #category : 'testing' }
FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable >> hasCorrespondingImport [

	^ self correspondingImport isNotNil
]

{ #category : 'accessing' }
FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable >> receiver: anObject [
	receiver := anObject
]

{ #category : 'resolution' }
FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"First we check if the receiver is an imported module or package. If it is not, we have a method invocation that we are treating later."

	(receiver includes: $.) ifFalse: [
			((currentEntity withAllParents flatCollect: [ :anEntity | anEntity query outgoing local dependenciesOfType: FamixPythonImport ]) select: [ :import |
				 import importedEntity isNotNil "It's nil if we did not resolve it yet but that means the import is not relevent here." ])
				detect: [ :import |
						({
							 FamixPythonModule.
							 FamixPythonPackage.
							 FamixPythonUnknownEntity } anySatisfy: [ :class | import importedEntity isOfType: class ]) and: [
								import hasAlias
									ifTrue: [ import alias = receiver ]
									ifFalse: [ import importedEntity name = receiver ] ] ]
				ifFound: [ :import |
						correspondingImport := import.
						^ (import importedEntity definedEntitiesNamed: identifier ofKinds: {
								   FamixPythonFunction.
								   FamixPythonClass }) ifEmpty: [ SRNoResolutionPossible signal ] ifNotEmpty: [ :entities |
								  | matchingEntities |
								  self flag: #todo. "This could probably be simplified? Or at least remove duplication with sibling classes.."
								  self flag: #todo. "Do we need the sorting? If no update also the other resolvable with this code."
								  matchingEntities := entities sorted: [ :anEntity | anEntity sourceAnchor startPos ] ascending.
								  (matchingEntities collectAsSet: #class) size = 1
									  ifTrue: [ "This is an instantiation"
											  matchingEntities last isClass ifTrue: [ ^ self entity: matchingEntities last ].

											  self result: matchingEntities ]
									  ifFalse: [
											  self entity: (matchingEntities last isClass
													   ifTrue: [ matchingEntities last ]
													   ifFalse: [ { matchingEntities last } ]) ] ] ] ].

	^ (aScope entity withAllParents flatCollectAsSet: [ :anEntity | anEntity reachableEntitiesNamed: identifier ofKinds: { FamixPythonMethod } ])
		  ifNotEmpty: [ :methods | self result: methods ]
		  ifEmpty: [ SRNoResolutionPossible signal ]
]
