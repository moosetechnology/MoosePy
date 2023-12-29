Class {
	#name : #FamixPythonSourceAnchor,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTSourceAnchor',
	#classTraits : 'FamixTSourceAnchor classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonSourceAnchor class >> annotation [

	<FMClass: #SourceAnchor super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonSourceAnchor class >> isAbstract [

	<generated>
	^ self == FamixPythonSourceAnchor
]
