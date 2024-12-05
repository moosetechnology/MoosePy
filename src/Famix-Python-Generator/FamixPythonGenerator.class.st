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
		'unknownImportedEntity',
		'unknownAccessedOrReferencedEntity',
		'unknowAccessOrReference',
		'lambda'
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
	implicitVariable := builder newClassNamed: #ImplicitVariable.
	import := builder newClassNamed: #Import.
	indexedFileAnchor := builder newClassNamed: #IndexedFileAnchor.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	lambda := builder newClassNamed: #Lambda.
	localVariable := builder newClassNamed: #LocalVariable.
	method := builder newClassNamed: #Method.
	module := builder newClassNamed: #Module.
	package := builder newClassNamed: #Package.
	parameter := builder newClassNamed: #Parameter.
	primitiveType := builder newClassNamed: #PrimitiveType.
	reference := builder newClassNamed: #Reference.
	type := builder newClassNamed: #Type.
	globalVariable := builder newClassNamed: #GlobalVariable.
	unknownImportedEntity := builder newClassNamed: #UnknownImportedEntity.
	unknownAccessedOrReferencedEntity := builder newClassNamed: #UnknownAccessedOrReferencedEntity.
	unknowAccessOrReference := builder newClassNamed: #UnknowAccessOrReference 
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

	method --|> containerEntity.
	method --|> #TMethod.
	method --|> #TWithComments.
	method --|> #TImportable.
	method --|> #TWithInvocations.
	method --|> #TWithFunctions.
	method --|> #TInvocable.
	method --|> #TWithAnnotationInstances.
	method --|> #THasKind.
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

	parameter --|> namedEntity.
	parameter --|> #TParameter.
	parameter --|> #TWithComments.

	primitiveType --|> type.
	primitiveType --|> #TPrimitiveType.

	reference --|> #TReference.

	type --|> containerEntity.
	type --|> #TType.
	
	unknownImportedEntity --|> containerEntity.
	unknownImportedEntity --|> #TImportable.
	unknownImportedEntity--|> #TPackageable .
	
	unknownAccessedOrReferencedEntity --|> namedEntity.
	
	unknowAccessOrReference --|> #TAssociation
]

{ #category : 'definition' }
FamixPythonGenerator >> defineProperties [

	super defineProperties.

	(import property: #alias type: #String) comment: 'Alias of the imported entity in the scope of the import'.
	
	(class property: #isMetaclass type: #Boolean) comment: 'Whether this class is a metaclass'
]

{ #category : 'definition' }
FamixPythonGenerator >> defineRelations [

	super defineRelations.

	((class property: #metaclass) comment: '') *- ((class property: #instancedClasses) comment: '').

	(unknowAccessOrReference property: #accessorOrReferencer) source *- (containerEntity property: #unknowAccessesOrReferences).

	(unknowAccessOrReference property: #unknownEntity) target *- (unknownAccessedOrReferencedEntity property: #accessesOrReferences)
]
