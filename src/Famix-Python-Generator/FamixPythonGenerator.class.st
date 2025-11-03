Class {
	#name : 'FamixPythonGenerator',
	#superclass : 'FamixBasicInfrastructureGenerator',
	#instVars : [
		'package',
		'containerEntity',
		'class',
		'type',
		'attribute',
		'method',
		'parameter',
		'primitiveType',
		'reference',
		'invocation',
		'localVariable',
		'access',
		'implicitVariable',
		'import',
		'inheritance',
		'function',
		'module',
		'indexedFileAnchor',
		'globalVariable',
		'unknowAccessOrReference',
		'lambda',
		'unknownEntity',
		'metaclass',
		'metaclassUsage'
	],
	#category : 'Famix-Python-Generator',
	#package : 'Famix-Python-Generator'
}

{ #category : 'accessing' }
FamixPythonGenerator class >> packageName [

	^ #'Famix-Python-Entities'
]

{ #category : 'accessing' }
FamixPythonGenerator class >> prefix [

	^ #FamixPython
]

{ #category : 'definition' }
FamixPythonGenerator >> defineClasses [

	super defineClasses.

	access := builder newClassNamed: #Access.
	attribute := builder newClassNamed: #Attribute.
	class := builder newClassNamed: #Class.
	containerEntity := builder newAbstractClassNamed: #ContainerEntity.
	function := builder newClassNamed: #Function.
	globalVariable := builder newClassNamed: #GlobalVariable.
	implicitVariable := builder newClassNamed: #ImplicitVariable.
	import := builder newClassNamed: #Import.
	indexedFileAnchor := builder newClassNamed: #IndexedFileAnchor.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	lambda := builder newClassNamed: #Lambda.
	localVariable := builder newClassNamed: #LocalVariable.
	metaclass := builder newClassNamed: #Metaclass.
	metaclassUsage := builder newClassNamed: #MetaclassUsage.
	method := builder newClassNamed: #Method.
	module := builder newClassNamed: #Module.
	package := builder newClassNamed: #Package.
	parameter := builder newClassNamed: #Parameter.
	primitiveType := builder newClassNamed: #PrimitiveType.
	reference := builder newClassNamed: #Reference.
	type := builder newClassNamed: #Type.
	unknowAccessOrReference := builder newClassNamed: #UnknowAccessOrReference.
	unknownEntity := builder newClassNamed: #UnknownEntity
]

{ #category : 'definition' }
FamixPythonGenerator >> defineHierarchy [

	super defineHierarchy.

	access --|> #TAccess.

	attribute --|> namedEntity.
	attribute --|> #TAttribute.
	attribute --|> #TInvocationsReceiver.
	attribute --|> #TWithComments.
	attribute --|> #TCanBeClassSide.

	class --|> type.
	class --|> #TClass.
	class --|> #TImportable.
	class --|> #TWithAnnotationInstances.
	class --|> #TWithLambdas.
	class --|> #TShadowable.
	class --|> #TShadower.
	class --|> #TWithAccesses.  
	class --|> #TWithReferences. 
	class --|> #TWithInvocations.

	containerEntity --|> namedEntity.
	containerEntity --|> #TWithClasses.
	containerEntity --|> #TWithImports.

	function --|> containerEntity.
	function --|> #TFunction.
	function --|> #TWithComments.
	function --|> #TImportable.
	function --|> #TWithImplicitVariables.
	function --|> #TWithInvocations.
	function --|> #TWithFunctions.
	function --|> #TWithAnnotationInstances.
	function --|> #TShadowable.
	function --|> #TShadower.
	function --|> #TWithLambdas.
	function --|> #TReferenceable.
	
	lambda --|> containerEntity.
	lambda --|> #TLambda.
	lambda --|> #TWithComments.
	lambda --|> #TWithImplicitVariables.
	lambda --|> #TWithInvocations.
	lambda --|> #TWithLambdas.
	lambda --|> #TWithAccesses.  
	
	globalVariable --|> namedEntity.
	globalVariable --|> #TGlobalVariable.
	globalVariable --|> #TInvocationsReceiver.
	globalVariable --|> #TImportable.
	globalVariable --|> #TShadowable.
	globalVariable --|> #TShadower.
	globalVariable --|> #TWithComments.

	implicitVariable --|> namedEntity.
	implicitVariable --|> #TImplicitVariable.
	implicitVariable --|> #TInvocationsReceiver.

	import --|> #TImport.

	indexedFileAnchor --|> sourceAnchor.
	indexedFileAnchor --|> #TIndexedFileNavigation.

	inheritance --|> #TInheritance.

	invocation --|> #TInvocation.

	localVariable --|> namedEntity.
	localVariable --|> #TLocalVariable.
	localVariable --|> #TCanBeFinal.
	localVariable --|> #TInvocationsReceiver.
	localVariable --|> #TWithComments.
	localVariable --|> #TShadowable.
	localVariable --|> #TShadower.
	
	metaclass --|> class.
	
	metaclassUsage --|> #TAssociation.

	method --|> containerEntity.
	method --|> #TMethod.
	method --|> #TWithComments.
	method --|> #TImportable.
	method --|> #TWithInvocations.
	method --|> #TWithFunctions.
	method --|> #TInvocable.
	method --|> #TWithAnnotationInstances.
	method --|> #TWithLambdas.

	module --|> containerEntity.
	module --|> #TModule.
	module --|> #TPackageable.
	module --|> #TWithComments.
	module --|> #TImportable.
	module --|> #TWithFunctions.
	module --|> #TWithInvocations.
	module --|> #TWithGlobalVariables.
	module --|> #TWithLambdas.
	module --|> #TWithAccesses. 
	module --|> #TWithReferences.
	module --|> #TReferenceable. 
	module --|> #TWithLocalVariables.

	namedEntity --|> sourcedEntity.
	namedEntity --|> #TInvocationsReceiver.
	namedEntity --|> #TEntityMetaLevelDependency.

	package --|> containerEntity.
	package --|> #TPackage.
	package --|> #TPackageable.
	package --|> #TWithComments.
	package --|> #TImportable.
	package --|> #TWithGlobalVariables.
	package --|> #TWithFunctions.
	package --|> #TWithLambdas.
	package --|> #TWithAccesses.
	package --|> #TWithReferences.
	package --|> #TReferenceable.
	package --|> #TWithInvocations.

	parameter --|> namedEntity.
	parameter --|> #TParameter.
	parameter --|> #TWithComments.

	primitiveType --|> type.
	primitiveType --|> #TPrimitiveType.

	reference --|> #TReference.

	type --|> containerEntity.
	type --|> #TType.
	
	unknownEntity --|> namedEntity.
	unknownEntity --|> #TImportable.
	unknownEntity --|> #TPackageable.
	unknownEntity --|> #TInvocable.
	unknownEntity --|> #TPackage. "Sometimes we know later it can be a package and we use this info"
	
	unknowAccessOrReference --|> #TAssociation
]

{ #category : 'definition' }
FamixPythonGenerator >> defineProperties [

	super defineProperties.

	(import property: #alias type: #String) comment: 'Alias of the imported entity in the scope of the import'.
	(import property: #isFromImport type: #Boolean) comment: 'There are two types of imports in python. `import x` and `from y import x`. A From import is the second type.'
]

{ #category : 'definition' }
FamixPythonGenerator >> defineRelations [

	super defineRelations.

	(unknowAccessOrReference property: #accessorOrReferencer) source *- (containerEntity property: #unknowAccessesOrReferences).
	(unknowAccessOrReference property: #unknownEntity) target *- (unknownEntity property: #accessesOrReferences).

	(metaclassUsage property: #user) source - (class property: #metaclassUsage).
	(metaclassUsage property: #metaclass) target *- (metaclass property: #metaclassUsers)
]

{ #category : 'definition' }
FamixPythonGenerator >> newBuilder [

	^ super newBuilder
		  withFileImport;
		  yourself
]
