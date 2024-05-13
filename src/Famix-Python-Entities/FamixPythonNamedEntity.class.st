"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `receivingInvocations` | `FamixTInvocationsReceiver` | `receiver` | `FamixTInvocation` | List of invocations performed on this entity (considered as the receiver)|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|

"
Class {
	#name : #FamixPythonNamedEntity,
	#superclass : #FamixPythonSourcedEntity,
	#traits : 'FamixTInvocationsReceiver + FamixTNamedEntity + TEntityMetaLevelDependency',
	#classTraits : 'FamixTInvocationsReceiver classTrait + FamixTNamedEntity classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonNamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #FamixPythonSourcedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonNamedEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonNamedEntity
]
