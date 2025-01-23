"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentPackage` | `FamixTPackageable` | `childEntities` | `FamixTPackage` | Package containing the entity in the code structure (if applicable)|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accessesOrReferences` | `FamixPythonUnknownEntity` | `unknownEntity` | `FamixPythonUnknowAccessOrReference` | |
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|



"
Class {
	#name : 'FamixPythonUnknownEntity',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTImportable + FamixTPackageable',
	#classTraits : 'FamixTImportable classTrait + FamixTPackageable classTrait',
	#instVars : [
		'#accessesOrReferences => FMMany type: #FamixPythonUnknowAccessOrReference opposite: #unknownEntity'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonUnknownEntity class >> annotation [

	<FMClass: #UnknownEntity super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'accessing' }
FamixPythonUnknownEntity >> accessesOrReferences [
	"Relation named: #accessesOrReferences type: #FamixPythonUnknowAccessOrReference opposite: #unknownEntity"

	<generated>
	<derived>
	^ accessesOrReferences
]

{ #category : 'accessing' }
FamixPythonUnknownEntity >> accessesOrReferences: anObject [

	<generated>
	accessesOrReferences value: anObject
]

{ #category : 'adding' }
FamixPythonUnknownEntity >> addAccessesOrReference: anObject [
	<generated>
	^ self accessesOrReferences add: anObject
]

{ #category : 'testing' }
FamixPythonUnknownEntity >> isStub [

	^ true
]
