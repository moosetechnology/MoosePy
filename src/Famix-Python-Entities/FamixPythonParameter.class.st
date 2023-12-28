Class {
	#name : #FamixPythonParameter,
	#superclass : #FamixPythonNamedEntity,
	#traits : 'FamixTParameter + FamixTWithComments',
	#classTraits : 'FamixTParameter classTrait + FamixTWithComments classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonParameter class >> annotation [

	<FMClass: #Parameter super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
