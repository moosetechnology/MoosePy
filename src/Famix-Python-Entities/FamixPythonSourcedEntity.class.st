Class {
	#name : #FamixPythonSourcedEntity,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTSourceEntity',
	#classTraits : 'FamixTSourceEntity classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonSourcedEntity class >> annotation [

	<FMClass: #SourcedEntity super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonSourcedEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonSourcedEntity
]
