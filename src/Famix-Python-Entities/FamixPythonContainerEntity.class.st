Class {
	#name : #FamixPythonContainerEntity,
	#superclass : #FamixPythonNamedEntity,
	#traits : 'FamixTWithClasses',
	#classTraits : 'FamixTWithClasses classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonContainerEntity class >> annotation [

	<FMClass: #ContainerEntity super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonContainerEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonContainerEntity
]
