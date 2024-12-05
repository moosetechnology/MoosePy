"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `typeContainer` | `FamixTType` | `types` | `FamixTWithTypes` | Container entity to which this type belongs. Container is a namespace, not a package (Smalltalk).|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `attributes` | `FamixTWithAttributes` | `parentType` | `FamixTAttribute` | List of attributes declared by this type.|
| `comments` | `FamixTWithComments` | `commentedEntity` | `FamixTComment` | List of comments for the entity|
| `lambdas` | `FamixTWithLambdas` | `lambdaContainer` | `FamixTLambda` | Lambdas defined in the container, if any.|
| `methods` | `FamixTWithMethods` | `parentType` | `FamixTMethod` | Methods declared by this type.|

### Outgoing dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accesses` | `FamixTWithAccesses` | `accessor` | `FamixTAccess` | Accesses to variables made by this behaviour.|
| `outgoingReferences` | `FamixTWithReferences` | `referencer` | `FamixTReference` | References from this entity to other entities.|
| `superInheritances` | `FamixTWithInheritances` | `subclass` | `FamixTInheritance` | Superinheritance relationships, i.e. known superclasses of this type.|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|
| `incomingReferences` | `FamixTReferenceable` | `referredType` | `FamixTReference` | References to this entity by other entities.|
| `subInheritances` | `FamixTWithInheritances` | `superclass` | `FamixTInheritance` | Subinheritance relationships, i.e. known subclasses of this type.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `annotationInstances` | `FamixTWithAnnotationInstances` | `annotatedEntity` | `FamixTAnnotationInstance` | This property corresponds to the set of annotations associated to the entity|
| `instancedClasses` | `FamixPythonClass` | `metaclass` | `FamixPythonClass` | |
| `metaclass` | `FamixPythonClass` | `instancedClasses` | `FamixPythonClass` | |
| `receivingInvocations` | `FamixTInvocationsReceiver` | `receiver` | `FamixTInvocation` | List of invocations performed on this entity (considered as the receiver)|
| `shadowedEntity` | `FamixTShadower` | `shadowingEntity` | `FamixTShadowable` | Entity that is been shadowed by myself in my defining scope.|
| `shadowingEntity` | `FamixTShadowable` | `shadowedEntity` | `FamixTShadower` | Entity shadowing me in my defining scope.|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|
| `typedEntities` | `FamixTType` | `declaredType` | `FamixTTypedEntity` | Entities that have this type as declaredType|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isMetaclass` | `Boolean` | nil | Whether this class is a metaclass|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|

"
Class {
	#name : 'FamixPythonClass',
	#superclass : 'FamixPythonType',
	#traits : 'FamixTClass + FamixTImportable + FamixTShadowable + FamixTShadower + FamixTWithAccesses + FamixTWithAnnotationInstances + FamixTWithLambdas + FamixTWithReferences',
	#classTraits : 'FamixTClass classTrait + FamixTImportable classTrait + FamixTShadowable classTrait + FamixTShadower classTrait + FamixTWithAccesses classTrait + FamixTWithAnnotationInstances classTrait + FamixTWithLambdas classTrait + FamixTWithReferences classTrait',
	#instVars : [
		'#instancedClasses => FMMany type: #FamixPythonClass opposite: #metaclass',
		'#isMetaclass => FMProperty',
		'#metaclass => FMOne type: #FamixPythonClass opposite: #instancedClasses'
	],
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonClass class >> annotation [

	<FMClass: #Class super: #FamixPythonType>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'adding' }
FamixPythonClass >> addInstancedClass: anObject [
	<generated>
	^ self instancedClasses add: anObject
]

{ #category : 'accessing' }
FamixPythonClass >> instancedClasses [
	"Relation named: #instancedClasses type: #FamixPythonClass opposite: #metaclass"

	<generated>
	<derived>
	^ instancedClasses
]

{ #category : 'accessing' }
FamixPythonClass >> instancedClasses: anObject [

	<generated>
	instancedClasses value: anObject
]

{ #category : 'accessing' }
FamixPythonClass >> isMetaclass [

	<FMProperty: #isMetaclass type: #Boolean>
	<generated>
	<FMComment: 'Whether this class is a metaclass'>
	^ isMetaclass
]

{ #category : 'accessing' }
FamixPythonClass >> isMetaclass: anObject [
	<generated>
	isMetaclass := anObject
]

{ #category : 'accessing' }
FamixPythonClass >> metaclass [
	"Relation named: #metaclass type: #FamixPythonClass opposite: #instancedClasses"

	<generated>
	^ metaclass
]

{ #category : 'accessing' }
FamixPythonClass >> metaclass: anObject [

	<generated>
	metaclass := anObject
]
