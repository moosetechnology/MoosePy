Class {
	#name : #FamixPythonEntity,
	#superclass : #MooseEntity,
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
FamixPythonEntity class >> isAbstract [

	<generated>
	^ self == FamixPythonEntity
]

{ #category : #meta }
FamixPythonEntity class >> metamodel [

	<generated>
	^ FamixPythonModel metamodel
]

{ #category : #testing }
FamixPythonEntity >> isAccess [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isAssociation [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isAttribute [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isBehavioural [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isClass [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isFunction [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isImplicitVariable [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isInheritance [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isInvocation [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isLocalVariable [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isMethod [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isPackage [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isPrimitiveType [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isReference [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isStructuralEntity [

	<generated>
	^ false
]

{ #category : #testing }
FamixPythonEntity >> isType [

	<generated>
	^ false
]
