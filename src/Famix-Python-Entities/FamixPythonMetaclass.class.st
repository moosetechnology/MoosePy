"
## Relations
======================

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `metaclassUsers` | `FamixPythonMetaclass` | `metaclass` | `FamixPythonMetaclassUsage` | |



"
Class {
	#name : 'FamixPythonMetaclass',
	#superclass : 'FamixPythonClass',
	#instVars : [
		'#metaclassUsers => FMMany type: #FamixPythonMetaclassUsage opposite: #metaclass'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonMetaclass class >> annotation [

	<FMClass: #Metaclass super: #FamixPythonClass>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'adding' }
FamixPythonMetaclass >> addMetaclassUser: anObject [
	<generated>
	^ self metaclassUsers add: anObject
]

{ #category : 'accessing' }
FamixPythonMetaclass >> metaclassUsers [
	"Relation named: #metaclassUsers type: #FamixPythonMetaclassUsage opposite: #metaclass"

	<generated>
	<derived>
	^ metaclassUsers
]

{ #category : 'accessing' }
FamixPythonMetaclass >> metaclassUsers: anObject [

	<generated>
	metaclassUsers value: anObject
]
