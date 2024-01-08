Class {
	#name : #MSEPythonToFamixImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'model',
		'layer',
		'rootFilePath',
		'context'
	],
	#category : #'MoosePy-Visitors'
}

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> acceptNodes: aCollection [
	"override to return the result of the visits"

	^aCollection collect: [ :each | self acceptNode: each ].

]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> annotationTypeNamed: aString [ 

	^ (self model allWithType: FamixPythonAnnotationType)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

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

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> context [

	^ context
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> contextModule [

	"rather ugly, but I did not want to add methods in the meta-model for this"

	| top |
	top := context firstLink.
	[  top value class = FamixPythonModule ]
	whileFalse: [ top := top nextLink ].

	^top value
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createAnnotationInstance: aPyDecoratorNode named: aString [ 

	^model newAnnotationInstance
		annotationType: (self ensureAnnotationTypeNamed: aString) ;
		yourself
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createAnnotationTypeNamed: aString [ 

	^model newAnnotationType
		name:  aString ;
		yourself
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createClass: aClass [

	| class name |
	name := aClass cname value.
	class := model newClass.
	class name: aClass cname value.
	
	^ self setSourceAnchor: class from: aClass
	
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createFunction: aFunctionNode [

	| function signature |
	signature := aFunctionNode parameters ifNotNil: [
		             aFunctionNode parameters signatureString ].
	function := self
		basicCreateFunction: aFunctionNode fname value
		withSignature: signature.

	function functionOwner: context top.

	^ self setSourceAnchor: function from: aFunctionNode
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createImport: anImport ofName: aName from: fromName alias: alias [

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

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createInvocation: anInvocationNode [

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

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createMethod: aMethodNode [

	| method |
	method := self
		          basicCreateMethod: aMethodNode fname value
		          withSignature: aMethodNode parameters signatureString.

	method parentType: context top.

	^ self setSourceAnchor: method from: aMethodNode
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createModule: aModuleNode named: aName [

	| module |
	module := model newModule.
	module name: aName.

	^ self setSourceAnchor: module from: aModuleNode
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createParameter: aParameter inBehavioural: aFamixContainer [

	| parameterName parameter |
	parameterName := aParameter nameToken value.
	parameter := model newParameter.
	parameter name: parameterName.

	parameter parentBehaviouralEntity: aFamixContainer.
	
	^ self setSourceAnchor: parameter from: aParameter.


]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureAnnotationTypeNamed: aString [ 

	^ (self annotationTypeNamed: aString) ifNil: [
		  self createAnnotationTypeNamed: aString ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureClass: aClassNode [

	^ (self classNamed: aClassNode cname value) ifNil: [
		  self createClass: aClassNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureFunction: aFunctionNode [

	^ (self functionNamed: aFunctionNode fname value) ifNil: [
		  self createFunction: aFunctionNode  ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureImport: anImportNode of: importedNames from: aName aliases: aliasNames [

	importedNames withIndexDo: [ :importName :i |
		(self importNamed: importName) ifNil: [ | alias |
			aliasNames
				ifEmpty: [ alias := nil ]
				ifNotEmpty: [ alias := aliasNames at: i ].
			self createImport: anImportNode ofName: importName from: aName alias: alias
		]
	]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureMethod: aMethodNode [

	^ (self
		   methodNamed: aMethodNode fname value
		   inClassNamed: context top name) ifNil: [
		  self createMethod: aMethodNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureModuleFromFileInputNode: aFileInputNode [

	^self ensureModuleNamed: aFileInputNode filename basename withoutExtension  fromNode: aFileInputNode 
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureModuleNamed: moduleName fromNode: aModuleNode [

	^ (self moduleNamed: moduleName) ifNil: [ self createModule: aModuleNode named: moduleName ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureParameters: theParameters inBehavioural: aFamixBehavioural [

	^ theParameters ifNotNil: [
		  theParameters args collect: [ :parameter |
			  (self
				   parameterNamed: parameter nameToken value
				   inBehavioural: aFamixBehavioural ) ifNil: [
				  self createParameter: parameter inBehavioural: aFamixBehavioural ] ] ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> extractArgumentsInformation: aSignature [

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

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> extractInvocationInformation: anInvocationNode [

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
MSEPythonToFamixImporterVisitor >> getFileContent: aPath [
	"Example of path : '/Users/aurelikama/Documents/Projet/These/parserPythonToJson/sample_design_smell/layers_formation/gh_non_dominating_dow_sampling.py'
		          asFileReference contents."

	^ aPath asFileReference contents
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> getReceiverFromSmaccInvocationNode: anInvocationNode [

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

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> importFromName: anImportFromNode [

	| result |
	result := self visitDotOptDottedName: anImportFromNode.

	^ result
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
	context := Stack new.
	layer := 0.
	model := FamixPythonModel new name: 'default Python Model'
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> invocationArgs: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e |
			  e
				  cacheAt: 'args'
				  ifAbsent: [ false ]
				  ifPresent: [ :name | name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> invocationCandidate: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e |
			  e
				  cacheAt: 'canditate'
				  ifAbsent: [ false ]
				  ifPresent: [ :name | name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> invocationReceiver: aString [

	^ (self model allWithType: FamixPythonInvocation)
		  detect: [ :e |
			  e
				  cacheAt: 'receiver'
				  ifAbsent: [ false ]
				  ifPresent: [ :name | name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> invocations [

	^ self model allWithType: FamixPythonInvocation
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> methodNamed: aString inClassNamed: aClassName [

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
MSEPythonToFamixImporterVisitor >> moduleFromFonction: aFunctionNode [

	^(self parentFileForNode: aFunctionNode)
]

{ #category : #TOREMOVE }
MSEPythonToFamixImporterVisitor >> moduleNameFromFonction: aNode [

	^(self relativeFilePath: aNode) removeSuffix: '.py'
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> moduleNameStringOf: aModuleNode [
	"should push that to the PyInputFileNode"

	aModuleNode isString ifTrue: [ ^aModuleNode ].

	aModuleNode 	filename ifNil: [ ^'Main Module' ].

	^aModuleNode filename basenameWithoutExtension
]

{ #category : #'private - testing' }
MSEPythonToFamixImporterVisitor >> moduleNamed: aString [

	^ (self model allWithType: FamixPythonModule)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> parameterNamed: pName inBehavioural: famixBehavioural [

	^ (famixBehavioural parameters)
		  detect: [ :e | e name = pName ]
		  ifNone: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> parameters [

	^ self model allWithType: FamixPythonParameter 
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> parentFileForNode: aPyNode [ 

	aPyNode ifNil: [ ^nil ].
	(aPyNode isKindOf: PyFileInputNode) ifTrue: [ ^aPyNode ].
	^self parentFileForNode: aPyNode parent
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> relativeFilePath: aNode [

	| parentFileName |

	parentFileName := (self parentFileForNode: aNode) attributes at: #filename.
	
	rootFilePath ifNil: [	^(parentFileName fullName removePrefix: '/')].

	^(parentFileName relativeTo: rootFilePath asPath) pathString
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> rootFilePath [

	^ rootFilePath
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> rootFilePath: aString [

	rootFilePath := aString.
	model rootFolder: aString
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> setSourceAnchor: aFamixEntity from: aSmaccNode [

	aFamixEntity sourceAnchor: (FamixPythonIndexedFileAnchor new
		fileName: (self relativeFilePath: aSmaccNode) ;
		startPos: aSmaccNode startPosition;
		endPos: aSmaccNode stopPosition;
		yourself).

	aFamixEntity stub: false.

	^ aFamixEntity
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> signatureFromInvocation: anInvocationNode [

	| signature startPos |
	signature := anInvocationNode asString.
	startPos := signature indexOf: $(.
	startPos := signature indexOf: $( startingAt: startPos + 1.
	signature := signature copyFrom: startPos + 1 to: signature size - 2.
	^ signature copyWithoutAll: '"'
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitAnnotatedSymbol: anAnnotatedSymbol [
	^ super visitAnnotatedSymbol: anAnnotatedSymbol
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitClassdef: aClassDef [

	context push: (self ensureClass:  aClassDef).

	super visitClassdef: aClassDef.

	^context pop
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitDecorated: aDecoratedNode [

	| decorations decorated |
	decorations := self acceptNodes: aDecoratedNode decorators.
	aDecoratedNode classdef ifNotNil: [ :def | decorated := self acceptNode: def ].
	aDecoratedNode funcdef ifNotNil: [ :def | decorated := self acceptNode: def ].

	(decorations notEmpty and: [ decorated notNil ])
	ifTrue: [ decorated annotationInstances: decorations ]
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitDecorator: aDecoratorNode [

	| name |
	name := self acceptNode: aDecoratorNode dotted_name.
	^self createAnnotationInstance: aDecoratorNode named: name
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitDottedName: anDottedNameNode [

	^$. join: (anDottedNameNode names collect: [:name | self acceptNode: name])
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFileInput: aFileInputNode [

	| module |
	module := self
		ensureModuleNamed: (self moduleNameStringOf: aFileInputNode)
		fromNode: aFileInputNode.
	context push: module.

	self acceptNodes: aFileInputNode statements.

	^context pop
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFuncdef: aFuncdef [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| fmx result |

	fmx := context top isClass
		ifTrue: [  self ensureMethod: aFuncdef ]
		ifFalse: [ self ensureFunction: aFuncdef ].
	context push: fmx.

	result := super visitFuncdef: aFuncdef.

	^context pop
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitImport: anImport [

	^self
		ensureImport: anImport
		of: (anImport names collect: [ :name | self acceptNode: name ])
		from: (self acceptNode: anImport from)
		aliases: (anImport renames collect: [ :alias | self acceptNode: alias ])
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitInterpolatedString: anInterpolatedString [

	^(anInterpolatedString topParent completeSource
		copyFrom: anInterpolatedString startPosition
		to: anInterpolatedString stopPosition)
		asString
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitName: aName [
	^self acceptNode: aName name
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitPower: anInvocation [

	anInvocation trailers ifNotEmpty: [
		self createInvocation: anInvocation ].

	^ super visitPower: anInvocation
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitSmaCCError: aSmaCCError [
	^nil
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitSmaCCParseNode: aSmaCCParseNode [
	"override to return the result of the visits"

	^self acceptNodes: aSmaCCParseNode sortedChildren
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitSmaCCToken: aSmaCCToken [
	"introducing this additional visit method regularity of treatment
	 see also extension method to SmaCCToken"

	^aSmaCCToken value
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitString: aStringNode [

	^ aStringNode value value copyWithoutAll: '"'
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitStrings: aStringsNode [

	^ aStringsNode strings collect: [:each| self acceptNode: each]
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitVarArgList: aVarArgList [
	"parameters in a function/methoid definition"

	^self
		ensureParameters: aVarArgList
		inBehavioural: context top.

]
