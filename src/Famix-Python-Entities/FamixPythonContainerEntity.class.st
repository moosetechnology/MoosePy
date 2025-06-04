"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `types` | `FamixTWithTypes` | `typeContainer` | `FamixTType` | Types contained (declared) in this entity, if any. #types is declared in ContainerEntity because different kinds of container can embed types. Types are usually contained in a Famix.Namespace. But types can also be contained in a Famix.Class or Famix.Method (in Java with inner classes for example). Famix.Function can also contain some types such as structs.|

### Outgoing dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `imports` | `FamixTWithImports` | `importingEntity` | `FamixTImport` | |
| `unknowAccessesOrReferences` | `FamixPythonContainerEntity` | `accessorOrReferencer` | `FamixPythonUnknowAccessOrReference` | |



"
Class {
	#name : 'FamixPythonContainerEntity',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTWithClasses + FamixTWithImports',
	#classTraits : 'FamixTWithClasses classTrait + FamixTWithImports classTrait',
	#instVars : [
		'#unknowAccessesOrReferences => FMMany type: #FamixPythonUnknowAccessOrReference opposite: #accessorOrReferencer'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonContainerEntity class >> annotation [

	<FMClass: #ContainerEntity super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : 'testing' }
FamixPythonContainerEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonContainerEntity
]

{ #category : 'adding' }
FamixPythonContainerEntity >> addUnknowAccessesOrReference: anObject [
	<generated>
	^ self unknowAccessesOrReferences add: anObject
]

{ #category : 'accessing' }
FamixPythonContainerEntity >> unknowAccessesOrReferences [
	"Relation named: #unknowAccessesOrReferences type: #FamixPythonUnknowAccessOrReference opposite: #accessorOrReferencer"

	<generated>
	<derived>
	^ unknowAccessesOrReferences
]

{ #category : 'accessing' }
FamixPythonContainerEntity >> unknowAccessesOrReferences: anObject [

	<generated>
	unknowAccessesOrReferences value: anObject
]
