"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `annotationTypesContainer` | `FamixTAnnotationType` | `definedAnnotationTypes` | `FamixTWithAnnotationTypes` | Container in which an AnnotationType may reside|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `instances` | `FamixTAnnotationType` | `annotationType` | `FamixTTypedAnnotationInstance` | Annotations of this type|



"
Class {
	#name : 'FamixPythonAnnotationType',
	#superclass : 'FamixPythonNamedEntity',
	#traits : 'FamixTAnnotationType',
	#classTraits : 'FamixTAnnotationType classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonAnnotationType class >> annotation [

	<FMClass: #AnnotationType super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
