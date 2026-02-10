"
## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `correspondingFile` | `FamixTFile` | nil | File associated to this source anchor|
| `encoding` | `String` | nil | A string representing the encoding of a file|
| `endByte` | `Number` | nil | Stop position in the source in number of bytes|
| `fileName` | `String` | nil | Name of the source file|
| `startByte` | `Number` | nil | Start position in the source in number of bytes|

"
Class {
	#name : 'FamixPythonBytesFileAnchor',
	#superclass : 'FamixPythonSourceAnchor',
	#traits : 'FamixTBytesFileAnchor',
	#classTraits : 'FamixTBytesFileAnchor classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonBytesFileAnchor class >> annotation [

	<FMClass: #BytesFileAnchor super: #FamixPythonSourceAnchor>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
