"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|

"
Class {
	#name : #FamixPythonSourcedEntity,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTSourceEntity',
	#classTraits : 'FamixTSourceEntity classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonSourcedEntity class >> annotation [

	<FMClass: #SourcedEntity super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonSourcedEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonSourcedEntity
]
