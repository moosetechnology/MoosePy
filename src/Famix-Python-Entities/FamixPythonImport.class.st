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
| `asName` | `String` | nil | ""import b as c"", asName is c|
| `entityName` | `String` | nil | ""from a import b"", entityName is b|
| `fromName` | `String` | nil | ""from a import b"", fromName is a|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|

"
Class {
	#name : #FamixPythonImport,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTImport',
	#classTraits : 'FamixTImport classTrait',
	#instVars : [
		'#fromName => FMProperty',
		'#entityName => FMProperty',
		'#asName => FMProperty'
	],
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonImport class >> annotation [

	<FMClass: #Import super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
FamixPythonImport >> asName [

	<FMProperty: #asName type: #String>
	<generated>
	<FMComment: '"import b as c", asName is c'>
	^ asName
]

{ #category : #accessing }
FamixPythonImport >> asName: anObject [
	<generated>
	asName := anObject
]

{ #category : #accessing }
FamixPythonImport >> entityName [

	<FMProperty: #entityName type: #String>
	<generated>
	<FMComment: '"from a import b", entityName is b'>
	^ entityName
]

{ #category : #accessing }
FamixPythonImport >> entityName: anObject [
	<generated>
	entityName := anObject
]

{ #category : #accessing }
FamixPythonImport >> fromName [

	<FMProperty: #fromName type: #String>
	<generated>
	<FMComment: '"from a import b", fromName is a'>
	^ fromName
]

{ #category : #accessing }
FamixPythonImport >> fromName: anObject [
	<generated>
	fromName := anObject
]
