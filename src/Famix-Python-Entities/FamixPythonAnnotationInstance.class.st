"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `annotatedEntity` | `FamixTAnnotationInstance` | `annotationInstances` | `FamixTWithAnnotationInstances` | The NamedEntity on which the annotation occurs.|
| `annotationType` | `FamixTTypedAnnotationInstance` | `instances` | `FamixTAnnotationType` | Refers to the type of an annotation. (In some languages, Java and C#, an annotation as an explicit type). |



"
Class {
	#name : #FamixPythonAnnotationInstance,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTAnnotationInstance + FamixTTypedAnnotationInstance',
	#classTraits : 'FamixTAnnotationInstance classTrait + FamixTTypedAnnotationInstance classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonAnnotationInstance class >> annotation [

	<FMClass: #AnnotationInstance super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
