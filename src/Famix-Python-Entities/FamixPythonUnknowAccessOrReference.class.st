"
## Relations
======================

### Association source
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accessorOrReferencer` | `FamixPythonUnknowAccessOrReference` | `unknowAccessesOrReferences` | `FamixPythonContainerEntity` | |

### Association target
| Relation | Origin | Opposite | Type | Comment |
|---|
| `unknownEntity` | `FamixPythonUnknowAccessOrReference` | `accessesOrReferences` | `FamixPythonUnknownAccessedOrReferencedEntity` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `next` | `FamixTAssociation` | `previous` | `FamixTAssociation` | Next association in an ordered collection of associations. Currently not supported by the Moose importer|
| `previous` | `FamixTAssociation` | `next` | `FamixTAssociation` | Previous association in an ordered collection of associations. Currently not supported by the Moose importer|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|



"
Class {
	#name : 'FamixPythonUnknowAccessOrReference',
	#superclass : 'FamixPythonEntity',
	#traits : 'FamixTAssociation',
	#classTraits : 'FamixTAssociation classTrait',
	#instVars : [
		'#accessorOrReferencer => FMOne type: #FamixPythonContainerEntity opposite: #unknowAccessesOrReferences',
		'#unknownEntity => FMOne type: #FamixPythonUnknownAccessedOrReferencedEntity opposite: #accessesOrReferences'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonUnknowAccessOrReference class >> annotation [

	<FMClass: #UnknowAccessOrReference super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'accessing' }
FamixPythonUnknowAccessOrReference >> accessorOrReferencer [
	"Relation named: #accessorOrReferencer type: #FamixPythonContainerEntity opposite: #unknowAccessesOrReferences"

	<generated>
	<source>
	^ accessorOrReferencer
]

{ #category : 'accessing' }
FamixPythonUnknowAccessOrReference >> accessorOrReferencer: anObject [

	<generated>
	accessorOrReferencer := anObject
]

{ #category : 'accessing' }
FamixPythonUnknowAccessOrReference >> unknownEntity [
	"Relation named: #unknownEntity type: #FamixPythonUnknownAccessedOrReferencedEntity opposite: #accessesOrReferences"

	<generated>
	<target>
	^ unknownEntity
]

{ #category : 'accessing' }
FamixPythonUnknowAccessOrReference >> unknownEntity: anObject [

	<generated>
	unknownEntity := anObject
]
