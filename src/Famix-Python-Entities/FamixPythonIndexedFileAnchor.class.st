"
## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `correspondingFile` | `FamixTFile` | nil | File associated to this source anchor|
| `encoding` | `String` | nil | A string representing the encoding of a file|
| `endPos` | `Number` | nil | Stop position in the source|
| `fileName` | `String` | nil | Name of the source file|
| `startPos` | `Number` | nil | Start position in the source|

"
Class {
	#name : #FamixPythonIndexedFileAnchor,
	#superclass : #FamixPythonSourceAnchor,
	#traits : 'FamixTIndexedFileNavigation',
	#classTraits : 'FamixTIndexedFileNavigation classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonIndexedFileAnchor class >> annotation [

	<FMClass: #IndexedFileAnchor super: #FamixPythonSourceAnchor>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
