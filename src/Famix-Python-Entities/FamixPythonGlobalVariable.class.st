"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentScope` | `FamixTGlobalVariable` | `globalVariables` | `FamixTWithGlobalVariables` | Scope declaring the global variable. belongsTo implementation|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `comments` | `FamixTWithComments` | `commentedEntity` | `FamixTComment` | List of comments for the entity|

### Outgoing dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `typing` | `FamixTTypedEntity` | `typedEntity` | `FamixTEntityTyping` | Association linking this entity to its declared type.|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingAccesses` | `FamixTAccessible` | `candidates` | `FamixTAccess` | All Famix accesses pointing to this structural entity|
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `receivingInvocations` | `FamixTInvocationsReceiver` | `receiver` | `FamixTInvocation` | List of invocations performed on this entity (considered as the receiver)|
| `shadowedEntity` | `FamixTShadower` | `shadowingEntities` | `FamixTShadowable` | Entity that is been shadowed by myself in my defining scope.|
| `shadowingEntities` | `FamixTShadowable` | `shadowedEntity` | `FamixTShadower` | Entities shadowing me in my defining scope.|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|

"
Class {
	#name : 'FamixPythonGlobalVariable',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTGlobalVariable + FamixTImportable + FamixTInvocationsReceiver + FamixTShadowable + FamixTShadower + FamixTWithComments',
	#classTraits : 'FamixTGlobalVariable classTrait + FamixTImportable classTrait + FamixTInvocationsReceiver classTrait + FamixTShadowable classTrait + FamixTShadower classTrait + FamixTWithComments classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonGlobalVariable class >> annotation [

	<FMClass: #GlobalVariable super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
