"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentPackage` | `FamixTPackageable` | `childEntities` | `FamixTPackage` | Package containing the entity in the code structure (if applicable)|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `childEntities` | `FamixTPackage` | `parentPackage` | `FamixTPackageable` | |

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accessesOrReferences` | `FamixPythonUnknownEntity` | `unknownEntity` | `FamixPythonUnknowAccessOrReference` | |
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|
| `incomingInvocations` | `FamixTInvocable` | `candidates` | `FamixTInvocation` | Incoming invocations from other behaviours computed by the candidate operator.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|

"
Class {
	#name : 'FamixPythonUnknownEntity',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTImportable + FamixTInvocable + FamixTPackage + FamixTPackageable',
	#classTraits : 'FamixTImportable classTrait + FamixTInvocable classTrait + FamixTPackage classTrait + FamixTPackageable classTrait',
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
