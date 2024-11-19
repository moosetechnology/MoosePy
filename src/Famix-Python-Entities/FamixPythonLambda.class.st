"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `lambdaContainer` | `FamixTLambda` | `lambdas` | `FamixTWithLambdas` | The container defining the lambda expression. The lambda is placed in a container, because certain languages can nest lambdas in lambdas.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `comments` | `FamixTWithComments` | `commentedEntity` | `FamixTComment` | List of comments for the entity|
| `implicitVariables` | `FamixTWithImplicitVariables` | `parentBehaviouralEntity` | `FamixTImplicitVariable` | Implicit variables used locally by this behaviour.|
| `lambdas` | `FamixTWithLambdas` | `lambdaContainer` | `FamixTLambda` | Lambdas defined in the container, if any.|
| `localVariables` | `FamixTWithLocalVariables` | `parentBehaviouralEntity` | `FamixTLocalVariable` | Variables locally defined by this behaviour.|
| `parameters` | `FamixTWithParameters` | `parentBehaviouralEntity` | `FamixTParameter` | List of formal parameters declared by this behaviour.|

### Outgoing dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accesses` | `FamixTWithAccesses` | `accessor` | `FamixTAccess` | Accesses to variables made by this behaviour.|
| `outgoingInvocations` | `FamixTWithInvocations` | `sender` | `FamixTInvocation` | Outgoing invocations sent by this behaviour.|
| `outgoingReferences` | `FamixTWithReferences` | `referencer` | `FamixTReference` | References from this entity to other entities.|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingInvocations` | `FamixTInvocable` | `candidates` | `FamixTInvocation` | Incoming invocations from other behaviours computed by the candidate operator.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `sourceAnchor` | `FamixTSourceEntity` | `element` | `FamixTSourceAnchor` | SourceAnchor entity linking to the original source code for this entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isStub` | `Boolean` | false | Flag true if the entity attributes are incomplete, either because the entity is missing or not imported.|
| `signature` | `String` | nil | Signature of the message being sent|

"
Class {
	#name : 'FamixPythonLambda',
	#superclass : 'FamixPythonContainerEntity',
	#traits : 'FamixTLambda + FamixTWithAccesses + FamixTWithComments + FamixTWithImplicitVariables + FamixTWithInvocations + FamixTWithLambdas',
	#classTraits : 'FamixTLambda classTrait + FamixTWithAccesses classTrait + FamixTWithComments classTrait + FamixTWithImplicitVariables classTrait + FamixTWithInvocations classTrait + FamixTWithLambdas classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonLambda class >> annotation [

	<FMClass: #Lambda super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
