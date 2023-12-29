Class {
	#name : #FamixPythonFunction,
	#superclass : #FamixPythonContainerEntity,
	#traits : 'FamixTFunction + FamixTImportable + FamixTInvocable + FamixTWithComments + FamixTWithImplicitVariables + FamixTWithInvocations',
	#classTraits : 'FamixTFunction classTrait + FamixTImportable classTrait + FamixTInvocable classTrait + FamixTWithComments classTrait + FamixTWithImplicitVariables classTrait + FamixTWithInvocations classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonFunction class >> annotation [

	<FMClass: #Function super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
