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
FamixPythonTreeSitterVisitor >> createWriteAccessTo: variable from: anAssignmentNode [

	| access |
	access := model newAccess
		          variable: variable;
		          accessor: self currentEntity;
		          isWrite: true;
		          yourself.
	self setSourceAnchor: access from: anAssignmentNode
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureMethod: aMethodNode [

	^ (self methodNamed: aMethodNode _name inClassNamed: self currentEntity name) ifNil: [ self createMethod: aMethodNode ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureStubClassNamed: aName [

	^ model allClasses
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [
				  (model newClassNamed: aName)
					  isStub: true;
					  yourself ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureStubMetaclassNamed: aName [

	^ (model allWithType: FamixPythonMetaclass)
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [
				  model newMetaclass
					  name: aName;
					  isStub: true;
					  yourself ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> ensureStubMethodNamed: aName [

	^ model allMethods
		  detect: [ :method | method isStub and: [ method name = aName ] ]
		  ifNone: [
				  (model newMethodNamed: aName)
					  isStub: true;
					  yourself ]
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

{ #category : 'testing' }
FamixPythonTreeSitterVisitor >> isMetaclassDefinition: aClassDefinitionNode [

	^ aClassDefinitionNode _superclasses
		  ifNil: [ false ]
		  ifNotNil: [ :argumentList | argumentList collectNamedChild anySatisfy: [ :node | node type = #identifier and: [ node sourceText = 'type' ] ] ]
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
	"When we end up here we might have multiple cases to manage:
	- x() => This is either a function invocation or instantiation. There should be no stub. 
	- package.module.x() => Function invocation or instantiation comming from one of the import. Stub is an unknown entity.
	- module.x() with `from package import module` => Function invecation or instantiation from an imported module. Stub is an unknown entity.
	- self.x() => Method invocation. There should be no stub.
	- c.x() => Method invocation. Can be a stub method
	- x()() => Invocation or Instantiation of the result of another invocation. This we cannot really treat it here so for now I'll just ignore this case.
	- table[x]() => Same as above but with the content of a table"

	| receiver |
	" => x()()/table[x]()
	This is happening when we invoke the result of an invocation. The parser cannot know what is invoked. I'm ignoring it"
	(#( subscript call ) includes: aCallNode _function type) ifTrue: [ ^ self ].

	receiver := self visit: aCallNode _function.

	"=> x()"
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
	"=> self.x()"
	self flag: #todo. "Can be something different than self..."
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
				  foundAction: [ :result :currentEntity | self createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity ] ].

	"=> c.x() or module.x() with `from package import module`"
	^ self
		  resolve: ((FamixPythonInvocationOrInstantiationWithUnknownReceiverResolvable identifier: receiver second receiver: receiver first)
				   notFoundReplacementEntity: [ :unresolved :currentEntity | "Two case possible:
						- The receiver is an import of a stub module or package and we should create an unknown entity that can be a function or a class invoked
						- The receiver is not an imported module or package but an instance of a class and the entity is a stub method"
						   unresolved hasCorrespondingImport
							   ifTrue: [
									   (self ensureStubUnknownEntityNamed: unresolved identifier)
										   parentPackage: unresolved correspondingImport importedEntity;
										   yourself ]
							   ifFalse: [ { (self ensureStubMethodNamed: unresolved identifier) } ] ];
				   yourself)
		  foundAction: [ :result :currentEntity | self createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity ]
]

{ #category : 'initialization' }
FamixPythonTreeSitterVisitor >> setMetaclassOf: aClassDefinitionNode [

	(self visit: aClassDefinitionNode _superclasses) ifNotNil: [ :nodes |
			nodes
				detect: [ :node | node type = #keyword_argument and: [ node _name sourceText = #metaclass ] ]
				ifFound: [ :aMetaclass |
						| metaclassUsage |
						metaclassUsage := model newMetaclassUsage.
						metaclassUsage user: self currentEntity.
						self setSourceAnchor: metaclassUsage from: aMetaclass.

						"If it's not an identifier then it means it's an imported metaclass."
						aMetaclass _value type = #identifier
							ifTrue: [
									self
										resolve: ((SRIdentifierWithNode identifier: aMetaclass _value sourceText)
												 expectedKind: FamixPythonMetaclass;
												 notFoundReplacementEntity: [ :unresolvedMetaclass :currentEntity | "We should never end up here but I'm still bulletproofing the parser in case we get code with errors"
													 self ensureStubMetaclassNamed: unresolvedMetaclass identifier ];
												 yourself)
										foundAction: [ :entity :currentEntity | metaclassUsage metaclass: entity ] ]
							ifFalse: [
									| definition |
									definition := self visit: aMetaclass _value.

									self findImportMatchingSource: definition first ifFound: [ :import |
											self
												resolve: ((FamixPythonImportedEntityResolvable identifier: definition second import: import)
														 expectedKind: FamixPythonMetaclass;
														 notFoundReplacementEntity: [ :unresolved :currentEntity | "We should never end up here because this means we have the sources of the imported entities but I'm still bulletproofing the parser in case we have some code that cannot run"
															 self ensureStubMetaclassNamed: definition second ];
														 yourself)
												foundAction: [ :entity :currentEntity | metaclassUsage metaclass: entity ].
											^ metaclassUsage ].
									"If we did not find an import, we have a stub."
									metaclassUsage metaclass: ((self ensureStubMetaclassNamed: definition second)
											 typeContainer: (self ensureStubPackagesFromPath: definition first);
											 yourself) ] ] ]
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> setSourceAnchor: aFamixEntity from: aTSNode [

	^ self
		  setSourceAnchorTo: aFamixEntity
		  fileName: aTSNode relativePath
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

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> setSuperclassesOf: classDefinitionNode [

	self flag: #todo. "Add test of a class with a superclass and a metaclass"
	self flag: #todo. "Add test on multiple inheritance"
	self flag: #todo. "Imported superclass?"
	self flag: #todo. "The code can be cleaned... Maybe we don't need the visit here but inline the condition added in #argument_list?"
	"We can either have identifiers representing superclasses or keywords representing for example the declaration of a metaclass"
	^ (((self visit: classDefinitionNode _superclasses) ifNil: [ #(  ) ]) select: [ :each | each type = #identifier ])
		  ifEmpty: [
				  model newInheritance
					  superclass: (self ensureStubClassNamed: 'object');
					  subclass: self currentEntity ]
		  ifNotEmpty: [ :superclasses |
				  superclasses do: [ :superclass |
						  | inheritance |
						  inheritance := model newInheritance.
						  inheritance subclass: self currentEntity.
						  self setSourceAnchor: inheritance from: superclass.
						  self
							  resolve: ((SRIdentifierWithNode identifier: superclass sourceText)
									   expectedKind: FamixPythonClass;
									   notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ];
									   yourself)
							  foundAction: [ :entity :currentEntity | inheritance superclass: entity ] ] ]
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
FamixPythonTreeSitterVisitor >> visitArgumentList: anArgumentListNode [
	"An argument list can either be in a class definition to list superclasses and things like metaclass or in a call."

	"In case of a class definition we let my caller handle the nodes"
	anArgumentListNode parent type = #class_definition ifTrue: [ ^ anArgumentListNode collectNamedChild ].

	^ super visitNode: anArgumentListNode
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
	
			         self createWriteAccessTo: variable from: anAssignmentNode assignationNode.
			         variable ].

	super visitNode: anAssignmentNode.
	^ names
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitAttribute: anAttributeNode [
	"An attribute can signify two things:
		- It's the receiver of a method or function call so we use it to produce an invocation or instantiation
		- Else it is probably a reference or access to something imported with a simple import."

	| source name |
	source := anAttributeNode _object sourceText copyWithout: Character space.
	name := self visit: anAttributeNode _attribute.

	"If the parent is a call or keyword argument (in metaclass declaration), we return info to resolve the call"
	(#(call keyword_argument ) includes: anAttributeNode parent type) ifTrue: [
			^ {
				  source.
				  name } ].

	"Symbol resolution of accesses and references to imported entities.
	Example:
	
	import moduleAtRoot
	print(moduleAtRoot.moduleVariable)
	"
	self flag: #todo. "Add test with reference and spaces in the namespace."
	source := anAttributeNode sourceText.
	self findImportMatchingSource: source ifFound: [ :import |
			self
				resolve: ((FamixPythonImportedEntityResolvable identifier: name import: import)
						 expectedKinds: {
								 FamixPythonClass.
								 FamixPythonFunction.
								 FamixPythonLocalVariable.
								 FamixPythonGlobalVariable.
								 FamixPythonAttribute.
								 FamixPythonParameter };
						 notFoundReplacementEntity: [ :unresolved :currentEntity | "This unknown entity can be a variable or a class."
							 self ensureStubUnknownEntityNamed: unresolved identifier ];
						 yourself)
				foundAction: [ :entity :currentEntity |
						| association |
						association := entity createAccessOrReferenceFrom: currentEntity node: anAttributeNode.
						self setSourceAnchor: association from: anAttributeNode ].
			^ source ].

	self flag: #todo. "We are missing instance variable accesses here"
	"1halt"
	^ source
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

	class := (self isMetaclassDefinition: aClassDefinitionNode)
		         ifTrue: [ model newMetaclass ]
		         ifFalse: [ model newClass ].

	class name: name.

	shadowedEntity ifNotNil: [ class shadowedEntity: shadowedEntity ].
	class typeContainer: self currentEntity.

	self setSourceAnchor: class from: aClassDefinitionNode.

	^ self useCurrentEntity: class during: [
			  self setSuperclassesOf: aClassDefinitionNode.
			  self setMetaclassOf: aClassDefinitionNode.
			  super visitNode: aClassDefinitionNode ]
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
FamixPythonTreeSitterVisitor >> visitGlobalStatement: aNode [

	self flag: #todo
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitIdentifier: anIdentifierNode [

	self flag: #todo. "review some + clean method"
	(#( aliased_import attribute call function_definition class_definition parameters keyword_argument lambda_parameters named_expression pattern_list ERROR) includes:
		 anIdentifierNode parent type) ifTrue: [ ^ anIdentifierNode sourceText ].
	anIdentifierNode isLeftSideOfAssignation ifTrue: [ ^ anIdentifierNode sourceText ].
	(#( argument_list return_statement lambda if_statement comparison_operator binary_operator assignment ) includes: anIdentifierNode parent type) ifTrue: [
			^ self
				  resolve: ((SRIdentifierWithNode identifier: anIdentifierNode sourceText)
						   expectedKind: {
								   FamixPythonClass.
								   FamixPythonFunction.
								   FamixPythonLocalVariable.
								   FamixPythonGlobalVariable.
								   FamixPythonAttribute.
								   FamixPythonParameter };
						   notFoundReplacementEntity: [ :unresolved :currentEntity | "If we are the receiver of an invocation and we did not find the associated entity it's because it's an instance of a class or the namespace from the import. In that case we should create nothing so we give a null entity.""]"
								   self flag: #todo.
								   "aVariableExpression isInvocationOrInstantiationReceiver
						 ifTrue: [ FamixPythonNilEntity ]
						 ifFalse: [" "This can be a structural entity or a class"
								   self ensureStubUnknownEntityNamed: unresolved identifier ];
						   yourself)
				  foundAction: [ :entity :currentEntity | "See the comment in the notFoundReplacementEntity block to see why we do this."
						  entity isMooseEntity ifTrue: [
								  | association |
								  association := entity createAccessOrReferenceFrom: currentEntity node: anIdentifierNode.
								  self setSourceAnchor: association from: anIdentifierNode ] ] ].



	1 halt
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
	lambda signature: (aLambdaNode _parameters
			 ifNotNil: [ :node | aLambdaNode completeSource copyFrom: node startPosition to: node endPosition ]
			 ifNil: [ '' ]).
	lambda lambdaContainer: self currentEntity.

	self setSourceAnchor: lambda from: aLambdaNode.
	^ self useCurrentEntity: lambda during: [ super visitNode: aLambdaNode ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitList: aNode [
	"noop"

	
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitListComprehension: aNode [
	"noop"

	
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
FamixPythonTreeSitterVisitor >> visitNotOperator: aNode [
	"noop"

	
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
