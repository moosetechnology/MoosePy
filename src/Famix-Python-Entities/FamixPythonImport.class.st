"
## Relations
======================

### Association source
| Relation | Origin | Opposite | Type | Comment |
|---|
| `importingEntity` | `FamixTImport` | `outgoingImports` | `FamixTWithImports` | Importing entity|

### Association target
| Relation | Origin | Opposite | Type | Comment |
|---|
| `importedEntity` | `FamixTImport` | `incomingImports` | `FamixTImportable` | Imported entity|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `next` | `FamixTAssociation` | `previous` | `FamixTAssociation` | Next association in an ordered collection of associations. Currently not supported by the Moose importer|
| `previous` | `FamixTAssociation` | `next` | `FamixTAssociation` | Previous association in an ordered collection of associations. Currently not supported by the Moose importer|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `alias` | `String` | nil | Alias of the imported entity in the scope of the import|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|

"
Class {
	#name : 'FamixPythonImport',
	#superclass : 'FamixPythonEntity',
	#traits : 'FamixTImport',
	#classTraits : 'FamixTImport classTrait',
	#instVars : [
		'#alias => FMProperty'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonImport class >> annotation [

	<FMClass: #Import super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'accessing' }
FamixPythonImport >> alias [

	<FMProperty: #alias type: #String>
	<generated>
	<FMComment: 'Alias of the imported entity in the scope of the import'>
	^ alias
]

{ #category : 'accessing' }
FamixPythonImport >> alias: anObject [
	<generated>
	alias := anObject
]
