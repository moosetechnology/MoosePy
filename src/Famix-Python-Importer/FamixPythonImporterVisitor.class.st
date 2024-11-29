Class {
	#name : 'FamixPythonImporterVisitor',
	#superclass : 'PyRootNodeVisitor',
	#traits : 'SRTSolverUserVisitor',
	#classTraits : 'SRTSolverUserVisitor classTrait',
	#instVars : [
		'model',
		'rootFilePath'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'visiting' }
FamixPythonImporterVisitor >> acceptNode: aNode [

	^ self errorReport catch: Error during: [ super acceptNode: aNode ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> acceptNodes: aCollection [
	"override to return the result of the visits"

	^aCollection collect: [ :each | self acceptNode: each ].

]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> basicCreateFunction: aSelector withSignature: aSignature [

	^ model newFunction
		  name: aSelector;
		  isStub: true;
		  signature: aSignature;
		  yourself
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> basicCreateMethod: aSelector withSignature: aSignature [

	^ model newMethod
		  name: aSelector;
		  isStub: true;
		  signature: aSignature;
		  yourself
]

{ #category : 'accessing - classes' }
FamixPythonImporterVisitor >> classNamed: aName [

	^ (self model allWithType: FamixPythonClass)
		  detect: [ :e | e name = aName ]
		  ifNone: [ nil ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createClass: classDefinitionNode [

	| class shadowedEntity |
	"If we are shadowing an entity, we need to mark is as shadowed."
	shadowedEntity := self findSadowedEntityNamed: classDefinitionNode pythonClassName.

	class := model newClassNamed: classDefinitionNode pythonClassName.

	self setSuperclassesOf: classDefinitionNode from: class.

	shadowedEntity ifNotNil: [ class shadowedEntity: shadowedEntity ].
	class typeContainer: self currentEntity.

	^ self setSourceAnchor: class from: classDefinitionNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createFunction: aFunctionNode [

	| function shadowedEntity |
	"If we are shadowing an entity, we need to mark is as shadowed."
	shadowedEntity := self findSadowedEntityNamed: aFunctionNode pythonFunctionName.

	function := self basicCreateFunction: aFunctionNode pythonFunctionName withSignature: aFunctionNode signatureString.
	function functionOwner: self currentEntity.

	shadowedEntity ifNotNil: [ function shadowedEntity: shadowedEntity ].

	^ self setSourceAnchor: function from: aFunctionNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createImport: anImport ofName: aName from: fromName alias: alias [

	| import |
	import := model newImport
		          alias: alias;
		          yourself.

	self setSourceAnchor: import from: anImport.

	self currentEntity addOutgoingImport: import.
	self flag: #todo. "Check how to manage the push before the main entity and the pops."

	"pushResolvableAsScopeBeforeMainEntityScope:"

	self solver
		resolve: (fromName
				 ifNil: [
					 (FamixPythonImportResolvable path: aName)
						 notFoundReplacementEntity: [ :unresolvedImport :currentEntity | self ensureStubPackagesFromPath: unresolvedImport path ];
						 yourself ]
				 ifNotNil: [
					 (FamixPythonFromImportResolvable path: fromName entityName: aName)
						 notFoundReplacementEntity: [ :unresolvedImport :currentEntity |
							 | package |
							 package := self ensureStubPackagesFromPath: unresolvedImport path.

							 (self ensureStubContainerNamed: unresolvedImport entityName)
								 parentPackage: package;
								 yourself ];
						 yourself ])
		foundAction: [ :entity :currentEntity | entity addIncomingImport: import ].

	^ import
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createInvocation: anInvocationNode [

	| invocation tSize invocDict  |
	invocation := model newInvocation.
	tSize := anInvocationNode trailers size.

	invocDict := self extractInvocationInformation: anInvocationNode.

	invocation sender: self currentEntity.
	invocation cacheAt: 'canditate' put: (invocDict at: 'canditate').
	invocation cacheAt: 'args' put: (invocDict at: 'args').
	invocation cacheAt: 'receiver' put: (invocDict at: 'receiver').
	invocation signature:
		(self signatureFromInvocation: anInvocationNode).

	^ self setSourceAnchor: invocation from: anInvocationNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createLambda: aLambdaExpression [

	| lambda |
	lambda := model newLambda.
	lambda signature: aLambdaExpression signatureString.
	lambda lambdaContainer: self currentEntity.

	^ self setSourceAnchor: lambda from: aLambdaExpression
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createMethod: aMethodNode [

	| method signature |
	signature := aMethodNode signatureString.
	method := self basicCreateMethod: aMethodNode name withSignature: signature.

	method parentType: self currentEntity.

	aMethodNode name = '__init__' ifTrue: [ method isConstructor: true ].

	(aMethodNode name beginsWith: 'get_') ifTrue: [
		self
			resolve: ((SRIdentifierWithNode identifier: (aMethodNode name withoutPrefix: 'get_'))
					 expectedKind: FamixPythonAttribute;
					 yourself)
			foundAction: [ :entity :currentEntity | method beGetter ]
			ifNone: [ "We do nothing" ] ].

	(aMethodNode name beginsWith: 'set_') ifTrue: [
		self
			resolve: ((SRIdentifierWithNode identifier: (aMethodNode name withoutPrefix: 'set_'))
					 expectedKind: FamixPythonAttribute;
					 yourself)
			foundAction: [ :entity :currentEntity | method beSetter ]
			ifNone: [ "We do nothing" ] ].

	^ self setSourceAnchor: method from: aMethodNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> createModule: aModuleNode named: aName [

	| module |
	module := model newModule.
	module name: aName.

	self setSourceAnchor: module from: aModuleNode.

	"The FileNode exclude things such as the comments at the beginning of files so we just put again manually the whole file"
	module sourceAnchor
		startPos: 1;
		endPos: aModuleNode fileReference size.

	^ module
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
FamixPythonImporterVisitor >> createWriteAccessTo: variable from: anAssignmentNode [

	| access |
	access := model newAccess
		          variable: variable;
		          accessor: self currentEntity;
		          isWrite: true;
		          yourself.
	self setSourceAnchor: access from: anAssignmentNode
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureMethod: aMethodNode [

	^ (self methodNamed: aMethodNode fname value inClassNamed: self currentEntity name) ifNil: [ self createMethod: aMethodNode ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureModuleNamed: moduleName fromNode: aModuleNode [

	self withCurrentEntityDo: [ :entity | (entity childOfType: FamixTModule named: moduleName) ifNotNil: [ :module | ^ module ] ].

	^ self createModule: aModuleNode named: moduleName
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensurePackageFromNode: aFileNode [

	^ (self packageNamed: aFileNode packageName) ifNil: [
		  | package |
		  package := model newPackageNamed: aFileNode packageName.
		  self setSourceAnchor: package from: aFileNode.
		  package ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureParameter: parameter inBehavioural: aBehavioralEntity [

	^ (self parameterNamed:parameter parameterName inBehavioural: aBehavioralEntity)
		ifNil: [ self createParameter: parameter inBehavioural: aBehavioralEntity ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubClassNamed: aName [

	^ model allClasses
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [
			  (model newClassNamed: aName)
				  isStub: true;
				  yourself ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubContainerNamed: aString [

	^ (self unknownImportedNamed: aString) ifNil: [
		  model newUnknownImportedEntity
			  name: aString;
			  isStub: true;
			  yourself ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubPackageNamed: aString [

	^ (self packageNamed: aString) ifNil: [
		  (model newPackageNamed: aString)
			  isStub: true;
			  yourself ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubPackagesFromPath: aPythonImportPath [
	"This method takes a python import path and should ensure we have a stub entity for each. It should return the stub package for the last element of the path too."

	| splitted package |
	splitted := aPythonImportPath splitOn: $..
	package := self model rootEntities
		           detect: [ :entity | entity isPackage and: [ entity name = splitted first ] ]
		           ifNone: [ self ensureStubPackageNamed: splitted first ].
	splitted removeFirst.

	[ splitted isEmpty ] whileFalse: [
		package := package childEntities
			           detect: [ :entity | entity isPackage and: [ entity name = splitted first ] ]
			           ifNone: [
				           (self ensureStubPackageNamed: splitted first)
					           parentPackage: package;
					           yourself ].

		splitted removeFirst ].

	^ package
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

{ #category : 'accessing' }
FamixPythonImporterVisitor >> findSadowedEntityNamed: name [
	"If the same element already has a shadowable entity of the same name, we select the last one defined. If there is none, we return nil"

	self withCurrentEntityDo: [ :entity |
		((entity query descendants ofType: FamixTShadowable) select: [ :child | child name = name ]) ifNotEmpty: [ :entities |
			^ entities detectMax: [ :anEntity | anEntity sourceAnchor startPos ] ] ].

	^ nil
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

{ #category : 'accessing - methods' }
FamixPythonImporterVisitor >> imports [

	^ self model allWithType: FamixPythonImport 
]

{ #category : 'initialization' }
FamixPythonImporterVisitor >> initialize [

	super initialize.
	model := FamixPythonModel new name: 'default Python Model'.
	self initialiseSolver
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
FamixPythonImporterVisitor >> packageNamed: aString [

	^ self model allPackages
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
		mooseModel: self model;
		yourself).

	aFamixEntity stub: false.

	^ aFamixEntity
]

{ #category : 'as yet unclassified' }
FamixPythonImporterVisitor >> setSuperclassesOf: classDefinitionNode from: class [

	^ (classDefinitionNode superClasses reject: [ :aClass | aClass class = PyMetaclassNode ])
		  ifEmpty: [
			  model newInheritance
				  superclass: (self ensureStubClassNamed: 'object');
				  subclass: class ]
		  ifNotEmpty: [ :superclasses |
			  superclasses do: [ :superclass |
				  | inheritance |
				  inheritance := model newInheritance.
				  inheritance subclass: class.
				  self
					  resolve: ((SRIdentifierWithNode identifier: superclass name)
							   expectedKind: FamixPythonClass;
							   notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ];
							   yourself)
					  foundAction: [ :entity :currentEntity | inheritance superclass: entity ] ] ]
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

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> unknownImportedNamed: aString [

	^ self model entities
		  detect: [ :e | e class = FamixPythonUnknownImportedEntity and: [ e name = aString ] ]
		  ifNone: [ nil ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitClassDefinition: aClassDef [

	^ self useCurrentEntity: (self createClass: aClassDef) during: [ super visitClassDefinition: aClassDef ]
]

{ #category : 'generated' }
FamixPythonImporterVisitor >> visitFieldAccessExpression: aFieldAccessExpression [
	"If the receiver is self in an assignation then we have an assignation to an instance variable"

	aFieldAccessExpression isInstanceVariableAssignation ifTrue: [
		| class variable |
		class := self currentEntityOfType: FamixPythonClass.

		variable := (class childOfType: FamixTAttribute named: aFieldAccessExpression name) ifNil: [
			            variable := self model newAttribute
				                        name: aFieldAccessExpression name;
				                        parentType: class;
				                        isClassSide: false;
				                        yourself.

			            "We select the lhs node because the source anchor should not be the full assignation."
			            self setSourceAnchor: variable from: aFieldAccessExpression.
			            variable ].
		self createWriteAccessTo: variable from: aFieldAccessExpression assignationNode.
		^ variable ].

	^ aFieldAccessExpression source
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFile: aFileNode [

	| isPackageDeclaration entity |
	"If the file is name __init__.py this means that we have the declaration of a package. Else we have a module that can be in a package."
	isPackageDeclaration := aFileNode fileReference basename = '__init__.py'.
	entity := isPackageDeclaration
		          ifTrue: [ self ensurePackageFromNode: aFileNode ]
		          ifFalse: [ self ensureModuleNamed: (self moduleNameStringOf: aFileNode) fromNode: aFileNode ].

	self solver scopeIsEmpty ifFalse: [
		self assert: self currentEntity isPackage.
		entity parentPackage: self currentEntity ].

	(self currentEntity: entity) isMainEntity: true.

	self acceptNodes: aFileNode statements.

	"If we are in a package declaration we need to keep the package in the context for the modules in the package. The package will be pop later by the importer."
	^ isPackageDeclaration
		  ifTrue: [ self currentEntity ]
		  ifFalse: [ self popScope ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFunctionDefinition: aFunctionDefinition [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| fmx |
	fmx := self currentEntity isClass
		       ifTrue: [ self ensureMethod: aFunctionDefinition ]
		       ifFalse: [ self createFunction: aFunctionDefinition ].
	^ self useCurrentEntity: fmx during: [ super visitFunctionDefinition: aFunctionDefinition ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitImportStatement: anImport [

	| importedEntities aliases |
	importedEntities := anImport names collect: [ :name | self acceptNode: name ].
	aliases := anImport from
		           ifNil: [ anImport renames collect: [ :alias | self acceptNode: alias ] ]
		           ifNotNil: [ anImport names collect: [ :name | name alias ] ].

	importedEntities withIndexDo: [ :importName :i |
		| alias |
		alias := aliases at: i ifAbsent: [ nil ].
		self
			createImport: anImport
			ofName: importName
			from: (self acceptNode: anImport from)
			alias: alias ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitLambdaExpression: aLambdaExpression [

	^ self useCurrentEntity: (self createLambda: aLambdaExpression) during: [ super visitLambdaExpression: aLambdaExpression ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitListParameter: aListParameter [
	"We'll manage it later"

	self flag: #todo
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitMetaclass: aMetaclass [

	| metaClassName metaClassObject |
	metaClassName := aMetaclass superclass name.
	metaClassObject := self classNamed: metaClassName.
	metaClassObject ifNil: [
		metaClassObject := model newClass
			                   name: metaClassName;
			                   stub: true ].
	self currentEntity metaclass: metaClassObject
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitName: aName [

	^ aName name
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitParameter: aParameter [
	"parameters in a function/methoid definition"

	^ self ensureParameter: aParameter inBehavioural: self currentEntity
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitRelativeName: aRelativeName [

	^ aRelativeName source
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

	^ (aStringNode source withoutPrefix: '''') withoutSuffix: ''''
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitVariableExpression: aVariableExpression [
	"This node is used in multiple situations. If it is in an assignation we need to check if the variable we assign is created. Other uses can be for example in an import, in this case we want to only return the name."

	aVariableExpression isLeftSideOfAssignation ifTrue: [
		| variable |
		"If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
		(self currentEntity query descendants ofType: FamixTStructuralEntity)
			detect: [ :child | child name = aVariableExpression name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
			ifFound: [ :var | variable := var ]
			ifNone: [
				| shadowedEntity |
				shadowedEntity := self findSadowedEntityNamed: aVariableExpression name.
				variable := self currentEntity createLocalVariable: aVariableExpression name.
				shadowedEntity ifNotNil: [ variable shadowedEntity: shadowedEntity ].
				"We select the lhs node because the source anchor should not be the full assignation."
				self setSourceAnchor: variable from: aVariableExpression ].

		self createWriteAccessTo: variable from: aVariableExpression assignationNode.
		^ variable ].

	aVariableExpression isReceiverOfFunctionCall ifTrue: [
		self flag: #todo.
		^ aVariableExpression name ].

	"We do not deal with reserved literals in Famix and imports only need the names.."
	(aVariableExpression isReservedLiteral or: [ aVariableExpression isInImport ]) ifTrue: [ ^ aVariableExpression name ].

	self
		resolve: ((SRIdentifierWithNode identifier: aVariableExpression name)
				 expectedKind: {
						 FamixPythonClass.
						 FamixPythonLocalVariable.
						 FamixPythonGlobalVariable.
						 FamixPythonAttribute.
						 FamixPythonParameter };
				 notFoundReplacementEntity: [ :unresolved :currentEntity | self ensureStubClassNamed: unresolved identifier ];
				 yourself)
		foundAction: [ :entity :currentEntity | "In case of a class, we need to create a reference. In case of a structural entity we have a read access."
			entity isClass
				ifTrue: [  ]
				ifFalse: [
					| access |
					access := model newAccess.
					access variable: entity.
					access accessor: currentEntity.
					access isWrite: false.
					self setSourceAnchor: access from: aVariableExpression ] ].

	^ aVariableExpression name
]
