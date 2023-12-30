Class {
	#name : #FamixPythonMethod,
	#superclass : #FamixPythonContainerEntity,
	#traits : 'FamixTImportable + FamixTInvocable + FamixTMethod + FamixTWithAnnotationInstances + FamixTWithComments + FamixTWithInvocations',
	#classTraits : 'FamixTImportable classTrait + FamixTInvocable classTrait + FamixTMethod classTrait + FamixTWithAnnotationInstances classTrait + FamixTWithComments classTrait + FamixTWithInvocations classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonMethod class >> annotation [

	<FMClass: #Method super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
