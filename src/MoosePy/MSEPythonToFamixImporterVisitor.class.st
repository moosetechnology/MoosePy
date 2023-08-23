Class {
	#name : #MSEPythonToFamixImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'model',
		'sender'
	],
	#category : #MoosePy
}

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> basicCreateFunction: aSelector withSignature: aSignature [

	| function |
	function := model newFunction.
	function name: aSelector.
	function isStub: true.
	function signature: aSignature.
	^ function
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> basicCreateMethod: aSelector withSignature: aSignature [

	| method |
	method := model newMethod.
	method name: aSelector.
	method isStub: true.
	method signature: aSignature.
	^ method
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> classNamed: aName [

	^ (self model allWithType: FamixPythonClass)
		  detect: [ :e | e name = aName ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> classes [

	^ self model allWithType: FamixPythonClass
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createClass: aClass [

	| class name |
	name := aClass cname value.
	class := model newClass.
	class name: aClass cname value.
	class stub: true.
	^ class
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createEntity: anEntity withType: aType [

	| entity |
	entity := aType = 'module' ifTrue: [ self createModule: anEntity ].
	entity := aType = 'import' ifTrue: [ self createImport: anEntity ].
	entity := aType = 'class' ifTrue: [ self createClass: anEntity ].
	entity := aType = 'method' ifTrue: [ self createMethod: anEntity ].
	entity := aType = 'function' ifTrue: [ self createFunction: anEntity ].
	entity := aType = 'invocation' ifTrue: [
		          self createInvocation: anEntity ].


	entity sourceAnchor: (FamixPythonIndexedFileAnchor new
			 startPos: anEntity startPosition;
			 endPos: anEntity stopPosition;
			 yourself)
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createFunction: aFunctionNode [

	| function signature thisModule thisModuleName |
	signature := aFunctionNode parameters ifNotNil: [
		             aFunctionNode parameters signatureString ].
	function := self
		            basicCreateFunction: aFunctionNode fname value
		            withSignature: signature.

	thisModuleName := (self moduleNameFromFonction: aFunctionNode)
		                  asSymbol.
	thisModule := self ensureModule: thisModuleName.

	function functionOwner: thisModule.


	self
		ensureParameters: aFunctionNode parameters
		inFunctionName: aFunctionNode.

	^ function
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> createImport: anImport [

	| name import module |
	name := anImport names first names first value.
	"this will not work when we have 
		import pygame.foo
		an import node should provide fullname which would return pygame.foo"

	import := FamixPythonImport new.
	import entityName: name.
	import mooseModel: model.
	module := self ensureModule: anImport parent parent.
	import manualImportingEntity: module.
	module manualAddImport: import
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createInvocation: anInvocationNode [

	| invocation canditate receiver args |
	invocation := model newInvocation.
	canditate := anInvocationNode atom nameToken value.
	receiver := nil.
	args := (anInvocationNode trailers at: 1) arguments.


	invocation sender: sender top.
	invocation attributeAt: 'canditateName' put: canditate.
	invocation signature:
		(self signatureFromInvocation: anInvocationNode).

	invocation sourceAnchor: (FamixPythonIndexedFileAnchor new
			 startPos: anInvocationNode startPosition;
			 endPos: anInvocationNode stopPosition;
			 yourself)
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createMethod: aMethodNode [

	| method thisClass |
	method := self
		          basicCreateMethod: aMethodNode fname value
		          withSignature: aMethodNode parameters signatureString.
		
	thisClass := aMethodNode parent.
	method parentType: (self ensureClass: thisClass).
	
	self
		ensureParameters: aMethodNode parameters
		inMethodName: aMethodNode.


	^method 
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createModule: aModuleNode [

	| module |
	module := model newModule.
	module name: (self moduleNameStringOf: aModuleNode).
	^ module
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createParameter: aParameter in: aContainerNode [

	| parameterName parameter entityContainer |
	parameterName := aParameter nameToken value.
	parameter := model newParameter.
	parameter name: parameterName.

	entityContainer := aContainerNode isMethod
		                   ifTrue: [ self ensureMethod: aContainerNode ]
		                   ifFalse: [ self ensureFunction: aContainerNode ].

	parameter parentBehaviouralEntity: entityContainer.

	parameter sourceAnchor: (FamixPythonIndexedFileAnchor new
			 startPos: aParameter startPosition;
			 endPos: aParameter stopPosition;
			 yourself).
			
	^ parameter
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureClass: aClassNode [

	^ (self classNamed: aClassNode cname value )
		  ifNil: [ self createClass: aClassNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureFunction: aFunctionNode [

^ (self functionNamed: aFunctionNode fname value)
		  ifNil: [ self createFunction: aFunctionNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureMethod: aMethodNode [

	^ (self
		   methodNamed: aMethodNode fname value
		   inClass: aMethodNode parent cname value) ifNil: [
		  self createMethod: aMethodNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureModule: aModuleNode [

	^ (self moduleNamed: (self moduleNameStringOf: aModuleNode)) ifNil: [
		  self createModule: aModuleNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureParameters: theParameters inFunctionName: aFunctionNode [

	^ theParameters ifNotNil: [
		  theParameters args collect: [ :parameter |
			  (self
				   parameterNamed: parameter nameToken value
				   inFunction: aFunctionNode fname value) ifNil: [
				  self createParameter: parameter in: aFunctionNode ] ] ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureParameters: theParameters inMethodName: aMethodNode [

	^ theParameters ifNotNil: [
		  theParameters args collect: [ :parameter |
			  (self
				   parameterNamed: parameter nameToken value
				   inMethod: aMethodNode fname value
				   inClass: aMethodNode parent cname value) ifNil: [
				  self createParameter: parameter in: aMethodNode ] ] ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> functionNamed: aString [

	^ (self model allWithType: FamixPythonFunction)
		  detect: [ :e |
			  e name = aString.
			   ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> functions [

	^ self model allWithType: FamixPythonFunction
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> importNamed: aString [

	^ (self model allWithType: FamixPythonImport)
		  detect: [ :e | e entityName = aString ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> imports [

	^ self model allWithType: FamixPythonImport 
]

{ #category : #initialization }
MSEPythonToFamixImporterVisitor >> initialize [

	super initialize.
	sender := Stack new.
	model := FamixPythonModel new name: 'defaultPythonModelName'
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> invocationNamed: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e | e entityAttributes first value = aString ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> invocations [

	^ self model allWithType: FamixPythonInvocation
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> methodNamed: aString inClass: aClassName [

	^ (self model allWithType: FamixPythonMethod)
		  detect: [ :e |
			  e name = aString and: [ e parentType name = aClassName ] ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methods [

	^ self model allWithType: FamixPythonMethod 
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> model [
	^ model
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> moduleNameFromFonction: aFunctionNode [

	^((aFunctionNode parent attributes array first value
		            fullName) removePrefix: '/') removeSuffix: '.py'.
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> moduleNameStringOf: aModuleNode [
	"should push that to the PyInputFileNode"

	^(aModuleNode isString
		ifTrue: [  aModuleNode ]
		ifFalse: [
			 aModuleNode filename
				  ifNil: [ 'Main Module' ]
				  ifNotNil: [ :s | s basenameWithoutExtension ] ] )value
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> moduleNamed: aString [

	^ (self model allWithType: FamixPythonModule)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> parameterNamed: pName inFunction: fName [

	^ (self model allWithType: FamixPythonParameter)
		  detect: [ :e | e name = pName and: [ e parentBehaviouralEntity name = fName ] ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> parameterNamed: pName inMethod: fName inClass: cName [

	^ (self model allWithType: FamixPythonParameter)
		  detect: [ :e |
			  (e name = pName and: [ e parentBehaviouralEntity name = fName and: [ e parentBehaviouralEntity parentType name = cName ]])
				   ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> parameters [

	^ self model allWithType: FamixPythonParameter 
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> sender [

	^ sender
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> signatureFromInvocation: anInvocationNode [

	| signature startPos |
	signature := anInvocationNode asString.
	startPos := signature indexOf: $(.
	startPos := signature indexOf: $( startingAt: startPos+1.
	^ signature copyFrom: startPos +1 to: signature size-2
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitArgument: anArgumentNode [

	^ super visitArgument: anArgumentNode
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	^ super visitClassdef: aClassDef
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFileInput: aFileInput [

	| module |
	module := self ensureModule: aFileInput.
		sender push: module.
	^ super visitFileInput: aFileInput
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFor: anIForNode [

	^ super visitFor: anIForNode 
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFuncdef: aFuncdef [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| fmx result |
	fmx := aFuncdef isMethod
		ifTrue: [  self ensureMethod: aFuncdef ]
		ifFalse: [ self ensureFunction: aFuncdef ].
	sender push: fmx.
	result := super visitFuncdef: aFuncdef.
	sender pop.
	^ result
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitIf: anIfiNode [

	^ super visitIf: anIfiNode
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitImport: anImport [

	self createImport: anImport.
	^ super visitImport: anImport
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitPower: anInvocation [

	anInvocation trailers ifNotEmpty: [
		self createInvocation: anInvocation ].

	^ super visitPower: anInvocation
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitSimpleStmt: anSimpleStmtNode [

	
	^ super visitSimpleStmt: anSimpleStmtNode
]
