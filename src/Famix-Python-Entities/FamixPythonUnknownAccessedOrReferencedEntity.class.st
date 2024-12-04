Class {
	#name : 'FamixPythonUnknownAccessedOrReferencedEntity',
	#superclass : 'FamixPythonNamedEntity',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonUnknownAccessedOrReferencedEntity class >> annotation [

	<FMClass: #UnknownAccessedOrReferencedEntity super: #FamixPythonNamedEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'testing' }
FamixPythonUnknownAccessedOrReferencedEntity >> isStub [

	^ true
]
