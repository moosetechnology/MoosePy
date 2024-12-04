"
## Relations
======================

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accessesOrReferences` | `FamixPythonUnknownAccessedOrReferencedEntity` | `unknownEntity` | `FamixPythonUnknowAccessOrReference` | |



"
Class {
	#name : 'FamixPythonUnknownAccessedOrReferencedEntity',
	#superclass : 'FamixPythonNamedEntity',
	#instVars : [
		'#accessesOrReferences => FMMany type: #FamixPythonUnknowAccessOrReference opposite: #unknownEntity'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonUnknownAccessedOrReferencedEntity class >> annotation [

	<FMClass: #UnknownAccessedOrReferencedEntity super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'accessing' }
FamixPythonUnknownAccessedOrReferencedEntity >> accessesOrReferences [
	"Relation named: #accessesOrReferences type: #FamixPythonUnknowAccessOrReference opposite: #unknownEntity"

	<generated>
	<derived>
	^ accessesOrReferences
]

{ #category : 'accessing' }
FamixPythonUnknownAccessedOrReferencedEntity >> accessesOrReferences: anObject [

	<generated>
	accessesOrReferences value: anObject
]

{ #category : 'adding' }
FamixPythonUnknownAccessedOrReferencedEntity >> addAccessesOrReference: anObject [
	<generated>
	^ self accessesOrReferences add: anObject
]

{ #category : 'testing' }
FamixPythonUnknownAccessedOrReferencedEntity >> isStub [

	^ true
]
