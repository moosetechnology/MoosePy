Class {
	#name : 'FamixPythonImporterVisitor',
	#superclass : 'PyRootNodeVisitor',
	#traits : 'SRTSolverUserVisitor',
	#classTraits : 'SRTSolverUserVisitor classTrait',
	#instVars : [
		'model',
		'rootFilePath',
		'importPaths'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'visiting' }
FamixPythonImporterVisitor >> acceptNode: aNode [

	^ self errorReport catch: Exception during: [ super acceptNode: aNode ]
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
		          isFromImport: fromName isNotNil;
		          yourself.

	self setSourceAnchor: import from: anImport.

	self currentEntity addOutgoingImport: import.

	importPaths at: import put: ((fromName
	 ifNil: [ aName ]
	 ifNotNil: [ fromName ]) copyWithout: Character space).

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

							 (self ensureStubUnknownEntityNamed: unresolvedImport entityName) "This entity can be a package on a module."
								 parentPackage: package;
								 yourself ];
						 yourself ])
		foundAction: [ :entity :currentEntity | entity addIncomingImport: import ].

	^ import
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> createInvocationOf: target from: currentEntity node: aPyNode [

	| invocation |
	invocation := self model newInvocation
		              sender: currentEntity;
		              signature: aPyNode source;
		              yourself.
	target isCollection
		ifTrue: [ invocation candidates: target ]
		ifFalse: [ invocation invokedEntity: target ].
	self setSourceAnchor: invocation from: aPyNode.
	^ invocation
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
FamixPythonImporterVisitor >> ensureStubFunctionNamed: aName [

	^ model allFunctions
		  detect: [ :function | function isStub and: [ function name = aName ] ]
		  ifNone: [
			  (model newFunctionNamed: aName)
				  isStub: true;
				  yourself ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubMethodNamed: aName [

	^ model allMethods
		  detect: [ :method | method isStub and: [ method name = aName ] ]
		  ifNone: [
			  (model newMethodNamed: aName)
				  isStub: true;
				  yourself ]
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubPackageNamed: aString [

	^ model allPackages
		  detect: [ :class | class isStub and: [ class name = aString ] ]
		  ifNone: [
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

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> ensureStubUnknownEntityNamed: aString [

	^ (self unknownEntityNamed: aString) ifNil: [
		  model newUnknownEntity
			  name: aString;
			  yourself ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> findImportMatchingSource: aString ifFound: aBlock [
	"If I get a string such as `matplotlib.pyglot.array()`, I'll check if we have an import that is not a from import matching `matplotlib.pyglot` and execute the block as parameter if this is the case.
	
	I also manages the case of aliases like this:
	
	```python
	import matplotlib.pyglot as mp
	
	mp.array()
	```
	
	This method is useful to resolve accesses, invocations and references of imported entities.
	"

	| source |
	source := aString copyWithoutAll: ' '.
	^ self currentEntity allEffectiveSimpleImports
		  detect: [ :import |
			  | importPath |
			  importPath := import hasAlias
				                ifTrue: [ import alias ]
				                ifFalse: [ importPaths at: import ].
			  aString = importPath or: [
				  importPath := importPath , '.'.
				  importPath := importPath copyWithoutAll: ' '.
				  (source beginsWith: importPath) and: [ ((source withoutPrefix: importPath) includes: $.) not ] ] ]
		  ifFound: aBlock
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> findSadowedEntityNamed: name [
	"If the same element already has a shadowable entity of the same name, we select the last one defined. If there is none, we return nil"

	self withCurrentEntityDo: [ :entity |
		((entity query descendants ofType: FamixTShadowable) select: [ :child | child name = name ]) ifNotEmpty: [ :entities |
			^ entities detectMax: [ :anEntity | anEntity sourceAnchor startPos ] ] ].

	^ nil
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> getConstructorOf: aClass [

	^ aClass methods
		  detect: [ :method | method isConstructor ]
		  ifNone: [
			  (model newMethodNamed: '__init__')
				  isStub: true;
				  isConstructor: true;
				  parentType: aClass;
				  yourself ]
]

{ #category : 'initialization' }
FamixPythonImporterVisitor >> initialize [

	super initialize.
	model := FamixPythonModel new name: 'default Python Model'.
	model sourceLanguage: model newSourceLanguage.
	self initialiseSolver.
	importPaths := IdentityDictionary new
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> methodNamed: aString inClassNamed: aClassName [

	^ (self model allWithType: FamixPythonMethod)
		  detect: [ :e |
			  e name = aString and: [ e parentType name = aClassName ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
FamixPythonImporterVisitor >> model [
	^ model
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

{ #category : 'visiting' }
FamixPythonImporterVisitor >> resolveInvocationOrInstantiationFrom: aFunctionCallExpression [
	"When we end up here we might have multiple cases to manage:
	- x() => This is either a function invocation or instantiation. There should be no stub. 
	- package.module.x() => Function invocation of instantiation comming from one of the import. Stub is an unknown entity.
	- self.x() => Method invocation. There should be no stub.
	- c.x() => Method invocation. Can be a stub method
	- x()() => Invocation or Instantiation of the result of another invocation. This we cannot really treat it here so for now I'll just ignore this case.
	- table[x]() => Same as above but with the content of a table"

	" => x()()/table[x]()
	This is happening when we invoke the result of an invocation. The parser cannot know what is invoked. I'm ignoring it"
	({ PyFunctionCallExpressionNode . PySubscriptExpressionNode } anySatisfy: [ :class | aFunctionCallExpression receiver isKindOf: class ] ) ifTrue: [ ^ self ].

	"=> x()"
	aFunctionCallExpression hasReceiver ifFalse: [
		^ self
			  resolve: ((FamixPythonInvocationOrInstantiationResolvable identifier: aFunctionCallExpression receiver name)
					   expectedKind: { FamixPythonFunction . FamixPythonClass };
					   notFoundReplacementEntity: [ :unresolved :currentEntity | { (self ensureStubUnknownEntityNamed: unresolved identifier) } ]; "This one can be a function or a class"
					   yourself)
			  foundAction: [ :result :currentEntity |
				  (result isCollection not and: [ result isClass ])
					  ifTrue: [
						  | reference |
						  reference := result createAccessOrReferenceFrom: currentEntity node: aFunctionCallExpression.
						  self setSourceAnchor: reference from: aFunctionCallExpression.

						  self createInvocationOf: (self getConstructorOf: result) from: currentEntity node: aFunctionCallExpression ]
					  ifFalse: [ self createInvocationOf: result from: currentEntity node: aFunctionCallExpression ] ] ].

	"=> self.x()"
	aFunctionCallExpression isLocalMethodInvocation ifTrue: [
		^ self
			  resolve: (FamixPythonLocalMethodInvocationResolvable identifier: aFunctionCallExpression receiver name)
			  foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aFunctionCallExpression ] ].

	"=> package.module.x()"
	self findImportMatchingSource: aFunctionCallExpression receiver source ifFound: [ :import |
		^ self
			  resolve: ((FamixPythonInvocationOrInstantiationWithNamespaceResolvable identifier: aFunctionCallExpression receiver name import: import)
					   expectedKind: { FamixPythonFunction . FamixPythonClass };
					   notFoundReplacementEntity: [ :unresolved :currentEntity | { (self ensureStubUnknownEntityNamed: unresolved identifier) } ]; "This one can be a function or a class"
					   yourself)
			  foundAction: [ :result :currentEntity |
				  (result isCollection not and: [ result isClass ])
					  ifTrue: [
						  | reference |
						  reference := result createAccessOrReferenceFrom: currentEntity node: aFunctionCallExpression.
						  self setSourceAnchor: reference from: aFunctionCallExpression.

						  self createInvocationOf: (self getConstructorOf: result) from: currentEntity node: aFunctionCallExpression ]
					  ifFalse: [ self createInvocationOf: result from: currentEntity node: aFunctionCallExpression ] ] ].

	"=> c.x()"
	^ self
		  resolve: ((FamixPythonMethodInvocationResolvable identifier: aFunctionCallExpression receiver name)
				   notFoundReplacementEntity: [ :unresolved :currentEntity | { (self ensureStubMethodNamed: unresolved identifier) } ]; "This one can be a function or a class"
				   yourself)
		  foundAction: [ :methods :currentEntity | self createInvocationOf: methods from: currentEntity node: aFunctionCallExpression ]
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

	^ self
		  setSourceAnchorTo: aFamixEntity
		  fileName: (self relativeFilePath: aSmaccNode)
		  start: aSmaccNode startPosition
		  end: aSmaccNode stopPosition
]

{ #category : 'private-entity-creation' }
FamixPythonImporterVisitor >> setSourceAnchorTo: aFamixEntity fileName: aString start: aNumber end: anotherNumber [

	aFamixEntity sourceAnchor: (FamixPythonIndexedFileAnchor new
			 fileName: aString;
			 startPos: aNumber;
			 endPos: anotherNumber;
			 mooseModel: self model;
			 yourself).

	(aFamixEntity class includesTrait: FamixTCanBeStub) ifTrue: [ aFamixEntity isStub: false ].

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
				  self setSourceAnchor: inheritance from: superclass.
				  self
					  resolve: ((SRIdentifierWithNode identifier: superclass name)
							   expectedKind: FamixPythonClass;
							   notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ];
							   yourself)
					  foundAction: [ :entity :currentEntity | inheritance superclass: entity ] ] ]
]

{ #category : 'private - searching' }
FamixPythonImporterVisitor >> unknownEntityNamed: aString [

	^ (self model allWithType: FamixPythonUnknownEntity)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : 'generated' }
FamixPythonImporterVisitor >> visitAssignedInstanceVariable: anAssignedInstanceVariable [

	| class variable |
	class := self currentEntityOfType: FamixPythonClass.

	variable := (class childOfType: FamixTAttribute named: anAssignedInstanceVariable name) ifNil: [
		            variable := self model newAttribute
			                        name: anAssignedInstanceVariable name;
			                        parentType: class;
			                        isClassSide: false;
			                        yourself.

		            "We select the lhs node because the source anchor should not be the full assignation."
		            self setSourceAnchor: variable from: anAssignedInstanceVariable.
		            variable ].
	self createWriteAccessTo: variable from: anAssignedInstanceVariable assignationNode.
	^ variable
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitAssignedVariable: anAssignedVariable [

	| variable |
	"If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
	(self currentEntity query descendants ofType: FamixTStructuralEntity)
		detect: [ :child | child name = anAssignedVariable name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
		ifFound: [ :var | variable := var ]
		ifNone: [
			| shadowedEntity |
			shadowedEntity := self findSadowedEntityNamed: anAssignedVariable name.
			variable := self currentEntity createLocalVariable: anAssignedVariable name.
			shadowedEntity ifNotNil: [ variable shadowedEntity: shadowedEntity ].
			"We select the lhs node because the source anchor should not be the full assignation."
			self setSourceAnchor: variable from: anAssignedVariable ].

	self createWriteAccessTo: variable from: anAssignedVariable assignationNode.
	^ variable
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitClassDefinition: aClassDef [

	^ self useCurrentEntity: (self createClass: aClassDef) during: [ super visitClassDefinition: aClassDef ]
]

{ #category : 'generated' }
FamixPythonImporterVisitor >> visitFieldAccessExpression: aFieldAccessExpression [

	| source |
	source := aFieldAccessExpression source.

	self flag: #todo. "Manage invocations."
	aFieldAccessExpression isReceiverOfFunctionCall ifTrue: [ ^ source ].

	"Symbol resolution of accesses and references to imported entities.
	Example:
	
	import moduleAtRoot
	print(moduleAtRoot.moduleVariable)
	"
	self findImportMatchingSource: source ifFound: [ :import |
		self
			resolve: ((FamixPythonImportedAccessOrReferenceResolvable identifier: aFieldAccessExpression name import: import)
					 notFoundReplacementEntity: [ :unresolved :currentEntity | "This unknown entity can be a variable or a class."
						 self ensureStubUnknownEntityNamed: unresolved identifier ];
					 yourself)
			foundAction: [ :entity :currentEntity |
				| association |
				association := entity createAccessOrReferenceFrom: currentEntity node: aFieldAccessExpression.
				self setSourceAnchor: association from: aFieldAccessExpression ].
		^ source ].

	aFieldAccessExpression source traceCr.

	^ source
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFile: aFileNode [

	| isPackageDeclaration entity |
	"If a package or module starts by a comment, the comment is ignored by SmaCC but we don't want to ignore it so we ensure the start pos is at the beginning of the file."
	aFileNode startPosition: 1.

	FamixPythonSmaCCASTSpecializer new acceptNode: aFileNode.

	"If the file is name __init__.py this means that we have the declaration of a package. Else we have a module that can be in a package."
	isPackageDeclaration := aFileNode fileReference basename = '__init__.py'.
	entity := isPackageDeclaration
		          ifTrue: [ self ensurePackageFromNode: aFileNode ]
		          ifFalse: [ self createModule: aFileNode named: (self moduleNameStringOf: aFileNode) ].

	self solver scopeIsEmpty ifFalse: [
		self assert: self currentEntity isPackage.
		entity parentPackage: self currentEntity ].

	(self currentEntity: entity) isMainEntity: true.

	self acceptNodes: aFileNode statements.

	FamixPythonCommentsImporter importCommentsOf: aFileNode visitor: self.

	"If we are in a package declaration we need to keep the package in the context for the modules in the package. The package will be pop later by the importer."
	^ isPackageDeclaration
		  ifTrue: [ self currentEntity ]
		  ifFalse: [ self popScope ]
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFunctionCallExpression: aFunctionCallExpression [

	self resolveInvocationOrInstantiationFrom: aFunctionCallExpression.

	^ super visitFunctionCallExpression: aFunctionCallExpression
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitFunctionCallReceiverVariable: aFunctionCallReceiverVariable [

	self flag: #todo.
	^ aFunctionCallReceiverVariable name
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

{ #category : 'generated' }
FamixPythonImporterVisitor >> visitImportPath: anImportPath [

	^ anImportPath source
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
FamixPythonImporterVisitor >> visitImportVariableExpression: anImportVariableExpression [

	^ anImportVariableExpression name
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitInternalInstanceVariableAccess: anInternalInstanceVariableAccess [

	self
		resolve: ((SRIdentifierWithNode identifier: anInternalInstanceVariableAccess name)
				 expectedKind: { FamixPythonAttribute };
				 yourself)
		foundAction: [ :entity :currentEntity |
			| association |
			association := entity createAccessOrReferenceFrom: currentEntity node: anInternalInstanceVariableAccess.
			self setSourceAnchor: association from: anInternalInstanceVariableAccess ].

	^ anInternalInstanceVariableAccess source
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
FamixPythonImporterVisitor >> visitPlaceholderVariable: aPlaceholderVariable [
	"We do not deal with placeholder variables here."

	^ aPlaceholderVariable name
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitRelativeName: aRelativeName [

	^ aRelativeName source
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitReservedLiteral: aReservedLiteral [
	"We do not deal with reserved literals here."

	^ aReservedLiteral name
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
FamixPythonImporterVisitor >> visitString: aString [
	"If a string is not assigned to anything it is considered as a comment. "

	aString parent isExpressionStatement ifTrue: [
		aString topParent multilineComments add: (Array with: aString startPosition with: (aString topParent stopPosition min: aString stopPosition + 1)) "Take the line return. This might not work on files from windows since it's CRLF alos we can have spaces before the line return. We should maybe do something more robust." ].

	^ super visitString: aString
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitSuperclass: aSuperclass [
	"We should not look for the class here because it might not exist yet. So we delegate to the symbol resolution in the creation of the class."

	^ aSuperclass name
]

{ #category : 'visiting' }
FamixPythonImporterVisitor >> visitVariableExpression: aVariableExpression [

	self
		resolve: ((SRIdentifierWithNode identifier: aVariableExpression name)
				 expectedKind: {
						 FamixPythonClass.
						 FamixPythonFunction.
						 FamixPythonLocalVariable.
						 FamixPythonGlobalVariable.
						 FamixPythonAttribute.
						 FamixPythonParameter };
				 notFoundReplacementEntity: [ :unresolved :currentEntity | "This can be a structural entity or a class" self ensureStubUnknownEntityNamed: unresolved identifier ];
				 yourself)
		foundAction: [ :entity :currentEntity |
			| association |
			association := entity createAccessOrReferenceFrom: currentEntity node: aVariableExpression.
			self setSourceAnchor: association from: aVariableExpression ].

	^ aVariableExpression name
]
