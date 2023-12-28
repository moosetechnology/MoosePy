Class {
	#name : #FamixPythonAttribute,
	#superclass : #FamixPythonNamedEntity,
	#traits : 'FamixTAttribute + FamixTInvocationsReceiver + FamixTWithComments',
	#classTraits : 'FamixTAttribute classTrait + FamixTInvocationsReceiver classTrait + FamixTWithComments classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonAttribute class >> annotation [

	<FMClass: #Attribute super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
