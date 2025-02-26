"
## Relations
======================

### Association source
| Relation | Origin | Opposite | Type | Comment |
|---|
| `user` | `FamixPythonMetaclassUsage` | `metaclassUsage` | `FamixPythonClass` | |

### Association target
| Relation | Origin | Opposite | Type | Comment |
|---|
| `metaclass` | `FamixPythonMetaclassUsage` | `metaclassUsers` | `FamixPythonMetaclass` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `next` | `FamixTAssociation` | `previous` | `FamixTAssociation` | Next association in an ordered collection of associations. Currently not supported by the Moose importer|
| `previous` | `FamixTAssociation` | `next` | `FamixTAssociation` | Previous association in an ordered collection of associations. Currently not supported by the Moose importer|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|



"
Class {
	#name : 'FamixPythonMetaclassUsage',
	#superclass : 'FamixPythonEntity',
	#traits : 'FamixTAssociation',
	#classTraits : 'FamixTAssociation classTrait',
	#instVars : [
		'#user => FMOne type: #FamixPythonClass opposite: #metaclassUsage',
		'#metaclass => FMOne type: #FamixPythonMetaclass opposite: #metaclassUsers'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonMetaclassUsage class >> annotation [

	<FMClass: #MetaclassUsage super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'accessing' }
FamixPythonMetaclassUsage >> metaclass [
	"Relation named: #metaclass type: #FamixPythonMetaclass opposite: #metaclassUsers"

	<generated>
	<target>
	^ metaclass
]

{ #category : 'accessing' }
FamixPythonMetaclassUsage >> metaclass: anObject [

	<generated>
	metaclass := anObject
]

{ #category : 'accessing' }
FamixPythonMetaclassUsage >> user [
	"Relation named: #user type: #FamixPythonClass opposite: #metaclassUsage"

	<generated>
	<source>
	^ user
]

{ #category : 'accessing' }
FamixPythonMetaclassUsage >> user: anObject [

	<generated>
	user := anObject
]
