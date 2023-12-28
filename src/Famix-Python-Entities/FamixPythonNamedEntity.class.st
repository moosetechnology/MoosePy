Class {
	#name : #FamixPythonNamedEntity,
	#superclass : #FamixPythonSourcedEntity,
	#traits : 'FamixTInvocationsReceiver + FamixTNamedEntity + FamixTWithAnnotationInstances + TEntityMetaLevelDependency',
	#classTraits : 'FamixTInvocationsReceiver classTrait + FamixTNamedEntity classTrait + FamixTWithAnnotationInstances classTrait + TEntityMetaLevelDependency classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonNamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #FamixPythonSourcedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonNamedEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonNamedEntity
]
