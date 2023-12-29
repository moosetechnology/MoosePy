Class {
	#name : #FamixPythonType,
	#superclass : #FamixPythonContainerEntity,
	#traits : 'FamixTType + FamixTWithMethods',
	#classTraits : 'FamixTType classTrait + FamixTWithMethods classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonType class >> annotation [

	<FMClass: #Type super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
