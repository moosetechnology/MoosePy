Class {
	#name : 'FamixPythonTreeSitterVisitor',
	#superclass : 'TSVisitor',
	#traits : 'SRTSolverUserVisitor',
	#classTraits : 'SRTSolverUserVisitor classTrait',
	#instVars : [
		'fileReference',
		'model',
		'commentsImporter',
		'importPaths'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity [

	^ (result isCollection not and: [ result isClass ])
		  ifTrue: [
				  | reference |
				  reference := result createAccessOrReferenceFrom: currentEntity node: aCallNode.
				  self setSourceAnchor: reference from: aCallNode.

				  self createInvocationOf: (self getConstructorOf: result) from: currentEntity node: aCallNode ]
		  ifFalse: [ self createInvocationOf: result from: currentEntity node: aCallNode ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> createFunction: aFunctionDefinition [

	| function name shadowedEntity signature |
	name := self visit: aFunctionDefinition _name.
	signature := aFunctionDefinition completeSource copyFrom: aFunctionDefinition _name startPosition to: aFunctionDefinition _parameters endPosition.

	"If we are shadowing an entity, we need to mark is as shadowed."
	shadowedEntity := self findSadowedEntityNamed: name.

	function := model newFunction
		            name: name;
		            signature: signature;
		            functionOwner: self currentEntity;
		            yourself.

	shadowedEntity ifNotNil: [ function shadowedEntity: shadowedEntity ].

	^ self setSourceAnchor: function from: aFunctionDefinition
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> createImport: anImport ofName: aName from: fromName alias: alias [

	| import |
	import := model newImport
		          alias: alias;
		          isFromImport: fromName isNotNil;
		          yourself.

	self setSourceAnchor: import from: anImport.

	self currentEntity addImport: import.

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

									 (self ensureStubUnknownEntityNamed: unresolvedImport entityName)
										 parentPackage: package;
										 "This entity can be a package on a module."yourself ];
							 yourself ])
		foundAction: [ :entity :currentEntity | entity addIncomingImport: import ].

	^ import
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> createInvocationOf: target from: currentEntity node: aNode [

	| invocation |
	invocation := self model newInvocation
		              sender: currentEntity;
		              signature: aNode sourceText;
		              yourself.
	target isCollection
		ifTrue: [ invocation candidates: target ]
		ifFalse: [ invocation invokedEntity: target ].

	self setSourceAnchor: invocation from: aNode.
	^ invocation
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> createMethod: aMethodNode [

	| method name signature |
	name := self visit: aMethodNode _name.
	signature := aMethodNode completeSource copyFrom: aMethodNode _name startPosition to: aMethodNode _parameters endPosition.
	method := model newMethod
		          name: name;
		          isStub: true;
		          signature: signature;
		          yourself.

	method parentType: self currentEntity.

	name = '__init__' ifTrue: [ method isConstructor: true ].

	(name beginsWith: 'get_') ifTrue: [
			self
				resolve: ((SRIdentifierWithNode identifier: (name withoutPrefix: 'get_'))
						 expectedKind: FamixPythonAttribute;
						 yourself)
				foundAction: [ :entity :currentEntity | method beGetter ]
				ifNone: [ "We do nothing" ] ].

	(name beginsWith: 'set_') ifTrue: [
			self
				resolve: ((SRIdentifierWithNode identifier: (name withoutPrefix: 'set_'))
						 expectedKind: FamixPythonAttribute;
						 yourself)
				foundAction: [ :entity :currentEntity | method beSetter ]
				ifNone: [ "We do nothing" ] ].

	^ self setSourceAnchor: method from: aMethodNode
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> createStubPackageNamed: aString [

	^ (model newPackageNamed: aString)
		  isStub: true;
		  yourself
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureMethod: aMethodNode [

	^ (self methodNamed: aMethodNode _name inClassNamed: self currentEntity name) ifNil: [ self createMethod: aMethodNode ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureStubPackageNamed: aString [

	^ model allPackages
		  detect: [ :class | class isStub and: [ class name = aString ] ]
		  ifNone: [ self createStubPackageNamed: aString ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureStubPackagesFromPath: aPythonImportPath [
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
						           (self createStubPackageNamed: splitted first)
							           parentPackage: package;
							           yourself ].

			splitted removeFirst ].

	^ package
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureStubUnknownEntityNamed: aString [

	^ (self unknownEntityNamed: aString) ifNil: [
			  model newUnknownEntity
				  name: aString;
				  yourself ]
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> fileReference [
	^ fileReference
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> findImportMatchingSource: aString ifFound: aBlock [
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

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> findSadowedEntityNamed: name [
	"If the same element already has a shadowable entity of the same name, we select the last one defined. If there is none, we return nil"

	self withCurrentEntityDo: [ :entity |
		((entity query descendants ofType: FamixTShadowable) select: [ :child | child name = name ]) ifNotEmpty: [ :entities |
			^ entities detectMax: [ :anEntity | anEntity sourceAnchor startPos ] ] ].

	^ nil
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> getConstructorOf: aClass [

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
FamixPythonTreeSitterVisitor >> initialize [

	super initialize.
	model := FamixPythonModel new name: 'default Python Model'.
	model sourceLanguage: model newSourceLanguage.
	self initialiseSolver.
	importPaths := IdentityDictionary new
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> methodNamed: aString inClassNamed: aClassName [

	^ (self model allWithType: FamixPythonMethod)
		  detect: [ :e | e name = aString and: [ e parentType name = aClassName ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> model [
	^ model
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> relativeFilePath [

	self model rootFolder ifNil: [ ^ self fileReference fullName removePrefix: '/' ].

	^ (self fileReference relativeTo: self model rootFolder asPath) pathString
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> resolveInvocationOrInstantiationFrom: aCallNode [

	| receiver |
	(#( subscript call ) includes: aCallNode _function type) ifTrue: [ ^ self ].

	receiver := self visit: aCallNode _function.

	receiver isString ifTrue: [
			^ self
				  resolve: ((FamixPythonInvocationOrInstantiationResolvable identifier: receiver)
						   expectedKind: {
								   FamixPythonFunction.
								   FamixPythonClass };
						   notFoundReplacementEntity: [ :unresolved :currentEntity | "This one can be a function or a class"
							   { (self ensureStubUnknownEntityNamed: unresolved identifier) } ];
						   yourself)
				  foundAction: [ :result :currentEntity | self createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity ] ].

	receiver first = 'self' ifTrue: [
			^ self
				  resolve: (FamixPythonLocalMethodInvocationResolvable identifier: receiver second)
				  foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aCallNode ] ].

	"=> package.module.x()"
	self findImportMatchingSource: receiver first ifFound: [ :import |
			^ self
				  resolve: ((FamixPythonInvocationOrInstantiationWithNamespaceResolvable identifier: receiver second import: import)
						   expectedKind: {
								   FamixPythonFunction.
								   FamixPythonClass };
						   notFoundReplacementEntity: [ :unresolved :currentEntity | "This one can be a function or a class"
								   (self ensureStubUnknownEntityNamed: unresolved identifier)
									   parentPackage: import importedEntity;
									   yourself ];
						   yourself)
				  foundAction: [ :result :currentEntity | self createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity ] ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> setSourceAnchor: aFamixEntity from: aTSNode [

	^ self
		  setSourceAnchorTo: aFamixEntity
		  fileName: self relativeFilePath
		  start: aTSNode startPosition
		  end: aTSNode endPosition
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> setSourceAnchorTo: aFamixEntity fileName: aString start: aNumber end: anotherNumber [

	aFamixEntity sourceAnchor: (FamixPythonIndexedFileAnchor new
			 fileName: aString;
			 startPos: aNumber;
			 endPos: anotherNumber;
			 mooseModel: self model;
			 yourself).

	(aFamixEntity class includesTrait: FamixTCanBeStub) ifTrue: [ aFamixEntity isStub: false ].

	^ aFamixEntity
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> sourceText [

	self flag: #todo. "Manage encorders."
	^ self fileReference contents
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> unknownEntityNamed: aString [

	^ (self model allWithType: FamixPythonUnknownEntity)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visit: anObject [

	anObject isTSNode ifTrue: [ ^ self visitNode: anObject ].
	anObject isCollection ifTrue: [ ^ self visitNodes: anObject ].
	^ anObject
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitAliasedImport: anAliasImport [

	^ (self visit: anAliasImport _name) -> (self visit: anAliasImport _alias)
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitAssignment: anAssignmentNode [

	| names |
	self flag: #todo. "Manage attributes"
	anAssignmentNode _left type = #attribute ifTrue: [ ^ self ].
	(anAssignmentNode _left collectNamedChild anySatisfy: [ :node | node type = #attribute ]) ifTrue: [ ^ self ].
	anAssignmentNode _left type = #subscript ifTrue: [ ^ self ].
	names := self visit: anAssignmentNode _left. "Could return a string or a collection of strings in case of multiple assignations. We need to manage this."
	names isString ifTrue: [ names := { names } ].

	names := names collect: [ :name |
			         | variable |
			         "If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
			         (self currentEntity query descendants ofType: FamixTStructuralEntity)
				         detect: [ :child | child name = name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
				         ifFound: [ :var | variable := var ]
				         ifNone: [
						         | shadowedEntity |
						         shadowedEntity := self findSadowedEntityNamed:  name.
						         variable := self currentEntity createLocalVariable: name.
						         shadowedEntity ifNotNil: [ variable shadowedEntity: shadowedEntity ].
						         "We select the lhs node because the source anchor should not be the full assignation."
						         self setSourceAnchor: variable from: anAssignmentNode _left ].
			         self flag: #todo.
			         "self createWriteAccessTo: variable from: anAssignmentNode assignationNode."
			         variable ].

	super visitNode: anAssignmentNode.
	^ names
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitAttribute: anAttributeNode [

	^ {
		  anAttributeNode _object sourceText.
		  (self visit: anAttributeNode _attribute) }
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitCall: aCallNode [

	self resolveInvocationOrInstantiationFrom: aCallNode.

	^ super visitNode: aCallNode
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitClassDefinition: aClassDefinitionNode [

	| class shadowedEntity name |
	name := self visit: aClassDefinitionNode _name.
	"If we are shadowing an entity, we need to mark is as shadowed."
	shadowedEntity := self findSadowedEntityNamed: name.

	self flag: #todo.
	class := model newClass. "classDefinitionNode isMetaclass
		         ifTrue: [ model newMetaclass ]
		         ifFalse: [" "]"
	class name: name.

	self flag: #todo.
	"self setSuperclassesOf: classDefinitionNode from: class."

	shadowedEntity ifNotNil: [ class shadowedEntity: shadowedEntity ].
	class typeContainer: self currentEntity.

	self setSourceAnchor: class from: aClassDefinitionNode.

	^ self useCurrentEntity: class during: [ super visitNode: aClassDefinitionNode ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitComment: aCommentNode [

	commentsImporter addCommentNode: aCommentNode
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitDottedName: aDottedNameNode [

	^ aDottedNameNode sourceText
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitFalse: aNode [
	"noop"

	
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitFunctionDefinition: aFunctionDefinition [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| entity |
	entity := self currentEntity isClass
		          ifTrue: [ self ensureMethod: aFunctionDefinition ]
		          ifFalse: [ self createFunction: aFunctionDefinition ].

	^ self useCurrentEntity: entity during: [ super visitNode: aFunctionDefinition ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitIdentifier: anIdentifierNode [
	^ anIdentifierNode sourceText
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitImportFromStatement: anImportFromStatement [

	| moduleName identifiers |
	moduleName := anImportFromStatement _module_name accept: self.

	identifiers := self visit: (anImportFromStatement
			                nodeChildByFieldName: 'name'
			                ifAbsent: [ anImportFromStatement detectNamedChild: 'wildcard_import' ifNone: [ self error: 'We should have at least one of them.' ] ]).
	identifiers isAssociation ifTrue: [ identifiers := { identifiers } asDictionary ].
	identifiers isString ifTrue: [ identifiers := { identifiers } ].
	identifiers isDictionary ifFalse: [
			identifiers := (identifiers collect: [ :name |
					                name isAssociation
						                ifTrue: [ name ]
						                ifFalse: [ name -> nil ] ]) asDictionary ].


	identifiers keysAndValuesDo: [ :identifier :alias |
			self
				createImport: anImportFromStatement
				ofName: identifier
				from: moduleName
				alias: alias ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitImportStatement: anImportStatement [

	| identifiers |
	identifiers := self visit: anImportStatement _name.

	identifiers isAssociation ifTrue: [ identifiers := { identifiers } asDictionary ].
	identifiers isString ifTrue: [ identifiers := { identifiers } ].
	identifiers isDictionary ifFalse: [
			identifiers := (identifiers collect: [ :name |
					                name isAssociation
						                ifTrue: [ name ]
						                ifFalse: [ name -> nil ] ]) asDictionary ].

	identifiers keysAndValuesDo: [ :identifier :alias |
			self
				createImport: anImportStatement
				ofName: identifier
				from: nil
				alias: alias ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitInteger: aNode [
	"noop"

	
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitLambda: aLambdaNode [

	| lambda |
	lambda := model newLambda.
	lambda signature: ([ aLambdaNode completeSource copyFrom: aLambdaNode _parameters startPosition to: aLambdaNode _parameters endPosition ]
			 on: KeyNotFound
			 do: [ '' ]).
	lambda lambdaContainer: self currentEntity.

	self setSourceAnchor: lambda from: aLambdaNode.
	^ self useCurrentEntity: lambda during: [ super visitNode: aLambdaNode ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitModule: aModuleNode [

	| isPackageDeclaration entity |
	"Reset the comment presenter for the current module."
	commentsImporter := FamixPythonTSCommentsImporter visitor: self.
	
	"If the file is name __init__.py this means that we have the declaration of a package. Else we have a module that can be in a package."
	isPackageDeclaration := self fileReference basename = '__init__.py'.
	entity := isPackageDeclaration
		          ifTrue: [ self currentEntity ]
		          ifFalse: [ model newModuleNamed: self fileReference basenameWithoutExtension ].

	self setSourceAnchor: entity from: aModuleNode.

	isPackageDeclaration ifFalse: [
			self solver scopeIsEmpty ifFalse: [
					self assert: self currentEntity isPackage.
					entity parentPackage: self currentEntity ].

			(self currentEntity: entity) isMainEntity: true ].

	aModuleNode collectNamedChild do: [ :child | child accept: self ].
	
	commentsImporter import.
	"FamixPythonCommentsImporter importCommentsOf: aModuleNode visitor: self."

	"If we are in a package declaration we need to keep the package in the context for the modules in the package. The package will be pop later by the importer."
	^ isPackageDeclaration
		  ifTrue: [ self currentEntity ]
		  ifFalse: [ self popScope ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitNamedExpression: aNamedExpressionNode [

	| name variable |
	name := self visit: aNamedExpressionNode _name.


	"If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
	(self currentEntity query descendants ofType: FamixPythonLocalVariable)
		detect: [ :child | child name = name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
		ifFound: [ :var | variable := var ]
		ifNone: [
				| shadowedEntity |
				self flag: #todo. "Add test on shadowing at this level. This is not yet covered by test. If you comment the next line the parser is still passing all tests."
				shadowedEntity := self findSadowedEntityNamed:  name.
				variable := self currentEntity createLocalVariable: name.
				shadowedEntity ifNotNil: [ variable shadowedEntity: shadowedEntity ].
				"We select the lhs node because the source anchor should not be the full assignation."
				self setSourceAnchor: variable from: aNamedExpressionNode _name ].
	self flag: #todo.
	"self createWriteAccessTo: variable from: anAssignmentNode assignationNode."

	super visitNode: aNamedExpressionNode.
	^ variable
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitNode: aTSNode [

	^ self errorReport catch: Exception during: [
			  | visitMethod |
			  visitMethod := (String streamContents: [ :aStream |
					                  aStream nextPutAll: 'visit'.
					                  ($_ split: aTSNode type) do: [ :word | aStream nextPutAll: word capitalized ].
					                  aStream nextPut: $: ]) asSymbol.

			  (self respondsTo: visitMethod)
				  ifTrue: [ self perform: visitMethod with: aTSNode ]
				  ifFalse: [
						  visitMethod traceCr.
						  super visitNode: aTSNode ] ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitNodes: aCollection [

	^ aCollection collect: [ :node | self visit: node ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitPatternList: aPatternListNode [

	^ self visit: aPatternListNode collectNamedChild
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitRelativeImport: aRelativeImportNode [

	^ aRelativeImportNode sourceText
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitString: aStringNode [

	aStringNode parent type = #expression_statement ifTrue: [ commentsImporter addStringNode: aStringNode ].

	"No need to visit children, we do nothing with them currently."
	^ self
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitTrue: aNode [
	"noop"

	
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitWildcardImport: aWildcarImportNode [

	^ #( #* )
]
