"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|



"
Class {
	#name : 'FamixPythonSourcedEntity',
	#superclass : 'FamixPythonEntity',
	#traits : 'FamixTSourceEntity',
	#classTraits : 'FamixTSourceEntity classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonSourcedEntity class >> annotation [

	<FMClass: #SourcedEntity super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : 'testing' }
FamixPythonSourcedEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonSourcedEntity
]
