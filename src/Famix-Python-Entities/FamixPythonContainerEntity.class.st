"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `types` | `FamixTWithTypes` | `typeContainer` | `FamixTType` | Types contained (declared) in this entity, if any. #types is declared in ContainerEntity because different kinds of container can embed types. Types are usually contained in a Famix.Namespace. But types can also be contained in a Famix.Class or Famix.Method (in Java with inner classes for example). Famix.Function can also contain some types such as structs.|



"
Class {
	#name : #FamixPythonContainerEntity,
	#superclass : #FamixPythonNamedEntity,
	#traits : 'FamixTWithClasses',
	#classTraits : 'FamixTWithClasses classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonContainerEntity class >> annotation [

	<FMClass: #ContainerEntity super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonContainerEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonContainerEntity
]
