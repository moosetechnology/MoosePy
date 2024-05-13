"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `sourcedEntities` | `FamixTSourceLanguage` | `declaredSourceLanguage` | `FamixTWithSourceLanguages` | References to the entities saying explicitly that are written in this language.|



"
Class {
	#name : #FamixPythonSourceLanguage,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTSourceLanguage',
	#classTraits : 'FamixTSourceLanguage classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonSourceLanguage class >> annotation [

	<FMClass: #SourceLanguage super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
