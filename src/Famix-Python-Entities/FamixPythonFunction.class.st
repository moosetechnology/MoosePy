"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `functionOwner` | `FamixTFunction` | `functions` | `FamixTWithFunctions` | The container defining the function. The function is placed in a container, because certain languages can nest functions in functions.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `comments` | `FamixTWithComments` | `commentedEntity` | `FamixTComment` | List of comments for the entity|
| `functions` | `FamixTWithFunctions` | `functionOwner` | `FamixTFunction` | Functions defined in the container, if any.|
| `implicitVariables` | `FamixTWithImplicitVariables` | `parentBehaviouralEntity` | `FamixTImplicitVariable` | Implicit variables used locally by this behaviour.|
| `localVariables` | `FamixTWithLocalVariables` | `parentBehaviouralEntity` | `FamixTLocalVariable` | Variables locally defined by this behaviour.|
| `parameters` | `FamixTWithParameters` | `parentBehaviouralEntity` | `FamixTParameter` | List of formal parameters declared by this behaviour.|

### Outgoing dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accesses` | `FamixTWithAccesses` | `accessor` | `FamixTAccess` | Accesses to variables made by this behaviour.|
| `outgoingImports` | `FamixTWithImports` | `importingEntity` | `FamixTImport` | |
| `outgoingInvocations` | `FamixTWithInvocations` | `sender` | `FamixTInvocation` | Outgoing invocations sent by this behaviour.|
| `outgoingReferences` | `FamixTWithReferences` | `referencer` | `FamixTReference` | References from this entity to other entities.|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|
| `incomingInvocations` | `FamixTInvocable` | `candidates` | `FamixTInvocation` | Incoming invocations from other behaviours computed by the candidate operator.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `annotationInstances` | `FamixTWithAnnotationInstances` | `annotatedEntity` | `FamixTAnnotationInstance` | This property corresponds to the set of annotations associated to the entity|
| `declaredType` | `FamixTTypedEntity` | `typedEntities` | `FamixTType` | Type of the entity, if any|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `signature` | `String` | nil | Signature of the message being sent|

"
Class {
	#name : 'FamixPythonFunction',
	#superclass : 'FamixPythonContainerEntity',
	#traits : 'FamixTFunction + FamixTImportable + FamixTInvocable + FamixTWithAnnotationInstances + FamixTWithComments + FamixTWithFunctions + FamixTWithImplicitVariables + FamixTWithImports + FamixTWithInvocations',
	#classTraits : 'FamixTFunction classTrait + FamixTImportable classTrait + FamixTInvocable classTrait + FamixTWithAnnotationInstances classTrait + FamixTWithComments classTrait + FamixTWithFunctions classTrait + FamixTWithImplicitVariables classTrait + FamixTWithImports classTrait + FamixTWithInvocations classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonFunction class >> annotation [

	<FMClass: #Function super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
