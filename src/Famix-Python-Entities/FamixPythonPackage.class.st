Class {
	#name : #FamixPythonPackage,
	#superclass : #FamixPythonContainerEntity,
	#traits : 'FamixTImportable + FamixTPackage + FamixTPackageable + FamixTWithComments',
	#classTraits : 'FamixTImportable classTrait + FamixTPackage classTrait + FamixTPackageable classTrait + FamixTWithComments classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonPackage class >> annotation [

	<FMClass: #Package super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
