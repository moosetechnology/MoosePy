Class {
	#name : #FamixPythonLocalVariable,
	#superclass : #FamixPythonNamedEntity,
	#traits : 'FamixTCanBeFinal + FamixTInvocationsReceiver + FamixTLocalVariable + FamixTWithComments',
	#classTraits : 'FamixTCanBeFinal classTrait + FamixTInvocationsReceiver classTrait + FamixTLocalVariable classTrait + FamixTWithComments classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonLocalVariable class >> annotation [

	<FMClass: #LocalVariable super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
