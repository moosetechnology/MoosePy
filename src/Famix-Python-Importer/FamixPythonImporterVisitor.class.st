Class {
	#name : 'FamixPythonImporterVisitor',
	#superclass : 'PyRootNodeVisitor',
	#instVars : [
		'model',
		'layer',
		'rootFilePath',
		'context'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'visiting' }
FamixPythonImporterVisitor >> acceptNodes: aCollection [
	"override to return the result of the visits"

	^aCollection collect: [ :each | self acceptNode: each ].

]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> annotationTypeNamed: aString [ 

	^ (self model allWithType: FamixPythonAnnotationType)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> basicCreateFunction: aSelector withSignature: aSignature [

	| function |
	function := model newFunction.
	function name: aSelector.
	function isStub: true.
	function signature: aSignature.
	^ function
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> basicCreateMethod: aSelector withSignature: aSignature [

	| method |
	method := model newMethod.
	method name: aSelector.
	method isStub: true.
	method signature: aSignature.
	^ method
]

{ #category : 'accessing - classes' }
FamixPythonImporterVisitor >> classNamed: aName [

	^ (self model allWithType: FamixPythonClass)
		  detect: [ :e | e name = aName ]
		  ifNone: [ nil ]
]

{ #category : 'accessing - classes' }
FamixPythonImporterVisitor >> classes [

	^ self model allWithType: FamixPythonClass
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> context [

	^ context
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> contextModule [

	"rather ugly, but I did not want to add methods in the meta-model for this"

	| top |
	top := context firstLink.
	[  top value class = FamixPythonModule ]
	whileFalse: [ top := top nextLink ].

	^top value
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createAnnotationInstance: aPyDecoratorNode named: aString [ 

	^model newAnnotationInstance
		annotationType: (self ensureAnnotationTypeNamed: aString) ;
		yourself
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createAnnotationTypeNamed: aString [ 

	^model newAnnotationType
		name:  aString ;
		yourself
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createClass: classDefinitionNode [

	| famixClass superClasses metaClasses |
	famixClass := model newClass.
	famixClass name: classDefinitionNode pythonClassName.

	"Reject all metaclass declarations, keep only superclasses (if any)"
	"TODO Handle PyTrailersNode"
	superClasses := classDefinitionNode superClasses reject: [ :s | s class = PyMetaclassNode ].
	superClasses do: [ :fieldAccessNode |
		| superName superObject inheritance |
		superName := fieldAccessNode name.
		superObject := self ensureClassNamed: superName.
		inheritance := model newInheritance.
		inheritance
			superclass: superObject;
			subclass: famixClass ].

	"Case for object, only if needed!"
	superClasses ifEmpty: [
		| inheritance object |
		object := self ensureClassNamed: 'object'.
		object isStub: true.
		inheritance := model newInheritance.
		inheritance
			superclass: object yourself;
			subclass: famixClass ].

	"Reject all superclass declarations, keep only metaclasses (if any, there should be at most one)."
	"I don't know why this was used. We need tests hitting this part of the code to fix it."
	"metaClasses := classDefinitionNode superClasses reject: [ :s | s class = PySymbolNode or: [ s class = PyTrailersNode ] ].
	metaClasses do: [ :m |
		| metaClassName metaClassObject |
		metaClassName := m superclass name.
		metaClassObject := self classNamed: metaClassName.
		metaClassObject ifNil: [
			metaClassObject := model newClass
				                   name: metaClassName;
				                   stub: true ].
		famixClass metaclass: metaClassObject ]."

	^ self setSourceAnchor: famixClass from: classDefinitionNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createFunction: aFunctionNode [

	| function signature |
	signature := aFunctionNode signatureString.

	function := self basicCreateFunction: aFunctionNode fname value withSignature: signature.

	function functionOwner: context top.

	^ self setSourceAnchor: function from: aFunctionNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createImport: anImport ofName: aName from: fromName alias: alias [

	| import module |
	import := model newImport
		entityName: aName;
		asName: alias;
		fromName: fromName;
		yourself.

	self setSourceAnchor: import from: anImport.

	module := self contextModule.
	import manualImportingEntity: module.
	module manualAddImport: import.

	^ import
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createInvocation: anInvocationNode [

	| invocation tSize invocDict  |
	invocation := model newInvocation.
	tSize := anInvocationNode trailers size.

	invocDict := self extractInvocationInformation: anInvocationNode.

	invocation sender: context top.
	invocation cacheAt: 'canditate' put: (invocDict at: 'canditate').
	invocation cacheAt: 'args' put: (invocDict at: 'args').
	invocation cacheAt: 'receiver' put: (invocDict at: 'receiver').
	invocation signature:
		(self signatureFromInvocation: anInvocationNode).

	^ self setSourceAnchor: invocation from: anInvocationNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createLambda: aLambdaNode [

	| function signature |

	self flag: 'for now creating a lmbda as an unnamed function, but should be a FamixPythonLambda'.

	"signature := aLambdaNode parameters ifNotNil: [
		             aLambdaNode parameters signatureString ]."
	function := self
		basicCreateFunction: ''
		withSignature: '(' , aLambdaNode testlist arguments asString , ') -> ' , aLambdaNode testlist body asString.

	function functionOwner: context top.

	^ self setSourceAnchor: function from: aLambdaNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createMethod: aMethodNode [

	| method signature |
	signature := aMethodNode signatureString.
	method := self basicCreateMethod: aMethodNode fname value withSignature: signature.

	method parentType: context top.

	^ self setSourceAnchor: method from: aMethodNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createModule: aModuleNode named: aName [

	| module |
	module := model newModule.
	module name: aName.

	^ self setSourceAnchor: module from: aModuleNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createParameter: aParameter inBehavioural: aFamixContainer [

	| parameterName parameter |
	parameterName := aParameter parameterName.
	parameter := model newParameter.
	parameter name: parameterName.

	parameter parentBehaviouralEntity: aFamixContainer.

	^ self setSourceAnchor: parameter from: aParameter
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureAnnotationTypeNamed: aString [ 

	^ (self annotationTypeNamed: aString) ifNil: [
		  self createAnnotationTypeNamed: aString ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureClass: aClassNode [

	^ (self classNamed: aClassNode pythonClassName) ifNil: [ self createClass: aClassNode ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureClassNamed: aName [

	^ (self classNamed: aName) ifNil: [ model newClass name: aName ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureFunction: aFunctionNode [

	^ (self functionNamed: aFunctionNode fname value) ifNil: [
		  self createFunction: aFunctionNode  ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureImport: anImportNode of: importedNames from: aName aliases: aliasNames [

	importedNames withIndexDo: [ :importName :i |
		(self importNamed: importName) ifNil: [ | alias |
			aliasNames
				ifEmpty: [ alias := nil ]
				ifNotEmpty: [ alias := aliasNames at: i ].
			self createImport: anImportNode ofName: importName from: aName alias: alias
		]
	]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureMethod: aMethodNode [

	^ (self
		   methodNamed: aMethodNode fname value
		   inClassNamed: context top name) ifNil: [
		  self createMethod: aMethodNode ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureModuleFromFileInputNode: aFileInputNode [

	^ self 
		ensureModuleNamed: aFileInputNode filename basename withoutExtension  
		fromNode: aFileInputNode 
	
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureModuleNamed: moduleName fromNode: aModuleNode [

	^ (self moduleNamed: moduleName) ifNil: [ self createModule: aModuleNode named: moduleName ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureParameter: parameter inBehavioural: aBehavioralEntity [

	^ (self parameterNamed:parameter parameterName inBehavioural: aBehavioralEntity)
		ifNil: [ self createParameter: parameter inBehavioural: aBehavioralEntity ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> ensureVariable: aName localTo: aFamixEntity [

	aFamixEntity dictLocalVariables
		at: aName
		ifAbsent: [ aFamixEntity createLocalVariable: aName ]
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> extractArgumentsInformation: aSignature [

	| arguments argument buffer extractedList tmp res labelCleaned valueCleaned buffer2 mySignature y  |
	argument := Dictionary new.
	arguments := OrderedCollection new.
	extractedList := OrderedCollection new.

	buffer2 := OrderedCollection new.

	"Example : '(2,2), border_mode=''same'''"

	"Extract ()"
	mySignature := aSignature removeSuffix: ')'.
	buffer := $( split: mySignature.


	buffer do: [ :each |
		(each indexOf: $)) > 0
			ifTrue: [
				y := $) split: each.
				buffer2 add: ($, split: y first).
				buffer2 add: y second ]
			ifFalse: [ buffer2 add: each ] ].


	buffer2 do: [ :each |
		(each indexOf: $() > 0
			ifTrue: [ extractedList add: (each copyWithoutAll: '(') ]
			ifFalse: [ ($, split: each) do: [ :x | extractedList add: x ] ] ].




	"Extract label with ="
	res := extractedList collect: [ :each |
		       argument := Dictionary new.

		       each isString
			       ifTrue: [
				       (each indexOf: $=) > 0
					       ifTrue: [
						       tmp := $= split: each.

						       argument at: 'label' put: tmp first.
						       argument at: 'value' put: tmp second ]
					       ifFalse: [ argument at: 'value' put: each ] ]
			       ifFalse: [ argument at: 'value' put: each ].
		       each = '' | (each = ' ') ifFalse: [ arguments add: argument ] ].


	arguments do: [ :arg | "Clean label"
		arg at: 'label' ifPresent: [
			labelCleaned := ((arg at: 'label') copyWithoutAll: ',') trim.

			arg at: 'label' put: labelCleaned ].

		"Clean value"
		arg at: 'value' ifPresent: [
			(arg at: 'value') isString ifTrue: [
				valueCleaned := ((arg at: 'value') copyWithoutAll: '''') trim.


				(valueCleaned indexOf: $,) > 0 ifTrue: [
					valueCleaned := $, split: valueCleaned ].

				arg at: 'value' put: valueCleaned ] ] ].

	^ arguments
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> extractInvocationInformation: anInvocationNode [

	| tSize invocationDict |
	tSize := anInvocationNode trailers size.
	invocationDict := Dictionary new.

	tSize > 1
		ifTrue: [
			invocationDict
				at: 'canditate'
				put: (anInvocationNode trailers at: tSize - 1) nameToken value.

			invocationDict
				at: 'receiver'
				put: (self getReceiverFromSmaccInvocationNode: anInvocationNode) ]
		ifFalse: [
			invocationDict
				at: 'canditate'
				put: anInvocationNode atom nameToken value.

			invocationDict at: 'receiver' put: nil ].

	invocationDict at: 'args' put: (self extractArgumentsInformation: (self signatureFromInvocation: anInvocationNode)).

	^ invocationDict
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> functionNamed: aString [

	^ (self model allWithType: FamixPythonFunction)
		  detect: [ :e |
			  e name = aString.
			   ]
		  ifNone: [ nil ]
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> functions [

	^ self model allWithType: FamixPythonFunction
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> getFileContent: aPath [
	"Example of path : '/Users/aurelikama/Documents/Projet/These/parserPythonToJson/sample_design_smell/layers_formation/gh_non_dominating_dow_sampling.py'
		          asFileReference contents."

	^ aPath asFileReference contents
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> getReceiverFromSmaccInvocationNode: anInvocationNode [

	| receiver signature startPos endPos array |
	signature := anInvocationNode asString.


	startPos := signature indexOf: $(.
	endPos := signature indexOf: $( startingAt: startPos + 1.

	endPos := endPos > startPos ifTrue: [
		          array := ((signature copyFrom: startPos + 1 to: endPos - 1)
			                    substrings: '.') asOrderedCollection.

		          receiver := '' join:
			                      (array
				                       collect: [ :a | a ]
				                       from: 1
				                       to: array size - 1) ].
	^ receiver
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> importFromName: anImportFromNode [

	| result |
	result := self visitDotOptDottedName: anImportFromNode.

	^ result
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> importNamed: aString [

	self flag: 'This is wrong, should also check the importing module: several modules can have similar imports'.

	^ (self model allWithType: FamixPythonImport)
		  detect: [ :e | e entityName = aString ]
		  ifNone: [ nil ]
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> imports [

	^ self model allWithType: FamixPythonImport 
]

{ #category : 'initialization' }
FamixPythonImporterVisitor >> initialize [

	super initialize.
	context := Stack new.
	layer := 0.
	model := FamixPythonModel new name: 'default Python Model'
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> invocationArgs: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e |
			  e
				  cacheAt: 'args'
				  ifAbsent: [ false ]
				  ifPresent: [ :name | name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> invocationCandidate: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e |
			  e
				  cacheAt: 'canditate'
				  ifAbsent: [ false ]
				  ifPresent: [ :name | name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> invocationReceiver: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e |
			  e
				  cacheAt: 'receiver'
				  ifAbsent: [ false ]
				  ifPresent: [ :name | name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> invocations [

	^ self model allWithType: FamixPythonInvocation
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> methodNamed: aString inClassNamed: aClassName [

	^ (self model allWithType: FamixPythonMethod)
		  detect: [ :e |
			  e name = aString and: [ e parentType name = aClassName ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> methods [

	^ self model allWithType: FamixPythonMethod 
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> model [
	^ model
]

{ #category : 'accessing - modules' }
FamixPythonImporterVisitor >> moduleFromFonction: aFunctionNode [

	^(self parentFileForNode: aFunctionNode)
]

{ #category : 'accessing - modules' }
FamixPythonImporterVisitor >> moduleNameStringOf: aModuleNode [
	"should push that to the PyInputFileNode"

	aModuleNode isString ifTrue: [ ^aModuleNode ].

	aModuleNode 	filename ifNil: [ ^'Main Module' ].

	^aModuleNode filename basenameWithoutExtension
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> moduleNamed: aString [

	^ (self model allWithType: FamixPythonModule)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> parameterNamed: pName inBehavioural: famixBehavioural [

	^ (famixBehavioural parameters)
		  detect: [ :e | e name = pName ]
		  ifNone: [ nil ]
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> parameters [

	^ self model allWithType: FamixPythonParameter 
]

{ #category : 'accessing - modules' }
FamixPythonImporterVisitor >> parentFileForNode: aPyNode [ 

	aPyNode ifNil: [ ^nil ].
	(aPyNode isKindOf: PyFileNode) ifTrue: [ ^aPyNode ].
	^self parentFileForNode: aPyNode parent
]

{ #category : 'accessing - modules' }
FamixPythonImporterVisitor >> relativeFilePath: aNode [

	| parentFileName |

	parentFileName := (self parentFileForNode: aNode) attributes at: #filename.
	
	rootFilePath ifNil: [	^(parentFileName fullName removePrefix: '/')].

	^(parentFileName relativeTo: rootFilePath asPath) pathString
]

{ #category : 'accessing - modules' }
FamixPythonImporterVisitor >> rootFilePath [

	^ rootFilePath
]

{ #category : 'accessing - modules' }
FamixPythonImporterVisitor >> rootFilePath: aString [

	rootFilePath := aString.
	model rootFolder: aString
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> setSourceAnchor: aFamixEntity from: aSmaccNode [

	aFamixEntity sourceAnchor: (FamixPythonIndexedFileAnchor new
		fileName: (self relativeFilePath: aSmaccNode) ;
		startPos: aSmaccNode startPosition;
		endPos: aSmaccNode stopPosition;
		yourself).

	aFamixEntity stub: false.

	^ aFamixEntity
]

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> signatureFromInvocation: anInvocationNode [

	| signature startPos |
	signature := anInvocationNode asString.
	startPos := signature indexOf: $(.
	startPos := signature indexOf: $( startingAt: startPos + 1.
	signature := signature copyFrom: startPos + 1 to: signature size - 2.
	^ signature copyWithoutAll: '"'
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitAnnotatedSymbol: anAnnotatedSymbol [
	^ super visitAnnotatedSymbol: anAnnotatedSymbol
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitAssignmentStatement: anAssignmentStatement [

	(anAssignmentStatement lhs isKindOf: PyVariableExpressionNode) ifTrue: [ self ensureVariable: anAssignmentStatement lhs name localTo: context top ].

	^ super visitAssignmentStatement: anAssignmentStatement
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitClassDefinition: aClassDef [

	context push: (self ensureClass:  aClassDef).

	super visitClassDefinition: aClassDef.

	^context pop
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitDecorated: aDecoratedNode [

	| decorations decorated |
	decorations := self acceptNodes: aDecoratedNode decorators.
	aDecoratedNode classdef ifNotNil: [ :def | decorated := self acceptNode: def ].
	aDecoratedNode funcdef ifNotNil: [ :def | decorated := self acceptNode: def ].

	(decorations notEmpty and: [ decorated notNil ])
	ifTrue: [ decorated annotationInstances: decorations ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitDecorator: aDecoratorNode [

	| name |
	name := self acceptNode: aDecoratorNode dotted_name.
	^self createAnnotationInstance: aDecoratorNode named: name
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitDottedName: anDottedNameNode [

	^$. join: (anDottedNameNode names collect: [:name | self acceptNode: name])
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitExprStmt: anExprStmt [
	anExprStmt isAssignment ifTrue: [ ^self visitAssignmentStmt: anExprStmt ].
	anExprStmt isLambda ifTrue: [ ^self visitLambda: anExprStmt ].
	super visitExprStmt: anExprStmt.
]

{ #category : 'generated' }
FamixPythonImporterVisitor >> visitFieldAccessExpression: aFieldAccessExpression [

	^ aFieldAccessExpression source
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFile: aFileNode [

	| module |
	module := self
		ensureModuleNamed: (self moduleNameStringOf: aFileNode)
		fromNode: aFileNode.
	context push: module.

	self acceptNodes: aFileNode statements.

	^context pop
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFunctionDefinition: aFunctionDefinition [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| fmx result |

	fmx := context top isClass
		ifTrue: [  self ensureMethod: aFunctionDefinition ]
		ifFalse: [ self ensureFunction: aFunctionDefinition ].
	context push: fmx.

	result := super visitFunctionDefinition: aFunctionDefinition.

	^context pop
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitImportStatement: anImport [

	^ self
		  ensureImport: anImport
		  of: (anImport names collect: [ :name | self acceptNode: name ])
		  from: (self acceptNode: anImport from)
		  aliases: (anImport renames collect: [ :alias | self acceptNode: alias ])
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitInterpolatedString: anInterpolatedString [

	^(anInterpolatedString topParent completeSource
		copyFrom: anInterpolatedString startPosition
		to: anInterpolatedString stopPosition)
		asString
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitLambda: aLambdaNode [

	| fmx result |

	"for now only create lambda if we are inside a function/method
	This is needed because there is a bug in SmaCC"

	({FamixPythonFunction . FamixPythonMethod} includes: context top class) 
	ifFalse: [ ^nil ].

	fmx := self createLambda: aLambdaNode.
	context push: fmx.

	^context pop
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitName: aName [

	^ aName name
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitParameter: aParameter [
	"parameters in a function/methoid definition"

	^ self ensureParameter: aParameter inBehavioural: context top
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitPower: anInvocation [

	anInvocation trailers ifNotEmpty: [
		self createInvocation: anInvocation ].

	^ super visitPower: anInvocation
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitSmaCCError: aSmaCCError [
	^nil
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitSmaCCParseNode: aSmaCCParseNode [
	"override to return the result of the visits"

	^self acceptNodes: aSmaCCParseNode sortedChildren
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitSmaCCToken: aSmaCCToken [
	"introducing this additional visit method regularity of treatment
	 see also extension method to SmaCCToken"

	^aSmaCCToken value
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitString: aStringNode [

	(aStringNode parts size ~= 1 or: [ aStringNode expressions isNotEmpty ]) ifTrue: [
		self error:
			'Before strings where only one part but the Python tree changed. For now Im managing only the simplest case but reaching this error means that we need to manage more.' ].
	^ aStringNode parts anyOne value copyWithoutAll: '"'
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitStrings: aStringsNode [

	^ aStringsNode strings collect: [:each| self acceptNode: each]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitVariableExpression: aVariableExpression [

	^ aVariableExpression name
]
