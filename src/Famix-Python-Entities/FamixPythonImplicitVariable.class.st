Class {
	#name : #FamixPythonImplicitVariable,
	#superclass : #FamixPythonNamedEntity,
	#traits : 'FamixTImplicitVariable + FamixTInvocationsReceiver',
	#classTraits : 'FamixTImplicitVariable classTrait + FamixTInvocationsReceiver classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonImplicitVariable class >> annotation [

	<FMClass: #ImplicitVariable super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
