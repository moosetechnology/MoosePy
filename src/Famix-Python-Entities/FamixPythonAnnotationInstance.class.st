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
