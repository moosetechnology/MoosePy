Class {
	#name : 'FamixPythonProject1Test',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonProject1Test class >> resources [

	^ { FamixPythonProject1TestResource }
]

{ #category : 'accessing' }
FamixPythonProject1Test >> model [

	^ FamixPythonProject1TestResource current model
]

{ #category : 'tests - unknown access or reference' }
FamixPythonProject1Test >> testAccessOrReferenceToStubEntity [

	| stub module access |
	stub := self unknownEntityNamed: 'MissingClass'.
	module := self moduleNamed: 'moduleWithRelativeFromImportStub'.

	access := stub accessesOrReferences detect: [ :anAccess | anAccess accessorOrReferencer = module ].

	self assert: access class equals: FamixPythonUnknowAccessOrReference.
	self assert: access source equals: module.
	self assert: access accessorOrReferencer equals: module.
	self assert: access target equals: stub.
	self assert: access unknownEntity equals: stub.
	self assert: (module unknowAccessesOrReferences anySatisfy: [ :anAccess | anAccess unknownEntity = stub ])
]

{ #category : 'tests - unknown access or reference' }
FamixPythonProject1Test >> testAccessOrReferenceToStubEntitySourceAnchor [

	| stub module access |
	stub := self unknownEntityNamed: 'MissingClass'.
	module := self moduleNamed: 'moduleWithRelativeFromImportStub'.

	access := stub accessesOrReferences detect: [ :anAccess | anAccess accessorOrReferencer = module ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'MissingClass'
]

{ #category : 'tests' }
FamixPythonProject1Test >> testAllSourcedEntitiesNotSubHaveSourceAnchor [
	"We have no source in case we inherit from Object."

	(self model allUsing: FamixTSourceEntity)
		reject: [ :entity | entity isStub or: [ entity isInheritance and: [ entity target name = 'object' ] ] ]
		thenDo: [ :entity | self assert: entity sourceAnchor isNotNil ]
]

{ #category : 'tests' }
FamixPythonProject1Test >> testAssociationsSourcesAreNeverStub [

	(self model allUsing: FamixTAssociation) do: [ :association | self deny: association source isStub ]
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsClassFromAModule [

	| class class1 import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	class1 := self classNamed: 'Person'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: class1.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsClassFromAPackage [

	| class class1 import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	class1 := self classNamed: 'Room'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: class1.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsFunctionFromAModule [

	| class function import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	function := self functionNamed: 'sort_list'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsFunctionFromAPackage [

	| class function import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	function := self functionNamed: 'return2'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsGlobalVariableFromAModule [

	| class global import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsGlobalVariableFromAPackage [

	| class global import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Employee'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testClassImportsModule [

	| class import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'Person'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import moduleAtRoot3'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsModuleFrom [

	| class module import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'ClassImportingModule'.
	module := self moduleNamed: 'moduleToTestSourceAnchor'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'moduleToTestSourceAnchor' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: module.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import moduleToTestSourceAnchor'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testClassImportsPackageFrom [

	| class package import |
	self denyEmpty: self model allImports.
	class := self classNamed: 'ClassImportingPackage'.
	package := self packageNamed: 'subpackageInRoot2'.
	import := class outgoingImports detect: [ :pimport | pimport target name = 'subpackageInRoot2' ].

	self assert: import importingEntity equals: class.
	self assert: import importedEntity equals: package.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2 import subpackageInRoot2'
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassInClass [

	| class |
	class := self classNamed: 'ClassInClass'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'ClassInClass'.
	self assert: class typeContainer equals: (self classNamed: 'ClassWithClasses')
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassInFunction [

	| class |
	class := self classNamed: 'ClassInFunction'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'ClassInFunction'.
	self assert: class typeContainer equals: (self functionNamed: 'function_with_class_inside')
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassInMethod [

	| class |
	class := self classNamed: 'ClassInMethod'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'ClassInMethod'.
	self assert: class typeContainer equals: ((self classNamed: 'ClassWithClasses') methods detect: #isConstructor) 
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassInModule [

	| class |
	class := self classNamed: 'ClassWithClasses'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'ClassWithClasses'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleWithClasses')
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassInPackage [

	| class |

	class := self classNamed: 'ClassInSubpackage'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'ClassInSubpackage'.
	self assert: class typeContainer equals: (self packageNamed: 'subpackage1')
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceFromClass [

	| class class2 reference |
	class := self classNamed: 'AClassToReference'.
	class2 := self classNamed: 'AClassReferencingAClass'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = class2 ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: class2.
	self assert: reference referencer equals: class2.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (class2 outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceFromFunction [

	| class function reference |
	class := self classNamed: 'AClassToReference'.
	function := self functionNamed: 'function_referencing_class'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = function ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: function.
	self assert: reference referencer equals: function.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (function outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceFromLambda [

	| class lambda reference |
	class := self classNamed: 'AClassToReference'.
	lambda := (self functionNamed: 'function_with_lambda_referencing_class') lambdas anyOne.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = lambda ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: lambda.
	self assert: reference referencer equals: lambda.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (lambda outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceFromMethod [

	| class method reference |
	class := self classNamed: 'AClassToReference'.
	method := self methodNamed: 'method_referencing_class'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = method ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: method.
	self assert: reference referencer equals: method.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (method outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceFromModule [

	| class module reference |
	class := self classNamed: 'Student'.
	module := self moduleNamed: 'moduleAtRoot2'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = module ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceFromPackage [

	| class package reference |
	class := self classNamed: 'Room'.
	package := self packageNamed: 'subsubpackage1'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = package ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: package.
	self assert: reference referencer equals: package.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (package outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceOfImportedEntity [

	| class module reference |
	class := self classNamed: 'Person'.
	module := self moduleNamed: 'moduleAtRoot5'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceOfImportedEntityViaAlias [

	| class module reference |
	class := self classNamed: 'Employee'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceOfImportedEntityViaAliasSourceAnchor [

	| class module reference |
	class := self classNamed: 'Employee'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'Emp'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testClassReferenceSourceAnchor [

	| class package reference |
	class := self classNamed: 'Room'.
	package := self packageNamed: 'subsubpackage1'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = package ]) detectMax: [ :aReference | aReference sourceAnchor startPos ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'Room'
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testClassShadowedByClass [

	| shadower shadowed |
	shadower := (self model allClasses select: [ :entity | entity name = 'ClassShadowedByOtherClass' ]) asOrderedCollection detectMax: [ :entity |
		            entity sourceAnchor startPos ].
	shadowed := (self model allClasses select: [ :entity | entity name = 'ClassShadowedByOtherClass' ]) asOrderedCollection detectMin: [ :entity |
		            entity sourceAnchor startPos ].

	self assert: shadower name equals: 'ClassShadowedByOtherClass'.
	self deny: shadower isShadowed.
	self assert: shadower typeContainer equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'class ClassShadowedByOtherClass:

    def __init__(self):
        self.i_var_of_shadowed_class = 3' withPlatformLineEndings.

	self assert: shadowed name equals: 'ClassShadowedByOtherClass'.
	self assert: shadowed isShadowed.
	self assert: shadowed typeContainer equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'class ClassShadowedByOtherClass:
    c_var_of_shadowed_class = True' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testClassShadowedByFunction [

	| shadower shadowed |
	shadower := self functionNamed: 'shadowedName'.
	shadowed := self classNamed: 'shadowedName'.

	self assert: shadower name equals: 'shadowedName'.
	self deny: shadower isShadowed.
	self assert: shadower functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'def shadowedName():
    print("I''m the last one so I win")' withPlatformLineEndings.

	self assert: shadowed name equals: 'shadowedName'.
	self assert: shadowed isShadowed.
	self assert: shadowed typeContainer equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'class shadowedName:
    shadowedNameVar = 2' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testClassShadowedByGlobal [

	| shadower shadowed |
	shadower := self globalVariableNamed: 'ClassShadowedByGlobal'.
	shadowed := self classNamed: 'ClassShadowedByGlobal'.

	self assert: shadower name equals: 'ClassShadowedByGlobal'.
	self deny: shadower isShadowed.
	self assert: shadower parentScope equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'ClassShadowedByGlobal'.

	self assert: shadowed name equals: 'ClassShadowedByGlobal'.
	self assert: shadowed isShadowed.
	self assert: shadowed typeContainer equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'class ClassShadowedByGlobal:
    pass' withPlatformLineEndings
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariableAreDefinedOnlyOnce [
	"We should have only one ivar even if it is assigned multiple times."

	self assert: (self model allAttributes select: [ :attribute | attribute name = 'sound' ]) size equals: 1
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariableNotAtTheBeginningOfTheClass [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'sound'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'sound'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self assert: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariableSourceAnchor [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'sound'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'sound'.
	"The start and end pos should be the one of the first assignation and not the second"
	self assert: variable sourceAnchor startPos equals: 577.
	self assert: variable sourceAnchor endPos equals: 581
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariablesAssignedWithATuple [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'cvarTuple1'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'cvarTuple1'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self assert: variable isClassSide.

	variable := self attributeNamed: 'cvarTuple2'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'cvarTuple2'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self assert: variable isClassSide.

	variable := self attributeNamed: 'cvarTuple3'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'cvarTuple3'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self assert: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testClassVariablesWithSameNameButDifferenClass [

	| variables |
	variables := self model allAttributes select: [ :variable | variable name = 'furniture_color' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self classNamed: 'Chair').
			(self classNamed: 'Stool') }
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testClassesWithSameNameButDifferentParents [

	| classes |
	classes := self model allClasses select: [ :class | class name = 'ClassWithCommonName' ].

	self assert: classes size equals: 2.
	self assertCollection: (classes collect: #typeContainer) hasSameElements: {
			(self moduleNamed: 'moduleWithClasses').
			(self packageNamed: 'subpackage1') }
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentAfterIvar [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment after ivar' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: ((self classNamed: 'Person') attributes detect: [ :attribute | attribute name = 'age' ])
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentAfterLocal [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment after temp' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self localVariableNamed: 'temp_before_comment')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBeforeClass [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '# Comment before class' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self classNamed: 'Student')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBeforeFunction [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '# Comment before function' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self functionNamed: 'function_with_comment_before')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBeforeGlobale [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment before global' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self globalVariableNamed: 'globalInModuleAtRoot2')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBeforeIVar [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment before ivar' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: ((self classNamed: 'Person') attributes detect: [ :attribute | attribute name = 'name' ])
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBeforeLocal [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment before temp' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self localVariableNamed: 'temp_after_comment')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBeforeMethod [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment before method' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self methodNamed: 'set_name')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentBothBeforeAndAfterAnEntity [
	"In that case, it should got to the entity before it."

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment to attribute to temp 1 and not 2' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self localVariableNamed: 'temp_conflicting_1')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentInClass [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '# Comment in Class' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self classNamed: 'Person')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentInFunction [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '# Comment in function' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self functionNamed: 'function_with_comment_inside')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentInInnerFunction [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '# Comment in inner function' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self functionNamed: 'inner_function_with_comment_inside')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentInMethod [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment in method' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self methodNamed: 'get_name')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentInModule [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment in module at root 2' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self moduleNamed: 'moduleAtRoot2')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testCommentInPackage [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '# The goal of this subpackage is to have the same name as a class in the parent package' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self packageNamed: 'NameOfSubpackageOrClass')
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testConstructor [

	| method |
	self denyEmpty: self model allMethods.

	method := (self classNamed: 'Person') methods detect: [ :m | m name = '__init__' ].

	self assert: method name equals: '__init__'.
	self assert: method isConstructor.

	method := (self classNamed: 'Person') methods detect: [ :m | m name = 'printInfos' ].

	self assert: method name equals: 'printInfos'.
	self deny: method isConstructor
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testDoNotMergeMergeMultiLinesComments [

	| comment comment2 |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
Followed by other multiline
"""' withPlatformLineEndings ].

	comment2 := self model allComments detect: [ :aComment |
		            aComment sourceText beginsWith: '"""
Following
Multiline
Comment
"""' withPlatformLineEndings ].

	self deny: (comment sourceText includesSubstring: 'Following').
	self deny: (comment2 sourceText includesSubstring: 'Followed')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testDoNotMergeMergeSingleAndMultiLinesComments [

	| comment comment2 |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
Before single line
"""' withPlatformLineEndings ].

	comment2 := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Single line comment after multiline' ].

	self deny: (comment sourceText includes: $#).
	self deny: (comment2 sourceText includes: $")
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testFileWithTwoIdenticalImportsProduceTwoImports [

	| module |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleAtRoot2'.
	self assert: (module outgoingImports select: [ :pimport | pimport target name = 'moduleAtRoot' ]) size equals: 2
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFromImportAGlobalWithAnAlias [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	global := self globalVariableNamed: 'moduleAtRoot2Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot2Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import alias equals: 'marv'.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot2 import moduleAtRoot2Variable as marv'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFromImportMultipleElementsWithAliases [

	| module class function import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	class := self classNamed: 'Employee'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'Employee' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: class.
	self assert: import alias equals: 'Emp'.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2.moduleInRootPackage2 import Employee as Emp, functionWithImportsInRoot2 as fwi, Employee2'.

	function := self functionNamed: 'functionWithImportsInRoot2'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'functionWithImportsInRoot2' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2.moduleInRootPackage2 import Employee as Emp, functionWithImportsInRoot2 as fwi, Employee2'.
	
	self assert: import alias equals: 'fwi'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFromImportStubPackages [

	| matplotlib pyglot plot module import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithStubs2'.
	plot := self unknownEntityNamed: 'plot'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'plot' ].

	pyglot := self packageNamed: 'pyplot'.
	matplotlib := pyglot parentPackage.

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: plot.
	self assert: import importedEntity class equals: FamixPythonUnknownEntity.
	self assert: import importedEntity parentPackage equals: pyglot.
	self assert: import importedEntity parentPackage parentPackage equals: matplotlib.
	self assert: import importedEntity isStub.
	self assert: import importedEntity parentPackage isStub.
	self assert: import importedEntity parentPackage parentPackage isStub.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from matplotlib.pyplot import plot'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsClassFromAModule [

	| function class import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	class := self classNamed: 'Person'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsClassFromAPackage [

	| function class import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	class := self classNamed: 'Room'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsFunctionFromAModule [

	| function function1 import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	function1 := self functionNamed: 'sort_list'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: function1.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsFunctionFromAPackage [

	| function function1 import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	function1 := self functionNamed: 'return2'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: function1.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsGlobalVariableFromAModule [

	| function global import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsGlobalVariableFromAPackage [

	| function global import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImportsInRoot2'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testFunctionImportsModule [

	| function import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'functionWithImport'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import moduleAtRoot3'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsModuleFrom [

	| function module import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'function_importing_module'.
	module := self moduleNamed: 'moduleInSubPackage1'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubPackage1' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: module.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1 import moduleInSubPackage1'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testFunctionImportsPackageFrom [

	| function package import |
	self denyEmpty: self model allImports.
	function := self functionNamed: 'function_importing_package'.
	package := self packageNamed: 'subpackageInRoot2'.
	import := function outgoingImports detect: [ :pimport | pimport target name = 'subpackageInRoot2' ].

	self assert: import importingEntity equals: function.
	self assert: import importedEntity equals: package.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2 import subpackageInRoot2'
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionInAFunction [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'inner_function'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'inner_function'.
	self assert: function signature equals: 'inner_function(finput)'.
	self assert: function functionOwner equals: (self functionNamed: 'function_with_inner_function')
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionInAModule [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'functionWithImport'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'functionWithImport'.
	self assert: function signature equals: 'functionWithImport()'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionInAPackage [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'return2'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'return2'.
	self assert: function signature equals: 'return2()'.
	self assert: function functionOwner equals: (self packageNamed: 'subsubpackage1')
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationFromClass [

	| class function invocation |
	function := self functionNamed: 'sort_list'.
	class := self classNamed: 'Employee'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = class ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: class.
	self assert: invocation sender equals: class.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (class outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationFromFunction [

	| function2 function invocation |
	function := self functionNamed: 'sort_list'.
	function2 := self functionNamed: 'functionWithImportsInRoot2'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = function2 ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: function2.
	self assert: invocation sender equals: function2.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (function2 outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationFromLambda [

	| lambda function invocation |
	function := self functionNamed: 'return5'.
	lambda := (self moduleNamed: 'moduleInRootPackage2') lambdas anyOne.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = lambda ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: lambda.
	self assert: invocation sender equals: lambda.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (lambda outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationFromMethod [

	| method function invocation |
	function := self functionNamed: 'sort_list'.
	method := self methodNamed: 'print_info_2'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = method ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: method.
	self assert: invocation sender equals: method.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (method outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationFromModule [

	| module function invocation |
	function := self functionNamed: 'function_printing_arg'.
	module := self moduleNamed: 'moduleAtRoot'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationFromPackage [

	| package function invocation |
	function := self functionNamed: 'function_with_lambda_with_function_ref'.
	package := self packageNamed: 'subsubpackage1'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = package ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: package.
	self assert: invocation sender equals: package.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (package outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationHasSignature [

	| module function invocation |
	function := self functionNamed: 'function_printing_arg'.
	module := self moduleNamed: 'moduleAtRoot'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation signature equals: 'function_printing_arg("Cyril")'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationOfImportedEntity [

	| class function invocation |
	function := self functionNamed: 'return2'.
	class := self classNamed: 'Employee'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = class ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: class.
	self assert: invocation sender equals: class.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (class outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationOfImportedEntityViaAlias [

	| module function invocation |
	function := self functionNamed: 'functionWithImportsInRoot2'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationOfImportedEntityViaAliasSourceAnchor [

	| module function invocation |
	function := self functionNamed: 'functionWithImportsInRoot2'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'fwi()'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationSignatureWithAlias [

	| module function invocation |
	function := self functionNamed: 'functionWithImportsInRoot2'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation signature equals: 'fwi()'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationSourceAnchor [

	| function2 function invocation |
	function := self functionNamed: 'sort_list'.
	function2 := self functionNamed: 'functionWithImportsInRoot2'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = function2 ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'sort_list(x, y)'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationWithNamespaceAndAlias [

	| module function invocation |
	function := self functionNamed: 'sort_list'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationWithNamespaceAndAliasSourceAnchor [

	| module function invocation |
	function := self functionNamed: 'sort_list'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'mar.sort_list(["a", "b", "c", "d", "e", "f", "g", "h", "i"], [0, 1, 1, 0, 1, 2, 2, 0, 1])'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationWithNamespaceOfMultipleLevel [

	| module function invocation |
	function := self functionNamed: 'function_with_function_ref'.
	module := self moduleNamed: 'moduleAtRoot8'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationWithNamespaceOfMultipleLevelAndSpaces [

	| module function invocation |
	function := self functionNamed: 'function_returning_75'.
	module := self moduleNamed: 'moduleAtRoot8'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationWithNamespaceOfMultipleLevelAndSpacesSourceAnchor [

	| module function invocation |
	function := self functionNamed: 'function_returning_75'.
	module := self moduleNamed: 'moduleAtRoot8'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'root2. subpackageInRoot2. function_returning_75()'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testFunctionInvocationWithNamespaceOfMultipleLevelSourceAnchor [

	| module function invocation |
	function := self functionNamed: 'function_with_function_ref'.
	module := self moduleNamed: 'moduleAtRoot8'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'root.subpackage1.subsubpackage1.function_with_function_ref()'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromClass [

	| function class reference |
	function := self functionNamed: 'return2'.
	class := self classNamed: 'ClassWithFunctionReference'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = class ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: class.
	self assert: reference referencer equals: class.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (class outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromFunction [

	| function function2 reference |
	function := self functionNamed: 'return2'.
	function2 := self functionNamed: 'function_with_function_ref'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = function2 ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: function2.
	self assert: reference referencer equals: function2.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (function2 outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromImportedEntity [

	| function module reference |
	function := self functionNamed: 'function_in_module_in_root3'.
	module := self moduleNamed: 'moduleImportingMultipleItems'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = module ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromImportedEntityWithAlias [

	| function module reference |
	function := self functionNamed: 'functionWithImportsInRoot2'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = module ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromImportedEntityWithAliasSourceAnchor [

	| function module reference |
	function := self functionNamed: 'functionWithImportsInRoot2'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = module ]).

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'fwi'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromLambda [

	| function lambda reference |
	function := self functionNamed: 'return2'.
	lambda := (self functionNamed: 'function_with_lambda_with_function_ref') lambdas anyOne.

	reference := function incomingReferences detect: [ :aReference | aReference referencer = lambda ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: lambda.
	self assert: reference referencer equals: lambda.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (lambda outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromMethod [

	| function method reference |
	function := self functionNamed: 'return2'.
	method := self methodNamed: 'method_with_function_ref'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = method ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: method.
	self assert: reference referencer equals: method.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (method outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromModule [

	| function module reference |
	function := self functionNamed: 'sort_list'.
	module := self moduleNamed: 'moduleAtRoot'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = module ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceFromPackage [

	| function package reference |
	function := self functionNamed: 'return2'.
	package := self packageNamed: 'subsubpackage1'.

	reference := (function incomingReferences detect: [ :aReference | aReference referencer = package ]).

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: package.
	self assert: reference referencer equals: package.
	self assert: reference target equals: function.
	self assert: reference referredEntity equals: function.
	self assert: (package outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = function ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testFunctionReferenceSourceAnchor [

	| function package reference |
	function := self functionNamed: 'return2'.
	package := self packageNamed: 'subsubpackage1'.

	reference := function incomingReferences detect: [ :aReference | aReference referencer = package ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'return2'
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testFunctionShadowedByClass [

	| shadower shadowed |
	shadower := self classNamed: 'function_shadowed_by_class'.
	shadowed := self functionNamed: 'function_shadowed_by_class'.

	self assert: shadower name equals: 'function_shadowed_by_class'.
	self deny: shadower isShadowed.
	self assert: shadower typeContainer equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'class function_shadowed_by_class:
    pass' withPlatformLineEndings.

	self assert: shadowed name equals: 'function_shadowed_by_class'.
	self assert: shadowed isShadowed.
	self assert: shadowed functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'def function_shadowed_by_class():
    return 2' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testFunctionShadowedByFunction [

	| shadower shadowed |
	shadower := (self model allFunctions select: [ :entity | entity name = 'function_to_shadow' ]) asOrderedCollection detectMax: [ :entity |
		            entity sourceAnchor startPos ].
	shadowed := (self model allFunctions select: [ :entity | entity name = 'function_to_shadow' ]) asOrderedCollection detectMin: [ :entity |
		            entity sourceAnchor startPos ].

	self assert: shadower name equals: 'function_to_shadow'.
	self deny: shadower isShadowed.
	self assert: shadower functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'def function_to_shadow():
    return 2' withPlatformLineEndings.

	self assert: shadowed name equals: 'function_to_shadow'.
	self assert: shadowed isShadowed.
	self assert: shadowed functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'def function_to_shadow():
    return 1' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testFunctionShadowedByGlobal [

	| shadower shadowed |
	shadower := (self model allGlobalVariables select: [ :entity | entity name = 'global_then_function_then_global_then_class' ]) asOrderedCollection detectMax: [
		            :entity | entity sourceAnchor startPos ].
	shadowed := self functionNamed: 'global_then_function_then_global_then_class'.

	self assert: shadower name equals: 'global_then_function_then_global_then_class'.
	self assert: shadower isShadowed. "<= In that case the shadower is also shadowed later"
	self assert: shadower parentScope equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'global_then_function_then_global_then_class' withPlatformLineEndings.

	self assert: shadowed name equals: 'global_then_function_then_global_then_class'.
	self assert: shadowed isShadowed.
	self assert: shadowed functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'def global_then_function_then_global_then_class():
    print(14)' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testFunctionShadowedByTemporary [

	| shadower shadowed |
	shadower := self localVariableNamed: 'function_with_local_of_same_name'.
	shadowed := self functionNamed: 'function_with_local_of_same_name'.

	self assert: shadower name equals: 'function_with_local_of_same_name'.
	self deny: shadower isShadowed.
	self assert: shadower parentBehaviouralEntity equals: shadowed.
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'function_with_local_of_same_name'.

	self assert: shadowed name equals: 'function_with_local_of_same_name'.
	self assert: shadowed isShadowed.
	self assert: shadowed functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'def function_with_local_of_same_name(init):
    if init > 10:
        return init

    function_with_local_of_same_name = init
    return function_with_local_of_same_name + 3' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testFunctionShadowedTwice [

	| shadower shadower2 shadowed |
	shadower := self localVariableNamed: 'function_shadowed_twice'.
	shadower2 := (self model allFunctions select: [ :entity | entity name = 'function_shadowed_twice' ]) asOrderedCollection detectMax: [ :entity |
		             entity sourceAnchor startPos ].
	shadowed := (self model allFunctions select: [ :entity | entity name = 'function_shadowed_twice' ]) asOrderedCollection detectMin: [ :entity |
		            entity sourceAnchor startPos ].

	self assert: shadower name equals: 'function_shadowed_twice'.
	self deny: shadower isShadowed.
	self assert: shadower parentBehaviouralEntity equals: shadowed.
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'function_shadowed_twice'.

	self assert: shadower2 name equals: 'function_shadowed_twice'.
	self deny: shadower2 isShadowed.
	self assert: shadower2 functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower2 shadowedEntity equals: shadowed.
	self assert: shadower2 sourceText equals: 'def function_shadowed_twice():
    return 4' withPlatformLineEndings.

	self assert: shadowed name equals: 'function_shadowed_twice'.
	self assert: shadowed isShadowed.
	self assert: shadowed functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: {
			shadower.
			shadower2 }.
	self assert: shadowed sourceText equals: 'def function_shadowed_twice(init):
    if init > 10:
        return init

    function_shadowed_twice = init
    return function_shadowed_twice + 3' withPlatformLineEndings
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionSourceAnchor [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'sort_list'.

	self assert: function sourceAnchor isNotNil.
	self assert: function sourceText equals: 'def sort_list(list1, list2):
    zipped_pairs = zip(list2, list1)
    z = [x for _, x in sorted(zipped_pairs)]
    return z' withPlatformLineEndings
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testFunctionsWithSameNameButDifferentParents [

	| functions |
	functions := self model allFunctions select: [ :funct | funct name = 'function_with_common_name' ].

	self assert: functions size equals: 2.
	self assertCollection: (functions collect: #functionOwner) hasSameElements: {
			(self moduleNamed: 'moduleAtRoot6').
			(self packageNamed: 'root') }
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testGetterAndSetter [

	| class getter setter |
	self denyEmpty: self model allMethods.

	class := self classNamed: 'Person'.
	getter := class methods detect: [ :m | m name = 'get_name' ].
	setter := class methods detect: [ :m | m name = 'set_name' ].

	self assert: getter name equals: 'get_name'.
	self assert: getter isGetter.
	self deny: getter isSetter.
	self deny: getter isConstructor.

	self assert: setter name equals: 'set_name'.
	self deny: setter isGetter.
	self assert: setter isSetter.
	self deny: setter isConstructor
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testGlobalShadowedByClass [

	| shadower shadowed |
	shadower := self classNamed: 'global_then_function_then_global_then_class'.
	shadowed := (self model allGlobalVariables select: [ :entity | entity name = 'global_then_function_then_global_then_class' ]) asOrderedCollection detectMax: [
		            :entity | entity sourceAnchor startPos ].

	self assert: shadower name equals: 'global_then_function_then_global_then_class'.
	self deny: shadower isShadowed.
	self assert: shadower typeContainer equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'class global_then_function_then_global_then_class:
    def __init__(self):
        print(16)' withPlatformLineEndings.

	self assert: shadowed name equals: 'global_then_function_then_global_then_class'.
	self assert: shadowed isShadowed.
	self assert: shadowed parentScope equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'global_then_function_then_global_then_class'
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testGlobalShadowedByFunction [

	| shadower shadowed |
	shadower := self functionNamed: 'global_then_function_then_global_then_class'.
	shadowed := (self model allGlobalVariables select: [ :entity | entity name = 'global_then_function_then_global_then_class' ]) asOrderedCollection detectMin: [
		            :entity | entity sourceAnchor startPos ].

	self assert: shadower name equals: 'global_then_function_then_global_then_class'.
	self assert: shadower isShadowed. "<= In that case the shadower is also shadowed later"
	self assert: shadower functionOwner equals: (self moduleNamed: 'moduleWithShadowing').
	self assert: shadower shadowedEntity equals: shadowed.
	self assert: shadower sourceText equals: 'def global_then_function_then_global_then_class():
    print(14)' withPlatformLineEndings.

	self assert: shadowed name equals: 'global_then_function_then_global_then_class'.
	self assert: shadowed isShadowed.
	self assert: shadowed parentScope equals: (self moduleNamed: 'moduleWithShadowing').
	self assertCollection: shadowed shadowingEntities hasSameElements: { shadower }.
	self assert: shadowed sourceText equals: 'global_then_function_then_global_then_class'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableAreDefinedOnlyOnce [
	"We should have only one global even if it is assigned multiple times."

	self assert: (self model allGlobalVariables select: [ :globalVariable | globalVariable name = 'globalAssignedTwice' ]) size equals: 1
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableInModule [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'moduleAtRootVariable'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'moduleAtRootVariable'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot').
	
	self assert: global sourceAnchor isNotNil.
	self assert: global sourceText equals: 'moduleAtRootVariable'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableInPackage [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'rootPackageVariable'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'rootPackageVariable'.
	self assert: global parentScope equals: (self packageNamed: 'root').

	self assert: global sourceAnchor isNotNil.
	self assert: global sourceText equals: 'rootPackageVariable'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariableSourceAnchor [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'moduleAtRootVariable'.

	self assert: global sourceAnchor isNotNil.
	self assert: global sourceText equals: 'moduleAtRootVariable'
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariablesAssignedWithATuple [

	| global |
	self denyEmpty: self model allGlobalVariables.

	global := self globalVariableNamed: 'globalWithTuple1'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'globalWithTuple1'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot').

	global := self globalVariableNamed: 'globalWithTuple2'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'globalWithTuple2'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot').

	global := self globalVariableNamed: 'globalWithTuple3'.

	self assert: global class equals: FamixPythonGlobalVariable.
	self assert: global name equals: 'globalWithTuple3'.
	self assert: global parentScope equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariablesShadowedThenRedefined [

	| globals |
	globals := self model allGlobalVariables select: [ :variable | variable name = 'global_then_function_then_global_then_class' ].

	self assert: globals size equals: 2.
	globals do: [ :global |
		self assert: global name equals: 'global_then_function_then_global_then_class'.
		self assert: global parentScope equals: (self moduleNamed: 'moduleWithShadowing') ]
]

{ #category : 'tests - global variables' }
FamixPythonProject1Test >> testGlobalVariablesWithTheSameNameButDifferentParents [

	| globals |
	globals := self model allGlobalVariables select: [ :variable | variable name = 'globalVariableWithCommonName' ].

	self assert: globals size equals: 2.
	self assertCollection: (globals flatCollect: #parents) hasSameElements: {
			(self moduleNamed: 'moduleAtRoot').
			(self moduleNamed: 'moduleAtRoot2') }
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testImportAClassThatHasTheSameNameAsSubpackage [
	"We have a package with a class and a subpackage of the same name and here we check we manage well the imports of those entities"

	| module class import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleAtRoot7'.
	class := self classNamed: 'NameOfSubpackageOrClass'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'NameOfSubpackageOrClass' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2 import NameOfSubpackageOrClass'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportAModuleWithAnAlias [

	| module module2 import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	module2 := self moduleNamed: 'moduleAtRoot'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: module2.
	self deny: import isFromImport.
	self assert: import alias equals: 'mar'.
	self assert: import sourceText equals: 'import moduleAtRoot as mar'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportASubpackageThatHasTheSameNameAsAClass [
	"We have a package with a class and a subpackage of the same name and here we check we manage well the imports of those entities"

	| module package import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleAtRoot6'.
	package := self packageNamed: 'NameOfSubpackageOrClass'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'NameOfSubpackageOrClass' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: package.
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root2.NameOfSubpackageOrClass'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportASubpackageWithAnAlias [

	| module package import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.
	package := self packageNamed: 'subsubpackage1'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: package.
	self deny: import isFromImport.
	self assert: import alias equals: 'rss'.
	self assert: import sourceText equals: 'import root.subpackage1.subsubpackage1 as rss'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testImportAnEntityThatIsShadowed [
	"I created a module with a name that is shadowed. First it is assigned to a global variable then a class then a function. If we import the entity, the last decalred should win"

	| module function import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInRootPackage21'.
	function := self functionNamed: 'shadowedName'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'shadowedName' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: function.
	self assert: import importedEntity class equals: FamixPythonFunction.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2.moduleWithShadowing import shadowedName'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportSourceAnchor [

	| rootModule1 rootModule2 import |
	self denyEmpty: self model allImports.
	rootModule1 := self moduleNamed: 'moduleAtRoot'.
	rootModule2 := self moduleNamed: 'moduleAtRoot2'.
	import := rootModule2 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: rootModule2.
	self assert: import importedEntity equals: rootModule1.
	
	self assert: import sourceAnchor isNotNil.
	self assert: import sourceText equals: 'import moduleAtRoot'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportStubPackages [
	"For now, if we have a stub at the end of an import we create a package all the time and not a module because we cannot know what kind it is and it is the simplest code."

	| matplotlib pyglot module import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithStubs'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'pyplot' ].

	self deny: import isFromImport.

	pyglot := self packageNamed: 'pyplot'.
	matplotlib := pyglot parentPackage.

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: pyglot.
	self assert: import sourceText equals: 'import matplotlib.pyplot'.

	self assert: pyglot name equals: 'pyplot'.
	self assert: pyglot class equals: FamixPythonPackage.
	self assert: pyglot isStub.

	self assert: matplotlib name equals: 'matplotlib'.
	self assert: matplotlib class equals: FamixPythonPackage.
	self assert: matplotlib isStub
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportThatIsNotAtTheRootOfAFile [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'root2' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'root2').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root2'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportTwoStubPackagesOfTheSameName [
	"If two imports import a stub package of the same name, we should not produce multiple stubs."

	| pyplot numpy |
	self assert: (self model allPackages select: [ :package | package name = 'matplotlib' ]) size equals: 1.
	self assert: (self model allPackages select: [ :package | package name = 'pyplot' ]) size equals: 1.
	self assert: (self model allPackages select: [ :package | package name = 'numpy' ]) size equals: 1.

	pyplot := self packageNamed: 'pyplot'.
	numpy := self packageNamed: 'numpy'.

	"We ensure that those two are imported by more than 1 module"
	self assert: ((self moduleNamed: 'moduleAtRoot4') outgoingImports anySatisfy: [ :import | import importedEntity = pyplot ]).
	self assert: ((self moduleNamed: 'moduleAtRoot4') outgoingImports anySatisfy: [ :import | import importedEntity = numpy ]).

	self assert: ((self moduleNamed: 'moduleWithStubs') outgoingImports anySatisfy: [ :import | import importedEntity = pyplot ]).
	self assert: ((self moduleNamed: 'moduleWithStubs') outgoingImports anySatisfy: [ :import | import importedEntity = numpy ])
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testImportWithTheNameOfAStubClass [

	| module |
	module := self moduleNamed: 'moduleWithStubImport'.

	module outgoingImports do: [ :import | self deny: (import importedEntity isKindOf: FamixPythonClass) ]
]

{ #category : 'tests - inheritances' }
FamixPythonProject1Test >> testInheritanceDoesNotCreateReference [
	"Regression test"

	| class superclass |
	class := self classNamed: 'Animal'.
	superclass := self classNamed: 'AbstractAnimal'.

	self assert: class superclass equals: superclass.
	self assertEmpty: superclass incomingReferences
]

{ #category : 'tests - inheritances' }
FamixPythonProject1Test >> testInheritanceSourceAnchor [

	| class superclass inheritance |
	class := self classNamed: 'Student'.
	superclass := self classNamed: 'Person'.

	inheritance := class superInheritances detect: [ :anInheritance | anInheritance superclass = superclass ].

	self assert: inheritance sourceAnchor isNotNil.
	self assert: inheritance sourceText equals: 'Person'
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariableAreDefinedOnlyOnce [
	"We should have only one ivar even if it is assigned multiple times."

	self assert: (self model allAttributes select: [ :attribute | attribute name = 'dog_color' ]) size equals: 1
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariableDeclaredOutsideOfInit [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'dog_color'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'dog_color'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self deny: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariableSourceAnchor [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'dog_color'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'self.dog_color'.
	"The start and end pos should be the one of the first assignation and not the second"
	self assert: variable sourceAnchor startPos equals: 348.
	self assert: variable sourceAnchor endPos equals: 361
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariablesAssignedWithATuple [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'ivarTuple1'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'ivarTuple1'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self deny: variable isClassSide.

	variable := self attributeNamed: 'ivarTuple2'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'ivarTuple2'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self deny: variable isClassSide.

	variable := self attributeNamed: 'ivarTuple3'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'ivarTuple3'.
	self assert: variable parentType equals: (self classNamed: 'ClassWithTuples').
	self deny: variable isClassSide
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testInstanceVariablesWithSameNameButDifferenClass [

	| variables |
	variables := self model allAttributes select: [ :variable | variable name = 'number_of_legs' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self classNamed: 'Chair').
			(self classNamed: 'Stool') }
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationFromClass [

	| class class2 reference constructor invocation |
	class := self classNamed: 'Dog'.
	class2 := self classNamed: 'ClassWithInstantiation'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = class2 ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: class2.
	self assert: reference referencer equals: class2.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (class2 outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = class2 ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: class2.
	self assert: invocation sender equals: class2.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (class2 outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationFromFunction [

	| class function reference constructor invocation |
	class := self classNamed: 'Dog'.
	function := self functionNamed: 'function_with_instantiation'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = function ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: function.
	self assert: reference referencer equals: function.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (function outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = function ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: function.
	self assert: invocation sender equals: function.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (function outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationFromLambda [

	| class lambda reference constructor invocation |
	class := self classNamed: 'Dog'.
	lambda := (self functionNamed: 'function_with_lambda_and_instantiation') lambdas anyOne.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = lambda ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: lambda.
	self assert: reference referencer equals: lambda.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (lambda outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = lambda ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: lambda.
	self assert: invocation sender equals: lambda.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (lambda outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationFromMethod [

	| class method reference constructor invocation |
	class := self classNamed: 'Dog'.
	method := self methodNamed: 'method_with_instantiation'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = method ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: method.
	self assert: reference referencer equals: method.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (method outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = method ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: method.
	self assert: invocation sender equals: method.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (method outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationFromModule [

	| class module reference constructor invocation |
	class := self classNamed: 'Person'.
	module := self moduleNamed: 'moduleAtRoot2'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationFromPackage [

	| class package reference constructor invocation |
	class := self classNamed: 'Animal'.
	package := self packageNamed: 'root'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = package ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: package.
	self assert: reference referencer equals: package.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (package outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = package ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: package.
	self assert: invocation sender equals: package.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (package outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationOfClassWithoutExplicitConstructorCreatesStubs [
	"It was decided that if we instantiate a class without a constructor, we create a stub one to create an invocation on it."

	| class package constructor |
	class := self classNamed: 'Animal'.
	package := self packageNamed: 'root'.

	self shouldnt: [ constructor := class methods detect: #isConstructor ] raise: Error.

	self assert: constructor isStub.
	self assert: constructor name equals: '__init__'.
	self assert: constructor parentType equals: class
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationSourceAnchor [

	| class module reference constructor invocation |
	class := self classNamed: 'Person'.
	module := self moduleNamed: 'moduleAtRoot2'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'Person("John", 36)'.

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'Person("John", 36)'
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationWithAlias [

	| class module reference constructor invocation |
	class := self classNamed: 'Employee'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	reference := class incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: class.
	self assert: reference referredEntity equals: class.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = class ]).

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { constructor }.
	self assert: invocation invokedEntity equals: constructor .
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = constructor ])
]

{ #category : 'tests - instantiation' }
FamixPythonProject1Test >> testInstantiationWithAliasSourceAnchor [

	| class module reference constructor invocation |
	class := self classNamed: 'Employee'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	reference := (class incomingReferences select: [ :aReference | aReference referencer = module ]) detectMax: [ :r | r sourceAnchor startPos ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'Emp("Imen", 37)'.

	constructor := class methods detect: #isConstructor.
	invocation := constructor incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'Emp("Imen", 37)'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testInvocationOfMultipleStubFunctionsOfTheSameName [

	| module function invocations |
	function := self unknownEntityNamed: 'print'.
	module := self moduleNamed: 'moduleAtRoot'.

	invocations := function incomingInvocations select: [ :aReference | aReference sender = module ].

	self assert: invocations size equals: 9.
	self assert: (invocations collectAsSet: #target) size equals: 1. "Multiple stub of the same name in the same entity should produce only 1 stub and not duplicate them."
	self assert: function isStub
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testInvocationOfStubFunction [

	| module function invocation |
	function := self unknownEntityNamed: 'print'.
	module := self moduleNamed: 'moduleAtRoot'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testInvocationOfStubFunctionHasRightParentPackage [
	"If we have for example matplotlib.pyplot.plot(), we know that #plot() is in the module #pyplot in the package #matplotlib "

	| module function invocation |
	function := self unknownEntityNamed: 'plot'.
	module := self moduleNamed: 'moduleWithStubs'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: function isStub.
	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation invokedEntity equals: function.

	self assert: function parentPackage equals: (self packageNamed: 'pyplot').
	self assert: function parentPackage isStub
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testInvocationOfStubFunctionWithNamespace [

	| module function invocation |
	function := self unknownEntityNamed: 'array'.
	module := self moduleNamed: 'moduleWithStubs'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAClass [

	| lambda container |
	container := self classNamed: 'ClassWithLambda'.

	self assert: container class equals: FamixPythonClass.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'toto'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAFunction [

	| lambda container |
	container := self functionNamed: 'function_returning_lambda'.

	self assert: container class equals: FamixPythonFunction.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'a'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInALambda [

	| lambda container |
	container := self functionNamed: 'function_with_lambda_in_lambda'.

	self assert: container class equals: FamixPythonFunction.
	self assert: container lambdas size equals: 1.

	container := container lambdas first.

	self assert: container class equals: FamixPythonLambda.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'y'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAMethod [

	| lambda container |
	container := self methodNamed: 'method_with_lambda'.

	self assert: container class equals: FamixPythonMethod.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'tata'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAModule [

	| lambda container |
	container := self moduleNamed: 'moduleWithLambdas'.

	self assert: container class equals: FamixPythonModule.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'a, b'.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaInAPackage [

	| lambda container |
	container := self packageNamed: 'packageWithLambdas'.
	
	self assert: container class equals: FamixPythonPackage.
	self assert: container lambdas size equals: 1.
	
	lambda := container lambdas anyOne.
	
	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: 'a'.
	self assert: lambda lambdaContainer equals: container
	
	
	
	
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaSourceAnchor [

	| lambda |
	lambda := (self packageNamed: 'packageWithLambdas') lambdas anyOne.

	self assert: lambda sourceAnchor isNotNil.
	self assert: lambda sourceText equals: 'lambda a: a + 10'
]

{ #category : 'tests - lambdas' }
FamixPythonProject1Test >> testLambdaWithoutParameters [

	| lambda container |
	container := self functionNamed: 'function_with_lambda_without_parameters'.

	self assert: container class equals: FamixPythonFunction.
	self assert: container lambdas size equals: 1.

	lambda := container lambdas anyOne.

	self assert: lambda class equals: FamixPythonLambda.
	self assert: lambda signature equals: ''.
	self assert: lambda lambdaContainer equals: container
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testLocalMethodInvocationFromMethod [

	| method method2 invocation |
	method2 := self methodNamed: 'get_name'.
	method := self methodNamed: 'printInfos'.

	invocation := method2 incomingInvocations detect: [ :aReference | aReference sender = method ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: method.
	self assert: invocation sender equals: method.
	self assertCollection: invocation target hasSameElements: { method2 }.
	self assert: invocation invokedEntity equals: method2.
	self assert: (method outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = method2 ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testLocalMethodInvocationSourceAnchor [

	| method method2 invocation |
	method2 := self methodNamed: 'get_name'.
	method := self methodNamed: 'printInfos'.

	invocation := method2 incomingInvocations detect: [ :aReference | aReference sender = method ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'self.get_name()'
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariableInFunctionSourceAnchor [

	| variable |
	variable := self localVariableNamed: 'local_in_function2'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'local_in_function2'
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariableInMethodSourceAnchor [

	| variable |
	variable := self localVariableNamed: 'local_in_method2'.

	self assert: variable sourceAnchor isNotNil.
	self assert: variable sourceText equals: 'local_in_method2'
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInFunctionAssignedWithATuple [

	| global |
	self denyEmpty: self model allLocalVariables.

	global := self localVariableNamed: 'local_in_function_with_tuple1'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_function_with_tuple1'.
	self assert: global parentBehaviouralEntity equals: (self functionNamed: 'function_with_local_variables_and_tuples').

	global := self localVariableNamed: 'local_in_function_with_tuple2'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_function_with_tuple2'.
	self assert: global parentBehaviouralEntity equals: (self functionNamed: 'function_with_local_variables_and_tuples')
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInFunctionWithTheSameNameButDifferentParents [

	| variables |
	variables := self model allLocalVariables select: [ :variable | variable name = 'local_in_function1' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self functionNamed: 'function_with_local_variables').
			(self functionNamed: 'function_with_local_variables2') }
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInMethodAssignedWithATuple [

	| global |
	self denyEmpty: self model allLocalVariables.

	global := self localVariableNamed: 'local_in_method_with_tuple1'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_method_with_tuple1'.
	self assert: global parentBehaviouralEntity equals: (self methodNamed: 'method_with_local_variables_and_tuples').

	global := self localVariableNamed: 'local_in_method_with_tuple2'.

	self assert: global class equals: FamixPythonLocalVariable.
	self assert: global name equals: 'local_in_method_with_tuple2'.
	self assert: global parentBehaviouralEntity equals: (self methodNamed: 'method_with_local_variables_and_tuples')
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testLocalVariablesInMethodWithTheSameNameButDifferentParents [

	| variables |
	variables := self model allLocalVariables select: [ :variable | variable name = 'local_in_method1' ].

	self assert: variables size equals: 2.
	self assertCollection: (variables flatCollect: #parents) hasSameElements: {
			(self methodNamed: 'method_with_local_variables').
			(self methodNamed: 'method_with_local_variables2') }
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMergeFollowingSingleLineComments [

	| function |
	function := self functionNamed: 'function_with_single_lines_comments_to_merge'.

	self assert: function comments size equals: 2.

	self assertCollection: (function comments collect: #sourceText) hasSameElements: ({ '# Comment line 1
    # Comment line 2
    # Comment line 3
'. '# Other comment line 4
    # Other comment line 5
' } collect: [ :comment | comment withPlatformLineEndings ])
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsClassFromAModule [

	| method class import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	class := self classNamed: 'Person'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsClassFromAPackage [

	| method class import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	class := self classNamed: 'Room'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsFunctionFromAModule [

	| method function import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	function := self functionNamed: 'sort_list'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsFunctionFromAPackage [

	| method function import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	function := self functionNamed: 'return2'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsGlobalVariableFromAModule [

	| method global import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsGlobalVariableFromAPackage [

	| method global import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'print_info_2'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testMethodImportsModule [

	| method import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'printInfos'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot4' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot4').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import moduleAtRoot4'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsModuleFrom [

	| method module import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'method_importing_module'.
	module := self moduleNamed: 'moduleInSubPackage1'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubPackage1' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: module.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1 import moduleInSubPackage1'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testMethodImportsPackageFrom [

	| method package import |
	self denyEmpty: self model allImports.
	method := self methodNamed: 'method_importing_package'.
	package := self packageNamed: 'subsubpackage1'.
	import := method outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: method.
	self assert: import importedEntity equals: package.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1 import subsubpackage1'
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testMethodInvocationFromModule [

	| module method invocation |
	method := self methodNamed: 'printInfos'.
	module := self moduleNamed: 'moduleAtRoot2'.

	invocation := method incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { method }.
	self assert: invocation invokedEntity equals: method.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = method ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testMethodInvocationSourceAnchor [

	| module method invocation |
	method := self methodNamed: 'printInfos'.
	module := self moduleNamed: 'moduleAtRoot2'.

	invocation := method incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'p1.printInfos()'
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testMethodSourceAnchor [

	| method |
	self denyEmpty: self model allMethods.

	method := self methodNamed: 'printInfos'.

	self assert: method sourceAnchor isNotNil.
	self assert: method sourceText equals: 'def printInfos(self):
        import moduleAtRoot4
        if not moduleAtRoot3.moduleAtRootVariable3:
            print(self.get_name() + moduleAtRoot4.moduleAtRootSpaceString + str(self.age))' withPlatformLineEndings
]

{ #category : 'tests' }
FamixPythonProject1Test >> testModel [

	self assert: self model isNotEmpty.
	self assert: self model name equals: 'project1'.
	self assert: self model rootFolder equals: FamixPythonBridge parsingExamples / 'project1'
]

{ #category : 'tests' }
FamixPythonProject1Test >> testModelSourceLanguage [

	self assert: self model sourceLanguage class equals: FamixPythonSourceLanguage
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsClassFromAModule [

	| rootModule class import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	class := self classNamed: 'Person'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsClassFromAPackage [

	| rootModule class import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	class := self classNamed: 'Room'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsFunctionFromAModule [

	| rootModule function import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	function := self functionNamed: 'sort_list'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsFunctionFromAPackage [

	| rootModule function import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	function := self functionNamed: 'return2'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModule [

	| rootModule global import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleInAPackageOneLevelHigherRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInSubPackage3'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from ..moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleInASubpackageRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInRootPackage3-2'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from .subpackage3.moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInRootPackage3-2'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAModuleRelativelyWithSpacesInPath [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInSubSubPackage3'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from .. moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsGlobalVariableFromAPackage [

	| rootModule global import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleAtRoot5'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsModule [

	| rootModule1 rootModule2 import |
	self denyEmpty: self model allImports.
	rootModule1 := self moduleNamed: 'moduleAtRoot'.
	rootModule2 := self moduleNamed: 'moduleAtRoot2'.
	import := rootModule2 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].

	self assert: import importingEntity equals: rootModule2.
	self assert: import importedEntity equals: rootModule1.
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import moduleAtRoot'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsModuleFrom [

	| rootModule module import |
	self denyEmpty: self model allImports.
	rootModule := self moduleNamed: 'moduleWithModulesAndPackageImport'.
	module := self moduleNamed: 'moduleInRootPackage'.
	import := rootModule outgoingImports detect: [ :pimport | pimport target name = 'moduleInRootPackage' ].

	self assert: import importingEntity equals: rootModule.
	self assert: import importedEntity equals: module.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import moduleInRootPackage'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsModuleInPackage [

	| importingModule importedModule import |
	self denyEmpty: self model allImports.
	importingModule := self moduleNamed: 'moduleInRootPackage2'.
	importedModule := self moduleNamed: 'moduleInSubPackage1'.
	import := importingModule outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubPackage1' ].

	self assert: import importingEntity equals: importingModule.
	self assert: import importedEntity equals: importedModule.
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root.subpackage1.moduleInSubPackage1'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleImportsMultipleElements [

	| module global class function import import2 import3 |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleImportingMultipleItems'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].
	class := self classNamed: 'ClassInModuleInRoot3'.
	import2 := module outgoingImports detect: [ :pimport | pimport target name = 'ClassInModuleInRoot3' ].
	function := self functionNamed: 'function_in_module_in_root3'.
	import3 := module outgoingImports detect: [ :pimport | pimport target name = 'function_in_module_in_root3' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable, ClassInModuleInRoot3, function_in_module_in_root3'.
	self assert: import2 importingEntity equals: module.
	self assert: import2 importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import2 sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable, ClassInModuleInRoot3, function_in_module_in_root3'.
	self assert: import3 importingEntity equals: module.
	self assert: import3 importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import3 sourceText equals: 'from .moduleInRootPackage3 import moduleInRoot3Variable, ClassInModuleInRoot3, function_in_module_in_root3'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsMultipleModule [

	| module1 module2 module3 import import2 |
	self denyEmpty: self model allImports.
	module1 := self moduleNamed: 'moduleImportingMultipleItems'.
	module2 := self moduleNamed: 'moduleAtRoot'.
	import := module1 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot' ].
	module3 := self moduleNamed: 'moduleAtRoot3'.
	import2 := module1 outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: module1.
	self assert: import importedEntity equals: module2.
	self assert: import2 importingEntity equals: module1.
	self assert: import2 importedEntity equals: module3.
	self deny: import isFromImport.
	self deny: import2 isFromImport.
	self assert: import sourceText equals: 'import moduleAtRoot, moduleAtRoot3'.
	self assert: import2 sourceText equals: 'import moduleAtRoot, moduleAtRoot3'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsPackage [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'root' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'root').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testModuleImportsPackageFrom [

	| module package import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleWithModulesAndPackageImport'.
	package := self packageNamed: 'subpackage1'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'subpackage1' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: package.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import subpackage1'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsSubPackage [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleAtRoot'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'subpackage1' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'subpackage1').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root.subpackage1'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testModuleImportsSubPackageWithSpacesInThePath [

	| moduleAtRoot import |
	self denyEmpty: self model allImports.
	moduleAtRoot := self moduleNamed: 'moduleWithSpacedImports'.
	import := moduleAtRoot outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: moduleAtRoot.
	self assert: import importedEntity equals: (self packageNamed: 'subsubpackage1').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root .subpackage1 . subsubpackage1'
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testModuleInRootPackage [

	| module |
	self denyEmpty: self model allModules.

	module := self moduleNamed: 'moduleInRootPackage'.

	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: 'moduleInRootPackage'.
	self deny: module isRoot.
	self assert: module parentPackage equals: (self packageNamed: 'root')
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testModuleInSubPackage [

	| module |
	self denyEmpty: self model allModules.

	module := self moduleNamed: 'moduleInSubPackage1'.

	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: 'moduleInSubPackage1'.
	self deny: module isRoot.
	self assert: module parentPackage equals: (self packageNamed: 'subpackage1')
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testModuleInSubpackageImportsGlobalVariableFromAModuleRelatively [

	| module global import |
	self denyEmpty: self model allImports.
	module := self moduleNamed: 'moduleInSubPackage3-2'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := module outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: module.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from .moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromClass [

	| module class reference |
	module := self moduleNamed: 'moduleToReference3'.
	class := self classNamed: 'ClassReferencingAModule'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = class ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: class.
	self assert: reference referencer equals: class.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (class outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromFunction [

	| module function reference |
	module := self moduleNamed: 'moduleToReference5'.
	function := self functionNamed: 'function_referencing_module'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = function ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: function.
	self assert: reference referencer equals: function.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (function outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromImportedEntityWithAlias [

	| module module2 reference |
	module := self moduleNamed: 'moduleToReference7'.
	module2 := self moduleNamed: 'modulesReferencingThings'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = module2 ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module2.
	self assert: reference referencer equals: module2.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (module2 outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromImportedEntityWithAliasSourceAnchor [

	| module module2 reference |
	module := self moduleNamed: 'moduleToReference7'.
	module2 := self moduleNamed: 'modulesReferencingThings'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = module2 ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'module'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromLambda [

	| module lambda reference |
	module := self moduleNamed: 'moduleToReference6'.
	lambda := (self functionNamed: 'function_with_lambda_with_module_ref') lambdas anyOne.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = lambda ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: lambda.
	self assert: reference referencer equals: lambda.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (lambda outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromMethod [

	| module method reference |
	module := self moduleNamed: 'moduleToReference4'.
	method := self methodNamed: 'method_referencing_module'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = method ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: method.
	self assert: reference referencer equals: method.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (method outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromModule [

	| module module2 reference |
	module := self moduleNamed: 'moduleToReference2'.
	module2 := self moduleNamed: 'modulesReferencingThings'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = module2 ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module2.
	self assert: reference referencer equals: module2.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (module2 outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceFromPackage [

	| module package reference |
	module := self moduleNamed: 'moduleToReference1'.
	package := self packageNamed: 'subsubpackage1'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = package ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: package.
	self assert: reference referencer equals: package.
	self assert: reference target equals: module.
	self assert: reference referredEntity equals: module.
	self assert: (package outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = module ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testModuleReferenceSourceAnchor [

	| module class reference |
	module := self moduleNamed: 'moduleToReference3'.
	class := self classNamed: 'ClassReferencingAModule'.

	reference := module incomingReferences detect: [ :aReference | aReference referencer = class ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'packagesToReference.moduleToReference3'
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testModulesWithTheSameNameAreDifferent [

	| modules rootModule moduleInPackage |
	modules := self model allModules select: [ :module | module name = 'moduleWithCommonName' ].
	rootModule := modules detect: [ :module | module isRoot ].
	moduleInPackage := modules detect: [ :module | module isRoot not ].

	self assert: modules size equals: 2.
	self assert: rootModule isRoot.
	self assert: moduleInPackage parentPackage name equals: 'root'.
	self deny: rootModule identicalTo: moduleInPackage
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentBeforeClass [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
Before class
"""' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self classNamed: 'ClassWihtComments')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentBeforeFunction [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
Before function
"""' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self functionNamed: 'function_containing_multiline_comment')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentBeforeGlobal [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
Before global
"""' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self globalVariableNamed: 'global_with_multiline_comment')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentBeforeIvar [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
        Multiline
        Comment
        Before ivar
        """' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self attributeNamed: 'ivar_commented')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentBeforeLocal [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
    Multiline
    Comment
    Before temp
    """' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self localVariableNamed: 'temp_with_multiline_comment_before')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentBeforeMethod [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
    Multiline
    Comment
    Before method
    """' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self methodNamed: 'get_ivar_commented')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentInClass [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
    Multiline
    Comment
    In Class
    """' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self classNamed: 'ClassWihtComments')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentInFunction [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
    Multiline
    Comment
    In function
    """' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self functionNamed: 'function_containing_multiline_comment')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentInMethod [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
        Multiline
        Comment
        In method
        """' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self methodNamed: 'get_ivar_commented')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentInModule [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
In module
"""' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self moduleNamed: 'moduleAtRoot2')
]

{ #category : 'tests - comments' }
FamixPythonProject1Test >> testMultilineCommentInPackage [

	| comment |
	comment := self model allComments detect: [ :aComment |
		           aComment sourceText beginsWith: '"""
Multiline
Comment
In package
"""' withPlatformLineEndings ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self packageNamed: 'NameOfSubpackageOrClass')
]

{ #category : 'tests' }
FamixPythonProject1Test >> testNoNilSourceOrTargetForAssociations [

	(self model allUsing: FamixTAssociation) do: [ :association |
		self assert: association source isNotNil.
		self assert: association target isNotNil ]
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsClassFromAModule [

	| package class import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	class := self classNamed: 'Person'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'Person' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot2 import Person'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsClassFromAPackage [

	| package class import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	class := self classNamed: 'Room'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'Room' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: class.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import Room'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsFunctionFromAModule [

	| package function import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	function := self functionNamed: 'sort_list'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'sort_list' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import sort_list'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsFunctionFromAPackage [

	| package function import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	function := self functionNamed: 'return2'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'return2' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: function.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root.subpackage1.subsubpackage1 import return2'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModule [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRootVariable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from moduleAtRoot import moduleAtRootVariable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModuleInAPackageTwoLevelHigherRelatively [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subsubpackage3'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from ...moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModuleInaPackageOneLevelHigherRelatively [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackage3'.
	global := self globalVariableNamed: 'moduleInRoot3Variable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInRoot3Variable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from ..moduleInRootPackage3 import moduleInRoot3Variable'
]

{ #category : 'tests - from-import relative' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAModuleRelatively [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackage3'.
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInSubpackage31Variable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from .moduleInSubPackage3 import moduleInSubpackage31Variable'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsGlobalVariableFromAPackage [

	| package global import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'subpackageInRoot2'.
	global := self globalVariableNamed: 'rootPackageVariable'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'rootPackageVariable' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: global.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root import rootPackageVariable'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testPackageImportsModule [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'moduleAtRoot3' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self moduleNamed: 'moduleAtRoot3').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import moduleAtRoot3'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsModuleFrom [

	| package module import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'root3'.
	module := self moduleNamed: 'moduleInRootPackage2'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'moduleInRootPackage2' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: module.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2 import moduleInRootPackage2'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testPackageImportsPackage [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'root' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self packageNamed: 'root').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root'
]

{ #category : 'tests - from-import' }
FamixPythonProject1Test >> testPackageImportsPackageFrom [

	| package package2 import |
	self denyEmpty: self model allImports.
	package := self packageNamed: 'root3'.
	package2 := self packageNamed: 'subpackageInRoot2'.
	import := package outgoingImports detect: [ :pimport | pimport target name = 'subpackageInRoot2' ].

	self assert: import importingEntity equals: package.
	self assert: import importedEntity equals: package2.
	self assert: import isFromImport.
	self assert: import sourceText equals: 'from root2 import subpackageInRoot2'
]

{ #category : 'tests - imports' }
FamixPythonProject1Test >> testPackageImportsSubSubPackage [

	| rootPackage import |
	self denyEmpty: self model allImports.
	rootPackage := self packageNamed: 'root2'.
	import := rootPackage outgoingImports detect: [ :pimport | pimport target name = 'subsubpackage1' ].

	self assert: import importingEntity equals: rootPackage.
	self assert: import importedEntity equals: (self packageNamed: 'subsubpackage1').
	self deny: import isFromImport.
	self assert: import sourceText equals: 'import root.subpackage1.subsubpackage1'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromClass [

	| package class reference |
	package := self packageNamed: 'packagesToReference3'.
	class := self classNamed: 'ClassReferencingAPackage'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = class ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: class.
	self assert: reference referencer equals: class.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (class outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromFunction [

	| package function reference |
	package := self packageNamed: 'packagesToReference5'.
	function := self functionNamed: 'function_referencing_package'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = function ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: function.
	self assert: reference referencer equals: function.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (function outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromImportedEntityWithAlias [

	| package module reference |
	package := self packageNamed: 'packagesToReference7'.
	module := self moduleNamed: 'modulesReferencingThings'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromImportedEntityWithAliasSourceAnchor [

	| package module reference |
	package := self packageNamed: 'packagesToReference7'.
	module := self moduleNamed: 'modulesReferencingThings'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'package'
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromLambda [

	| package lambda reference |
	package := self packageNamed: 'packagesToReference6'.
	lambda := (self functionNamed: 'function_with_lambda_with_package_ref') lambdas anyOne.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = lambda ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: lambda.
	self assert: reference referencer equals: lambda.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (lambda outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromMethod [

	| package method reference |
	package := self packageNamed: 'packagesToReference4'.
	method := self methodNamed: 'method_referencing_package'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = method ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: method.
	self assert: reference referencer equals: method.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (method outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromModule [

	| package module reference |
	package := self packageNamed: 'packagesToReference2'.
	module := self moduleNamed: 'modulesReferencingThings'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = module ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: module.
	self assert: reference referencer equals: module.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (module outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceFromPackage [

	| package package2 reference |
	package := self packageNamed: 'packagesToReference1'.
	package2 := self packageNamed: 'subsubpackage1'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = package2 ].

	self assert: reference class equals: FamixPythonReference.
	self assert: reference source equals: package2.
	self assert: reference referencer equals: package2.
	self assert: reference target equals: package.
	self assert: reference referredEntity equals: package.
	self assert: (package2 outgoingReferences anySatisfy: [ :aReference | aReference referredEntity = package ])
]

{ #category : 'tests - references' }
FamixPythonProject1Test >> testPackageReferenceSourceAnchor [

	| package class reference |
	package := self packageNamed: 'packagesToReference3'.
	class := self classNamed: 'ClassReferencingAPackage'.

	reference := package incomingReferences detect: [ :aReference | aReference referencer = class ].

	self assert: reference sourceAnchor isNotNil.
	self assert: reference sourceText equals: 'packagesToReference.packagesToReference3'
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testPackageSourceAnchor [

	| rootPackage |
	self denyEmpty: self model allPackages.

	rootPackage := self packageNamed: 'root'.

	self assert: rootPackage sourceAnchor mooseModel equals: self model.
	self assert: rootPackage sourceAnchor sourceText equals: (FamixPythonBridge parsingExamples / 'project1' / 'src' / 'root' / '__init__.py') contents
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testPackageSourceAnchorWithComment [
	"Regression test. If a package starts with a comment, the comment is not taken into account in the source in SmaCC which is not right."

	| rootPackage |
	self denyEmpty: self model allPackages.

	rootPackage := self packageNamed: 'NameOfSubpackageOrClass'.

	self assert: rootPackage sourceAnchor mooseModel equals: self model.
	self assert: rootPackage sourceAnchor sourceText equals: '# The goal of this subpackage is to have the same name as a class in the parent package

print("I have the same name as a class")

"""
Multiline
Comment
In package
"""' withPlatformLineEndings
]

{ #category : 'tests' }
FamixPythonProject1Test >> testPlaceholderVariablesDoNotCreateStubs [
	"Regression test: having a placeholder variable `_` was creating a stub named `_` but we should just ignore those."
	
	self assertEmpty: ((self model allUsing: FamixTNamedEntity) select: [ :entity | entity name = '_' ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromFunction [

	| temporary function access |
	temporary := self localVariableNamed: 'local_in_function3'.
	function := self functionNamed: 'function_with_local_variables'.

	access := (temporary incomingAccesses select: [ :anAccess | anAccess accessor = function ]) detectMax: [ :anAccess | anAccess sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: temporary.
	self assert: access variable equals: temporary.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (function accesses anySatisfy: [ :anAccess | anAccess variable = temporary ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedEntityWithNamespace [

	| global module access |
	self skip. "Cannot resolve this yet"
	global := self globalVariableNamed: 'NameOfSubpackageOrClass'.
	module := self moduleNamed: 'moduleAtRoot6'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedGlobalWithNamespace [

	| global module access |
	global := self globalVariableNamed: 'rootPackage2Variable'.
	module := self moduleNamed: 'moduleAtRoot'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedGlobalWithNamespaceAlias [

	| global module access |
	global := self globalVariableNamed: 'subSubPackage1Variable'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedGlobalWithNamespaceAliasSourceAnchor [

	| global module access |
	global := self globalVariableNamed: 'subSubPackage1Variable'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'rss.subSubPackage1Variable'
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedGlobalWithNamespaceAndMultipleImports [

	| global module access |
	global := self globalVariableNamed: 'moduleAtRootVariable3'.
	module := self moduleNamed: 'moduleImportingMultipleItems'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedGlobalWithNamespaceSourceAnchor [

	| global module access |
	global := self globalVariableNamed: 'rootPackage2Variable'.
	module := self moduleNamed: 'moduleAtRoot'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'root2.rootPackage2Variable'
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromImportedGlobalWithNamespaceWithImportWithSpaces [

	| global module access |
	global := self globalVariableNamed: 'subSubPackage1Variable'.
	module := self moduleNamed: 'moduleWithSpacedImports'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromLambda [

	| parameter lambda access |
	parameter := self localVariableNamed: 'temporary_in_lambda'.
	lambda := lambda := (self functionNamed: 'function_with_lambda_with_temporary') lambdas anyOne.

	access := (parameter incomingAccesses select: [ :anAccess | anAccess accessor = lambda ]) detectMax: [ :anAccess | anAccess sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: lambda.
	self assert: access accessor equals: lambda.
	self assert: access target equals: parameter.
	self assert: access variable equals: parameter.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (lambda accesses anySatisfy: [ :anAccess | anAccess variable = parameter ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromLambdaToParameter [

	| parameter lambda access |
	parameter := (self functionNamed: 'function_returning_lambda') parameters anyOne.
	lambda := lambda := (self functionNamed: 'function_returning_lambda') lambdas anyOne.

	access := parameter incomingAccesses detect: [ :anAccess | anAccess accessor = lambda ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: lambda.
	self assert: access accessor equals: lambda.
	self assert: access target equals: parameter.
	self assert: access variable equals: parameter.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (lambda accesses anySatisfy: [ :anAccess | anAccess variable = parameter ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromMethod [

	| locale method access |
	locale := self localVariableNamed: 'local_in_method2'.
	method := self methodNamed: 'method_with_local_variables'.

	"We want to have the reading and not the writing."
	access := (locale incomingAccesses select: [ :anAccess | anAccess accessor = method ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: method.
	self assert: access accessor equals: method.
	self assert: access target equals: locale.
	self assert: access variable equals: locale.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (method accesses anySatisfy: [ :anAccess | anAccess variable = locale ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromModule [

	| global module access |
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	module := self moduleNamed: 'moduleAtRoot'.

	access := (global incomingAccesses select: [ :anAccess | anAccess accessor = module ]) detectMax: [ :anAccess | anAccess sourceAnchor startPos ] .

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromPackage [

	| global package access |
	global := self globalVariableNamed: 'rootPackageVariable'.
	package := self packageNamed: 'root'.

	access := (global incomingAccesses select: [ :anAccess | anAccess accessor = package ]) detectMax: [ :anAccess | anAccess sourceAnchor startPos ] .

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: package.
	self assert: access accessor equals: package.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (package accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessFromThiInsideOfAnInvocation [
	"Regression test. We were not representing accesses that were done inside the parameters of an invocaiton."

	| global module access |
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	module := self moduleNamed: 'moduleAtRoot8'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessSourceAnchor [

	| global module access |
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	module := self moduleNamed: 'moduleInSubSubPackage3'.

	"We want to have the reading and not the writing."
	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'moduleInSubpackage31Variable'
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToCVar [

	| cvar module access |
	self skip. "Todo"
	cvar := self attributeNamed: 'sound'.
	module := self moduleNamed: 'moduleAtRoot3'.

	"We want to have the reading and not the writing."
	access := (cvar incomingAccesses select: [ :anAccess | anAccess accessor = module ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: cvar.
	self assert: access variable equals: cvar.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = cvar ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToGlobal [

	| global module access |
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	module := self moduleNamed: 'moduleAtRoot'.

	"We want to have the reading and not the writing."
	access := (global incomingAccesses select: [ :anAccess | anAccess accessor = module ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToIVarInternalyToTheClass [

	| ivar method access |
	ivar := self attributeNamed: 'dog_color'.
	method := self methodNamed: 'get_dog_color'.

	"We want to have the reading and not the writing."
	access := (ivar incomingAccesses select: [ :anAccess | anAccess accessor = method ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: method.
	self assert: access accessor equals: method.
	self assert: access target equals: ivar.
	self assert: access variable equals: ivar.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (method accesses anySatisfy: [ :anAccess | anAccess variable = ivar ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToIVarInternalyToTheClassSourceAnchor [

	| ivar method access |
	ivar := self attributeNamed: 'dog_color'.
	method := self methodNamed: 'get_dog_color'.

	"We want to have the reading and not the writing."
	access := (ivar incomingAccesses select: [ :anAccess | anAccess accessor = method ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'self.dog_color'
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToImportedGlobal [

	| global module access |
	global := self globalVariableNamed: 'moduleInSubpackage31Variable'.
	module := self moduleNamed: 'moduleInSubSubPackage3'.

	"We want to have the reading and not the writing."
	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToImportedGlobalWithAlias [

	| global module access |
	global := self globalVariableNamed: 'moduleAtRoot2Variable'.
	module := self moduleNamed: 'moduleWithImportsAndAliases'.

	"We want to have the reading and not the writing."
	access := (global incomingAccesses detect: [ :anAccess | anAccess accessor = module ]).

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ]).
	self assert: access sourceText equals: 'marv' "It's not the name of the var because it is accessed via an alias."
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToLocaleInFunction [

	| locale function access |
	locale := self localVariableNamed: 'local_multiple2'.
	function := self functionNamed: 'function_with_multiple_assignations'.

	"We want to have the reading and not the writing."
	access := (locale incomingAccesses select: [ :anAccess | anAccess accessor = function ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: locale.
	self assert: access variable equals: locale.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (function accesses anySatisfy: [ :anAccess | anAccess variable = locale ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToLocaleInMethod [

	| locale method access |
	locale := self localVariableNamed: 'local_in_method2'.
	method := self methodNamed: 'method_with_local_variables'.

	"We want to have the reading and not the writing."
	access := (locale incomingAccesses select: [ :anAccess | anAccess accessor = method ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: method.
	self assert: access accessor equals: method.
	self assert: access target equals: locale.
	self assert: access variable equals: locale.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (method accesses anySatisfy: [ :anAccess | anAccess variable = locale ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testReadAccessToParameter [

	| parameter function access |
	parameter := self parameterNamed: 'list1'.
	function := self functionNamed: 'sort_list'.

	"We want to have the reading and not the writing."
	access := (parameter incomingAccesses select: [ :anAccess | anAccess accessor = function ]) detectMax: [ :entity | entity sourceAnchor startPos ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: parameter.
	self assert: access variable equals: parameter.
	self deny: access isWrite.
	self assert: access isRead.
	self assert: (function accesses anySatisfy: [ :anAccess | anAccess variable = parameter ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testRecursiveFunctionInvocation [

	| function invocation |
	function := self functionNamed: 'fibonacci'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = function ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: function.
	self assert: invocation sender equals: function.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (function outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testRootModule [

	| rootModule |
	self denyEmpty: self model allModules.

	rootModule := self moduleNamed: 'moduleAtRoot'.

	self assert: rootModule class equals: FamixPythonModule.
	self assert: rootModule name equals: 'moduleAtRoot'.
	self assert: rootModule isRoot.
	self assert: rootModule parentPackage isNil
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testRootPackage [
	| rootPackage |
	self denyEmpty: self model allPackages.
	
	rootPackage := self packageNamed: 'root'.
	
	self assert: rootPackage class equals: FamixPythonPackage.
	self assert: rootPackage name equals: 'root'.
	self assert: rootPackage isRoot
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testShadowableFunctionWithDifferentParameter [

	| function shadowable |
	function := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMax: [ :funct |
		            funct sourceAnchor startPos ].
	shadowable := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMin: [ :funct |
		              funct sourceAnchor startPos ].

	self assert: function name equals: 'function_to_shadow_with_different_signature'.
	self deny: function isShadowed.
	self assert: function signature equals: 'function_to_shadow_with_different_signature(age)'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assert: function shadowedEntity equals: shadowable.
	self assert: function sourceText equals: 'def function_to_shadow_with_different_signature(age):
    return age' withPlatformLineEndings
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testShadowedFunctionCreatesDifferentFunctions [

	| functions |
	functions := self model allFunctions select: [ :function | function name = 'function_to_shadow' ].
	self assert: functions size equals: 2.

	functions do: [ :function | self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6') ]
]

{ #category : 'tests - shadowing' }
FamixPythonProject1Test >> testShadowedFunctionWithDifferentParameter [

	| function shadower |
	function := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMin: [ :funct |
		            funct sourceAnchor startPos ].
	shadower := (self model allFunctions select: [ :funct | funct name = 'function_to_shadow_with_different_signature' ]) asOrderedCollection detectMax: [ :funct |
		            funct sourceAnchor startPos ].

	self assert: function name equals: 'function_to_shadow_with_different_signature'.
	self assert: function isShadowed.
	self assert: function signature equals: 'function_to_shadow_with_different_signature()'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot6').
	self assertCollection: function shadowingEntities hasSameElements: { shadower }.
	self assert: function sourceText equals: 'def function_to_shadow_with_different_signature():
    return 7' withPlatformLineEndings
]

{ #category : 'tests - classes' }
FamixPythonProject1Test >> testSimpleClass [

	| class |
	self denyEmpty: self model allClasses.

	class := self classNamed: 'Person'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Person'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleAtRoot2')
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testSimpleClassVariable [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'kind'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'kind'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self assert: variable isClassSide
]

{ #category : 'tests - functions' }
FamixPythonProject1Test >> testSimpleFunction [

	| function |
	self denyEmpty: self model allFunctions.

	function := self functionNamed: 'sort_list'.

	self assert: function class equals: FamixPythonFunction.
	self assert: function name equals: 'sort_list'.
	self assert: function signature equals: 'sort_list(list1, list2)'.
	self assert: function functionOwner equals: (self moduleNamed: 'moduleAtRoot')
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testSimpleFunctionInvocationWithNamespace [

	| module function invocation |
	function := self functionNamed: 'sort_list'.
	module := self moduleNamed: 'moduleAtRoot2'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation class equals: FamixPythonInvocation.
	self assert: invocation source equals: module.
	self assert: invocation sender equals: module.
	self assertCollection: invocation target hasSameElements: { function }.
	self assert: invocation invokedEntity equals: function.
	self assert: (module outgoingInvocations anySatisfy: [ :aReference | aReference invokedEntity = function ])
]

{ #category : 'tests - invocations' }
FamixPythonProject1Test >> testSimpleFunctionInvocationWithNamespaceSourceAnchor [

	| module function invocation |
	function := self functionNamed: 'sort_list'.
	module := self moduleNamed: 'moduleAtRoot2'.

	invocation := function incomingInvocations detect: [ :aReference | aReference sender = module ].

	self assert: invocation sourceAnchor isNotNil.
	self assert: invocation sourceText equals: 'moduleAtRoot.sort_list(["a", "b", "c", "d", "e", "f", "g", "h", "i"], [0, 1, 1, 0, 1, 2, 2, 0, 1])'
]

{ #category : 'tests - inheritances' }
FamixPythonProject1Test >> testSimpleInheritance [

	| class superclass inheritance |
	class := self classNamed: 'Student'.
	superclass := self classNamed: 'Person'.

	inheritance := class superInheritances detect: [ :anInheritance | anInheritance superclass = superclass ].

	self assert: inheritance class equals: FamixPythonInheritance.
	self assert: inheritance target equals: superclass.
	self assert: inheritance superclass equals: superclass.
	self assert: inheritance source equals: class.
	self assert: inheritance subclass equals: class.
	self assert: (superclass subInheritances anySatisfy: [ :anInheritance | anInheritance subclass = class ])
]

{ #category : 'tests - attributes' }
FamixPythonProject1Test >> testSimpleInstanceVariable [

	| variable |
	self denyEmpty: self model allAttributes.

	variable := self attributeNamed: 'dog_name'.

	self assert: variable class equals: FamixPythonAttribute.
	self assert: variable name equals: 'dog_name'.
	self assert: variable parentType equals: (self classNamed: 'Dog').
	self deny: variable isClassSide
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testSimpleLocalVariableInFunction [

	| variable |
	variable := self localVariableNamed: 'local_in_function2'.

	self assert: variable class equals: FamixPythonLocalVariable.
	self assert: variable name equals: 'local_in_function2'.
	self assert: variable parentBehaviouralEntity equals: (self functionNamed: 'function_with_local_variables')
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testSimpleLocalVariableInLambda [

	| variable |
	variable := self localVariableNamed: 'temporary_in_lambda'.

	self assert: variable class equals: FamixPythonLocalVariable.
	self assert: variable name equals: 'temporary_in_lambda'.
	self assert: variable parentBehaviouralEntity equals: (self functionNamed: 'function_with_lambda_with_temporary') lambdas anyOne
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testSimpleLocalVariableInMethod [

	| variable |
	variable := self localVariableNamed: 'local_in_method2'.

	self assert: variable class equals: FamixPythonLocalVariable.
	self assert: variable name equals: 'local_in_method2'.
	self assert: variable parentBehaviouralEntity equals: (self methodNamed: 'method_with_local_variables')
]

{ #category : 'tests - methods' }
FamixPythonProject1Test >> testSimpleMethod [

	| method |
	self denyEmpty: self model allMethods.

	method := self methodNamed: 'printInfos'.

	self assert: method class equals: FamixPythonMethod.
	self assert: method name equals: 'printInfos'.
	self assert: method signature equals: 'printInfos(self)'.
	self assert: method parentType equals: (self classNamed: 'Person')
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testSourceAnchorModule [

	| module |
	self denyEmpty: self model allModules.

	module := self moduleNamed: 'moduleToTestSourceAnchor'.

	self assert: module sourceAnchor isNotNil.
	self assert: module sourceText equals: '# DO NOT UPDATE THIS MODULE CONTENT THIS IS TO TEST SOURCE ANCHOR

def fibonacci(n):

    # Check if input is 0 then it will
    # print incorrect input
    if n < 0:
        print("Incorrect input")

    # Check if n is 0
    # then it will return 0
    elif n == 0:
        return 0

    # Check if n is 1,2
    # it will return 1
    elif n == 1 or n == 2:
        return 1

    else:
        return fibonacci(n - 1) + fibonacci(n - 2)


# Driver Program
print(fibonacci(9))
' withPlatformLineEndings
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testSubPackage [

	| rootPackage subPackage subSubPackage |
	self denyEmpty: self model allPackages.

	rootPackage := self packageNamed: 'root'.
	subPackage := self packageNamed: 'subpackage1'.

	self assert: subPackage class equals: FamixPythonPackage.
	self assert: subPackage name equals: 'subpackage1'.
	self deny: subPackage isRoot.
	self assert: subPackage parentPackage equals: rootPackage.

	subSubPackage := self packageNamed: 'subsubpackage1'.

	self assert: subSubPackage class equals: FamixPythonPackage.
	self assert: subSubPackage name equals: 'subsubpackage1'.
	self deny: subSubPackage isRoot.
	self assert: subSubPackage parentPackage equals: subPackage
]

{ #category : 'tests - inheritances' }
FamixPythonProject1Test >> testSuperclass [

	| class |
	class := self classNamed: 'Student'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Student'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleAtRoot2').
	self assert: class superclass equals: (self classNamed: 'Person').
	self deny: class isStub.
	self deny: class superclass isStub
]

{ #category : 'tests - inheritances' }
FamixPythonProject1Test >> testSuperclass2 [
	"Compared to the first test on superclasses, the order of parsing make it important that symbol resolution works in this case."

	| class |
	self assert: (self model allClasses select: [ :aClass | aClass name = 'AbstractAnimal' ]) size equals: 1.
	self assert: (self model allClasses select: [ :aClass | aClass name = 'Animal' ]) size equals: 1.
	self assert: (self model allClasses select: [ :aClass | aClass name = 'Fish' ]) size equals: 1.

	class := self classNamed: 'Animal'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Animal'.
	self assert: class typeContainer equals: (self packageNamed: 'root').
	self assert: class superclass equals: (self classNamed: 'AbstractAnimal').
	self deny: class isStub.
	self deny: class superclass isStub.

	class := self classNamed: 'Fish'.

	self assert: class class equals: FamixPythonClass.
	self assert: class name equals: 'Fish'.
	self assert: class typeContainer equals: (self moduleNamed: 'moduleAtRoot2').
	self assert: class superclass equals: (self classNamed: 'Animal').
	self deny: class isStub.
	self deny: class superclass isStub
]

{ #category : 'tests - unknown access or reference' }
FamixPythonProject1Test >> testTwoAccessOrReferencesToStubEntityCreateOneStub [

	| stub module accesses |
	stub := self unknownEntityNamed: 'MissingClass'.
	module := self moduleNamed: 'moduleWithRelativeFromImportStub'.

	accesses := stub accessesOrReferences select: [ :anAccess | anAccess accessorOrReferencer = module ].

	self assert: accesses size equals: 2.
	self assert: (accesses allSatisfy: [ :access | access unknownEntity = stub ]).
	self
		assert: (self model entities select: [ :entity | entity class = FamixPythonUnknownEntity and: [ entity name = 'MissingClass' ] ]) size
		equals: 1.
	self assert: stub isStub
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromClass [

	| variable class access |
	variable := self attributeNamed: 'kind'.
	class := self classNamed: 'Dog'.

	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = class ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: class.
	self assert: access accessor equals: class.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (class accesses anySatisfy: [ :anAccess | anAccess variable = variable ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromFunction [

	| variable function access |
	variable := self localVariableNamed: 'zipped_pairs'.
	function := self functionNamed: 'sort_list'.

	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = function ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (function accesses anySatisfy: [ :anAccess | anAccess variable = variable ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromInnerFunction [

	| variable function access |
	variable := self localVariableNamed: 'inner_local_variable'.
	function := self functionNamed: 'inner_function'.

	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = function ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (function accesses anySatisfy: [ :anAccess | anAccess variable = variable ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromLambda [

	| variable lambda access |
	variable := self localVariableNamed: 'temporary_in_lambda'.
	lambda := (self functionNamed: 'function_with_lambda_with_temporary') lambdas anyOne.

	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = lambda ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: lambda.
	self assert: access accessor equals: lambda.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (lambda accesses anySatisfy: [ :anAccess | anAccess variable = variable ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromMethod [

	| variable method access |
	variable := self attributeNamed: 'dog_name'.
	method := (self classNamed: 'Dog') methods detect: #isConstructor.

	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = method ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: method.
	self assert: access accessor equals: method.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (method accesses anySatisfy: [ :anAccess | anAccess variable = variable ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromModule [

	| variable module access |
	variable := self globalVariableNamed: 'moduleInRootVariable'.
	module := self moduleNamed: 'moduleInRootPackage'.

	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = variable ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessFromPackage [

	| global package access |
	global := self globalVariableNamed: 'rootPackageVariable'.
	package := self packageNamed: 'root'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = package ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: package.
	self assert: access accessor equals: package.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (package accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessOfGlobalThatGotShadowedAndRedefined [
	"This test ensure that if we declare a global, shadow it and redefine it again, the accesses are going to the right global."

	| global1 global2 module accesses |
	global1 := (self model allGlobalVariables select: [ :entity | entity name = 'global_then_function_then_global_then_class' ]) asOrderedCollection detectMin: [
		           :entity | entity sourceAnchor startPos ].
	global2 := (self model allGlobalVariables select: [ :entity | entity name = 'global_then_function_then_global_then_class' ]) asOrderedCollection detectMax: [
		           :entity | entity sourceAnchor startPos ].
	module := self moduleNamed: 'moduleWithShadowing'.

	accesses := module accesses select: [ :anAccess | anAccess variable name = 'global_then_function_then_global_then_class' ].

	self assert: (accesses detectMin: [ :entity | entity sourceAnchor startPos ]) variable equals: global1.
	self assert: (accesses detectMax: [ :entity | entity sourceAnchor startPos ]) variable equals: global2
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessSourceAnchor [

	| locale method access |
	locale := self localVariableNamed: 'local_in_method2'.
	method := self methodNamed: 'method_with_local_variables'.

	access := locale incomingAccesses detect: [ :anAccess | anAccess accessor = method ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'local_in_method2 = 2'
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessSourceAnchorInTupleAssignation [

	| global module access |
	global := self globalVariableNamed: 'globalWithTuple1'.
	module := self moduleNamed: 'moduleAtRoot'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access sourceAnchor isNotNil.
	self assert: access sourceText equals: 'globalWithTuple1, globalWithTuple2, globalWithTuple3 = (1, 2, 3)'
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessToCVar [

	| cvar class access |
	cvar := self attributeNamed: 'kind'.
	class := self classNamed: 'Dog'.

	access := cvar incomingAccesses detect: [ :anAccess | anAccess accessor = class ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: class.
	self assert: access accessor equals: class.
	self assert: access target equals: cvar.
	self assert: access variable equals: cvar.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (class accesses anySatisfy: [ :anAccess | anAccess variable = cvar ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessToGlobal [

	| global module access |
	global := self globalVariableNamed: 'moduleAtRootVariable'.
	module := self moduleNamed: 'moduleAtRoot'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessToGlobalTwice [

	| global module accesses |
	global := self globalVariableNamed: 'globalAssignedTwice'.
	module := self moduleNamed: 'moduleAtRoot'.

	accesses := global incomingAccesses select: [ :anAccess | anAccess accessor = module ].

	self assert: accesses size equals: 2.

	accesses do: [ :access |
		self assert: access class equals: FamixPythonAccess.
		self assert: access source equals: module.
		self assert: access accessor equals: module.
		self assert: access target equals: global.
		self assert: access variable equals: global.
		self assert: access isWrite.
		self deny: access isRead ]
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessToIVar [

	| ivar method access |
	ivar := self attributeNamed: 'dog_name'.
	method := (self classNamed: 'Dog') methods detect: #isConstructor.

	access := ivar incomingAccesses detect: [ :anAccess | anAccess accessor = method ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: method.
	self assert: access accessor equals: method.
	self assert: access target equals: ivar.
	self assert: access variable equals: ivar.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (method accesses anySatisfy: [ :anAccess | anAccess variable = ivar ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessToLocaleInFunction [

	| locale function access |
	locale := self localVariableNamed: 'local_in_function2'.
	function := self functionNamed: 'function_with_local_variables'.

	access := locale incomingAccesses detect: [ :anAccess | anAccess accessor = function ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: locale.
	self assert: access variable equals: locale.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (function accesses anySatisfy: [ :anAccess | anAccess variable = locale ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessToLocaleInMethod [

	| locale method access |
	locale := self localVariableNamed: 'local_in_method2'.
	method := self methodNamed: 'method_with_local_variables'.

	access := locale incomingAccesses detect: [ :anAccess | anAccess accessor = method ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: method.
	self assert: access accessor equals: method.
	self assert: access target equals: locale.
	self assert: access variable equals: locale.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (method accesses anySatisfy: [ :anAccess | anAccess variable = locale ])
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessWithMultipleAssignations [
	"Test to ensure we parse well this kind of assignations:
	
	local_multiple1 = local_multiple2 = local_multiple3 = 2"

	| variable function access |
	function := self functionNamed: 'function_with_multiple_assignations'.

	variable := self localVariableNamed: 'local_multiple1'.
	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = function ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.

	variable := self localVariableNamed: 'local_multiple2'.
	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = function ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead.

	variable := self localVariableNamed: 'local_multiple3'.
	access := variable incomingAccesses detect: [ :anAccess | anAccess accessor = function ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: function.
	self assert: access accessor equals: function.
	self assert: access target equals: variable.
	self assert: access variable equals: variable.
	self assert: access isWrite.
	self deny: access isRead
]

{ #category : 'tests - accesses' }
FamixPythonProject1Test >> testWriteAccessWithTupleAssignation [

	| global module access |
	global := self globalVariableNamed: 'globalWithTuple1'.
	module := self moduleNamed: 'moduleAtRoot'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ]).

	global := self globalVariableNamed: 'globalWithTuple2'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ]).

	global := self globalVariableNamed: 'globalWithTuple3'.

	access := global incomingAccesses detect: [ :anAccess | anAccess accessor = module ].

	self assert: access class equals: FamixPythonAccess.
	self assert: access source equals: module.
	self assert: access accessor equals: module.
	self assert: access target equals: global.
	self assert: access variable equals: global.
	self assert: access isWrite.
	self deny: access isRead.
	self assert: (module accesses anySatisfy: [ :anAccess | anAccess variable = global ])
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testlocalVariableInFunctionAreDefinedOnlyOnce [
	"We should have only one global even if it is assigned multiple times."

	self assert: (self model allLocalVariables select: [ :variable | variable name = 'local_in_function3' ]) size equals: 1
]

{ #category : 'tests - local variables' }
FamixPythonProject1Test >> testlocalVariableInMethodAreDefinedOnlyOnce [
	"We should have only one global even if it is assigned multiple times."

	self assert: (self model allLocalVariables select: [ :variable | variable name = 'local_in_method3' ]) size equals: 1
]
