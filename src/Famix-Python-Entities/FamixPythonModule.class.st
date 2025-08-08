"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentPackage` | `FamixTPackageable` | `childEntities` | `FamixTPackage` | Package containing the entity in the code structure (if applicable)|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `comments` | `FamixTWithComments` | `commentedEntity` | `FamixTComment` | List of comments for the entity|
| `functions` | `FamixTWithFunctions` | `functionOwner` | `FamixTFunction` | Functions defined in the container, if any.|
| `globalVariables` | `FamixTWithGlobalVariables` | `parentScope` | `FamixTGlobalVariable` | Global variables defined in the scope, if any.|
| `lambdas` | `FamixTWithLambdas` | `lambdaContainer` | `FamixTLambda` | Lambdas defined in the container, if any.|
| `localVariables` | `FamixTWithLocalVariables` | `parentBehaviouralEntity` | `FamixTLocalVariable` | Variables locally defined by this behaviour.|
| `moduleEntities` | `FamixTModule` | `parentModule` | `FamixTDefinedInModule` | |

### Outgoing dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `accesses` | `FamixTWithAccesses` | `accessor` | `FamixTAccess` | Accesses to variables made by this behaviour.|
| `outgoingInvocations` | `FamixTWithInvocations` | `sender` | `FamixTInvocation` | Outgoing invocations sent by this behaviour.|
| `outgoingReferences` | `FamixTWithReferences` | `referencer` | `FamixTReference` | References from this entity to other entities.|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|
| `incomingReferences` | `FamixTReferenceable` | `referredEntity` | `FamixTReference` | References to this entity by other entities.|



"
Class {
	#name : 'FamixPythonModule',
	#superclass : 'FamixPythonContainerEntity',
	#traits : 'FamixTImportable + FamixTModule + FamixTPackageable + FamixTReferenceable + FamixTWithAccesses + FamixTWithComments + FamixTWithFunctions + FamixTWithGlobalVariables + FamixTWithInvocations + FamixTWithLambdas + FamixTWithLocalVariables + FamixTWithReferences',
	#classTraits : 'FamixTImportable classTrait + FamixTModule classTrait + FamixTPackageable classTrait + FamixTReferenceable classTrait + FamixTWithAccesses classTrait + FamixTWithComments classTrait + FamixTWithFunctions classTrait + FamixTWithGlobalVariables classTrait + FamixTWithInvocations classTrait + FamixTWithLambdas classTrait + FamixTWithLocalVariables classTrait + FamixTWithReferences classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonModule class >> annotation [

	<FMClass: #Module super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
