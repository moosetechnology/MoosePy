"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `element` | `FamixTSourceAnchor` | `sourceAnchor` | `FamixTSourceEntity` | Enable the accessibility to the famix entity that this class is a source pointer for|



"
Class {
	#name : #FamixPythonSourceAnchor,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTSourceAnchor',
	#classTraits : 'FamixTSourceAnchor classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonSourceAnchor class >> annotation [

	<FMClass: #SourceAnchor super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonSourceAnchor class >> isAbstract [

	<generated>
	^ self == FamixPythonSourceAnchor
]
