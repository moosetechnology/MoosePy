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
| `metaclassUsage` | `FamixPythonClass` | `user` | `FamixPythonMetaclassUsage` | |
| `outgoingInvocations` | `FamixTWithInvocations` | `sender` | `FamixTInvocation` | Outgoing invocations sent by this behaviour.|
| `outgoingReferences` | `FamixTWithReferences` | `referencer` | `FamixTReference` | References from this entity to other entities.|
| `superInheritances` | `FamixTWithInheritances` | `subclass` | `FamixTInheritance` | Superinheritance relationships, i.e. known superclasses of this type.|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|
| `incomingReferences` | `FamixTReferenceable` | `referredEntity` | `FamixTReference` | References to this entity by other entities.|
| `subInheritances` | `FamixTWithInheritances` | `superclass` | `FamixTInheritance` | Subinheritance relationships, i.e. known subclasses of this type.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `annotationInstances` | `FamixTWithAnnotationInstances` | `annotatedEntity` | `FamixTAnnotationInstance` | This property corresponds to the set of annotations associated to the entity|
| `receivingInvocations` | `FamixTInvocationsReceiver` | `receiver` | `FamixTInvocation` | List of invocations performed on this entity (considered as the receiver)|
| `shadowedEntity` | `FamixTShadower` | `shadowingEntities` | `FamixTShadowable` | Entity that is been shadowed by myself in my defining scope.|
| `shadowingEntities` | `FamixTShadowable` | `shadowedEntity` | `FamixTShadower` | Entities shadowing me in my defining scope.|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|
| `typedEntities` | `FamixTType` | `declaredType` | `FamixTTypedEntity` | Entities that have this type as declaredType|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|

"
Class {
	#name : 'FamixPythonClass',
	#superclass : 'FamixPythonType',
	#traits : 'FamixTClass + FamixTImportable + FamixTShadowable + FamixTShadower + FamixTWithAccesses + FamixTWithAnnotationInstances + FamixTWithInvocations + FamixTWithLambdas + FamixTWithReferences',
	#classTraits : 'FamixTClass classTrait + FamixTImportable classTrait + FamixTShadowable classTrait + FamixTShadower classTrait + FamixTWithAccesses classTrait + FamixTWithAnnotationInstances classTrait + FamixTWithInvocations classTrait + FamixTWithLambdas classTrait + FamixTWithReferences classTrait',
	#instVars : [
		'#metaclassUsage => FMOne type: #FamixPythonMetaclassUsage opposite: #user'
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

{ #category : 'accessing' }
FamixPythonClass >> metaclassUsage [
	"Relation named: #metaclassUsage type: #FamixPythonMetaclassUsage opposite: #user"

	<generated>
	<derived>
	^ metaclassUsage
]

{ #category : 'accessing' }
FamixPythonClass >> metaclassUsage: anObject [

	<generated>
	metaclassUsage := anObject
]
