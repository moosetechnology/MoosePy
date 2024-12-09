"
## Relations
======================

### Association source
| Relation | Origin | Opposite | Type | Comment |
|---|
| `referencer` | `FamixPythonFunctionReference` | `outgoingFunctionReferences` | `FamixPythonContainerEntity` | |

### Association target
| Relation | Origin | Opposite | Type | Comment |
|---|
| `referredFunction` | `FamixPythonFunctionReference` | `incomingFunctionReferences` | `FamixPythonFunction` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `next` | `FamixTAssociation` | `previous` | `FamixTAssociation` | Next association in an ordered collection of associations. Currently not supported by the Moose importer|
| `previous` | `FamixTAssociation` | `next` | `FamixTAssociation` | Previous association in an ordered collection of associations. Currently not supported by the Moose importer|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|



"
Class {
	#name : 'FamixPythonFunctionReference',
	#superclass : 'FamixPythonEntity',
	#traits : 'FamixTAssociation',
	#classTraits : 'FamixTAssociation classTrait',
	#instVars : [
		'#referencer => FMOne type: #FamixPythonContainerEntity opposite: #outgoingFunctionReferences',
		'#referredFunction => FMOne type: #FamixPythonFunction opposite: #incomingFunctionReferences'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonFunctionReference class >> annotation [

	<FMClass: #FunctionReference super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'accessing' }
FamixPythonFunctionReference >> referencer [
	"Relation named: #referencer type: #FamixPythonContainerEntity opposite: #outgoingFunctionReferences"

	<generated>
	<source>
	^ referencer
]

{ #category : 'accessing' }
FamixPythonFunctionReference >> referencer: anObject [

	<generated>
	referencer := anObject
]

{ #category : 'accessing' }
FamixPythonFunctionReference >> referredFunction [
	"Relation named: #referredFunction type: #FamixPythonFunction opposite: #incomingFunctionReferences"

	<generated>
	<target>
	^ referredFunction
]

{ #category : 'accessing' }
FamixPythonFunctionReference >> referredFunction: anObject [

	<generated>
	referredFunction := anObject
]
