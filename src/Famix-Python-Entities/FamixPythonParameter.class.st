"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentBehaviouralEntity` | `FamixTParameter` | `parameters` | `FamixTWithParameters` | Behavioural entity containing this parameter. belongsTo implementation|

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
| `incomingAccesses` | `FamixTAccessible` | `variable` | `FamixTAccess` | All Famix accesses pointing to this structural entity|

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
	#name : 'FamixPythonParameter',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTParameter + FamixTWithComments',
	#classTraits : 'FamixTParameter classTrait + FamixTWithComments classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonParameter class >> annotation [

	<FMClass: #Parameter super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'testing' }
FamixPythonParameter >> hasDefaultValue [

	<FMProperty: #hasDefaultValue type: #Boolean defaultValue: false>
	<derived>
	<FMComment: 'Return true if there is a default value to the parameter'>
	^ self attributeAt: #hasDefaultValue ifAbsent: [ false ]
]

{ #category : 'testing' }
FamixPythonParameter >> isDictionarySplat [

	<FMProperty: #isDictionarySplat type: #Boolean defaultValue: false>
	<derived>
	<FMComment: 'Return true if there is the parameter is a dictionary splat(example: `def f(**kwargs):`)'>
	^ self attributeAt: #isDictionarySplat ifAbsent: [ false ]
]

{ #category : 'testing' }
FamixPythonParameter >> isListSplat [

	<FMProperty: #isListSplat type: #Boolean defaultValue: false>
	<derived>
	<FMComment: 'Return true if there is the parameter is a list splat (example: `def f(*args):`)'>
	^ self attributeAt: #isListSplat ifAbsent: [ false ]
]

{ #category : 'testing' }
FamixPythonParameter >> isSelf [

	^ self parentBehaviouralEntity parameters first = self
]
