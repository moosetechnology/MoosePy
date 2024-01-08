Class {
	#name : #FamixPythonMethod,
	#superclass : #FamixPythonContainerEntity,
	#traits : 'FamixTImportable + FamixTInvocable + FamixTMethod + FamixTWithAnnotationInstances + FamixTWithComments + FamixTWithFunctions + FamixTWithInvocations',
	#classTraits : 'FamixTImportable classTrait + FamixTInvocable classTrait + FamixTMethod classTrait + FamixTWithAnnotationInstances classTrait + FamixTWithComments classTrait + FamixTWithFunctions classTrait + FamixTWithInvocations classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonMethod class >> annotation [

	<FMClass: #Method super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
