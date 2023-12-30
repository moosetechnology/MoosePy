Class {
	#name : #FamixPythonModule,
	#superclass : #FamixPythonContainerEntity,
	#traits : 'FamixTImportable + FamixTPackageable + FamixTWithComments + FamixTWithFunctions + FamixTWithInvocations',
	#classTraits : 'FamixTImportable classTrait + FamixTPackageable classTrait + FamixTWithComments classTrait + FamixTWithFunctions classTrait + FamixTWithInvocations classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonModule class >> annotation [

	<FMClass: #Module super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
