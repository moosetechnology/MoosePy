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
		'annotationInstance',
		'annotationType'
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
	annotationInstance := builder newClassNamed: #AnnotationInstance.
	annotationType := builder newClassNamed: #AnnotationType.
	attribute := builder newClassNamed: #Attribute.
	class := builder newClassNamed: #Class.
	containerEntity := builder newAbstractClassNamed: #ContainerEntity.
	function := builder newClassNamed: #Function.
	implicitVariable := builder newClassNamed: #ImplicitVariable.
	import := builder newClassNamed: #Import.
	indexedFileAnchor := builder newClassNamed: #IndexedFileAnchor.
	inheritance := builder newClassNamed: #Inheritance.
	invocation := builder newClassNamed: #Invocation.
	localVariable := builder newClassNamed: #LocalVariable.
	method := builder newClassNamed: #Method.
	module := builder newClassNamed: #Module.
	package := builder newClassNamed: #Package.
	parameter := builder newClassNamed: #Parameter.
	primitiveType := builder newClassNamed: #PrimitiveType.
	reference := builder newClassNamed: #Reference.
	type := builder newClassNamed: #Type
]

{ #category : 'definition' }
FamixPythonGenerator >> defineHierarchy [

	super defineHierarchy.

	access --|> #TAccess.
	
	annotationInstance --|> #TAnnotationInstance.
	annotationInstance --|> #TTypedAnnotationInstance.
	annotationType --|> #TAnnotationType.
	annotationType --|> namedEntity.

	attribute --|> namedEntity.
	attribute --|> #TAttribute.
	attribute --|> #TInvocationsReceiver.
	attribute --|> #TWithComments.

	class --|> type.
	class --|> #TClass.
	class --|> #TWithImports.
	class --|> #TImportable.
	class --|> #TWithAnnotationInstances.

	containerEntity --|> namedEntity.
	containerEntity --|> #TWithClasses.

	function --|> containerEntity.
	function --|> #TFunction.
	function --|> #TWithComments.
	function --|> #TInvocable.
	function --|> #TImportable.
	function --|> #TWithImplicitVariables.
	function --|> #TWithInvocations.
	function --|> #TWithFunctions.
	function --|> #TInvocable.
	function --|> #TWithAnnotationInstances.

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

	module --|> containerEntity.
	module --|> #TModule.
	module --|> #TPackageable.
	module --|> #TWithComments.
	module --|> #TImportable.
	module --|> #TWithImports.
	module --|> #TWithFunctions.
	module --|> #TWithInvocations.

	namedEntity --|> sourcedEntity.
	namedEntity --|> #TInvocationsReceiver.
	namedEntity --|> #TEntityMetaLevelDependency.

	package --|> containerEntity.
	package --|> #TPackage.
	package --|> #TPackageable.
	package --|> #TWithComments.
	package --|> #TImportable.

	parameter --|> namedEntity.
	parameter --|> #TParameter.
	parameter --|> #TWithComments.

	primitiveType --|> type.
	primitiveType --|> #TPrimitiveType.

	reference --|> #TReference.

	type --|> containerEntity.
	type --|> #TType.
	type --|> #TWithMethods
]

{ #category : 'definition' }
FamixPythonGenerator >> defineProperties [

	super defineProperties.

	(import property: #fromName type: #String) comment: '"from a import b", fromName is a'.
	(import property: #entityName type: #String) comment: '"from a import b", entityName is b'.
	(import property: #asName type: #String) comment: '"import b as c", asName is c'.
	
	(class property: #isMetaclass type: #Boolean) comment: 'Whether this class is a metaclass'
]

{ #category : 'definition' }
FamixPythonGenerator >> defineRelations [

	super defineRelations.

	((class property: #metaclass) comment: '')
	*- ((class property: #instancedClasses) comment: '')
]
