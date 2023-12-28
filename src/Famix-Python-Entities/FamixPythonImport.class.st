Class {
	#name : #FamixPythonImport,
	#superclass : #FamixPythonEntity,
	#traits : 'FamixTImport',
	#classTraits : 'FamixTImport classTrait',
	#instVars : [
		'#asName => FMProperty',
		'#entityName => FMProperty',
		'#fromName => FMProperty',
		'#manualImportingEntity'
	],
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonImport class >> annotation [

	<FMClass: #Import super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
FamixPythonImport >> asName [

	<FMProperty: #asName type: #String>
	<generated>
	<FMComment: 'import b as c
	asName is c'>
	^ asName
]

{ #category : #accessing }
FamixPythonImport >> asName: anObject [
	<generated>
	asName := anObject
]

{ #category : #accessing }
FamixPythonImport >> entityName [

	<FMProperty: #entityName type: #String>
	<generated>
	<FMComment: 'from a import b
	entityName is b'>
	^ entityName
]

{ #category : #accessing }
FamixPythonImport >> entityName: anObject [
	<generated>
	entityName := anObject
]

{ #category : #accessing }
FamixPythonImport >> fromName [

	<FMProperty: #fromName type: #String>
	<generated>
	<FMComment: 'from a import b
	fromName is a'>
	^ fromName
]

{ #category : #accessing }
FamixPythonImport >> fromName: anObject [
	<generated>
	fromName := anObject
]

{ #category : #accessing }
FamixPythonImport >> manualImportingEntity: anObject [

	manualImportingEntity := anObject
]
