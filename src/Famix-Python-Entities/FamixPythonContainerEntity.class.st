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
| `outgoingFunctionReferences` | `FamixPythonContainerEntity` | `referencer` | `FamixPythonFunctionReference` | |
| `outgoingImports` | `FamixTWithImports` | `importingEntity` | `FamixTImport` | |
| `unknowAccessesOrReferences` | `FamixPythonContainerEntity` | `accessorOrReferencer` | `FamixPythonUnknowAccessOrReference` | |



"
Class {
	#name : 'FamixPythonContainerEntity',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTWithClasses + FamixTWithImports',
	#classTraits : 'FamixTWithClasses classTrait + FamixTWithImports classTrait',
	#instVars : [
		'#outgoingFunctionReferences => FMMany type: #FamixPythonFunctionReference opposite: #referencer',
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
FamixPythonContainerEntity >> addOutgoingFunctionReference: anObject [
	<generated>
	^ self outgoingFunctionReferences add: anObject
]

{ #category : 'adding' }
FamixPythonContainerEntity >> addUnknowAccessesOrReference: anObject [
	<generated>
	^ self unknowAccessesOrReferences add: anObject
]

{ #category : 'accessing' }
FamixPythonContainerEntity >> outgoingFunctionReferences [
	"Relation named: #outgoingFunctionReferences type: #FamixPythonFunctionReference opposite: #referencer"

	<generated>
	<derived>
	^ outgoingFunctionReferences
]

{ #category : 'accessing' }
FamixPythonContainerEntity >> outgoingFunctionReferences: anObject [

	<generated>
	outgoingFunctionReferences value: anObject
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
