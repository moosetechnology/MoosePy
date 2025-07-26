"
Lets define some rules.

They are not respected yet but it will come.

- Creating a new entity should be done in a method starting by ""create"" and in ""entity creation"". 
- Creating a new association should be done in a method starting by ""create"" and in ""association creation"".
- Creating a new entity if one does not exist yet should go in ""ensure entity"" protocol.
- No other method should begins by ""create"".
- Creating an entity if it does not exist yet should start by ""ensure""
- Visit method cutting all visit should go in the protocol ""visitin - noop""
- Visit method visiting all children  should go in the protocol ""visitin - visitChildren""
- Other visit methods should be in ""visiting""
"
Class {
	#name : 'FamixPythonVisitor',
	#superclass : 'FamixTSAbstractVisitor',
	#instVars : [
		'importPaths'
	],
	#category : 'Famix-Python-Importer-Core',
	#package : 'Famix-Python-Importer',
	#tag : 'Core'
}

{ #category : 'private' }
FamixPythonVisitor >> attributeAsAssociation: anAttributeNode [
	"The attribute can only be an identifier. We do not visit it because the association attached to it will be managed elsewhere."

	^ (anAttributeNode _object sourceText copyWithout: Character space) -> anAttributeNode _attribute sourceText
]

{ #category : 'private' }
FamixPythonVisitor >> checkShadowingOfName: aString during: aBlock [
	"If the same element already has a shadowable entity of the same name, we select the last one defined and mark it as shadowed by the new entity returned by the block."

	| shadowedEntity newEntity |
	self withCurrentEntityDo: [ :entity |
			((entity query descendants ofType: FamixTShadowable) select: [ :child | child name = aString ]) ifNotEmpty: [ :entities |
				shadowedEntity := entities detectMax: [ :anEntity | anEntity sourceAnchor startPos ] ] ].

	newEntity := aBlock value.

	shadowedEntity ifNotNil: [ newEntity shadowedEntity: shadowedEntity ]
]

{ #category : 'association creation' }
FamixPythonVisitor >> createAccessTo: variable isWrite: aBoolean from: anAssignmentNode [

	| access |
	access := model newAccess
		          variable: variable;
		          isWrite: aBoolean;
		          yourself.

	self setSourceAnchor: access from: anAssignmentNode.
	"In the case of an augmented assignment, we produce a read access on top of the write access"
	(aBoolean and: [ anAssignmentNode type = #augmented_assignment ]) ifTrue: [ variable createAccessOrReferenceFrom: self currentEntity node: anAssignmentNode ].

	^ access
]

{ #category : 'private' }
FamixPythonVisitor >> createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity [

	^ (result isCollection not and: [ result isClass ])
		  ifTrue: [
				  result createAccessOrReferenceFrom: currentEntity node: aCallNode.
				  self createInvocationOf: (self getConstructorOf: result) from: currentEntity node: aCallNode ]
		  ifFalse: [ self createInvocationOf: result from: currentEntity node: aCallNode ]
]

{ #category : 'entity creation' }
FamixPythonVisitor >> createClassNamed: aString [

	^ (model newClassNamed: aString)
		  isStub: true; "We set this to true because setting a source anchor will set it to false automatically later in case it is not a stub."
		  yourself
]

{ #category : 'association creation' }
FamixPythonVisitor >> createInheritance [

	^ model newInheritance
		  subclass: self currentEntity;
		  yourself
]

{ #category : 'association creation' }
FamixPythonVisitor >> createInheritanceFrom: anAttributeNode [

	^ self createInheritance
		  in: [ :inheritance | self setSourceAnchor: inheritance from: anAttributeNode ];
		  yourself
]

{ #category : 'association creation' }
FamixPythonVisitor >> createInvocationOf: target from: currentEntity node: aNode [

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

{ #category : 'entity creation' }
FamixPythonVisitor >> createMetaclassNamed: aString [

	^ (model newMetaclassNamed: aString)
		  isStub: true; "We set this to true because setting a source anchor will set it to false automatically later in case it is not a stub."
		  yourself
]

{ #category : 'entity creation' }
FamixPythonVisitor >> createMethodNamed: aString [

	^ (model newMethodNamed: aString)
		  isStub: true; "We set this to true because setting a source anchor will set it to false automatically later in case it is not a stub."
		  yourself
]

{ #category : 'entity creation' }
FamixPythonVisitor >> createParameterFrom: aNode [

	^ (model newParameterNamed: aNode sourceText)
		  parentBehaviouralEntity: self currentEntity;
		  in: [ :param | self setSourceAnchor: param from: aNode ];
		  yourself
]

{ #category : 'entity creation' }
FamixPythonVisitor >> createStubPackageNamed: aString [

	^ (model newPackageNamed: aString)
		  isStub: true;
		  yourself
]

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureStubClassNamed: aName [

	^ model allClasses
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [ self createClassNamed: aName ]
]

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureStubMetaclassNamed: aName [

	^ (model allWithType: FamixPythonMetaclass)
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [ self createMetaclassNamed: aName ]
]

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureStubMethodNamed: aName [

	^ model allMethods
		  detect: [ :method | method isStub and: [ method name = aName ] ]
		  ifNone: [ self createMethodNamed: aName ]
]

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureStubPackageNamed: aString [

	^ model allPackages
		  detect: [ :class | class isStub and: [ class name = aString ] ]
		  ifNone: [ self createStubPackageNamed: aString ]
]

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureStubPackagesFromPath: aPythonImportPath [
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

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureStubUnknownEntityNamed: aString [

	^ (self unknownEntityNamed: aString) ifNil: [ model newUnknownEntityNamed: aString ]
]

{ #category : 'ensure entity' }
FamixPythonVisitor >> ensureSuperclassFor: aClassDefinitionNode [
	"Visiting the children of the superclasses should create the superclass of the class definition. But, if there are none, this means we should inherit from object."

	self currentEntity superInheritances ifEmpty: [ self createInheritance superclass: (self ensureStubClassNamed: 'object') ]
]

{ #category : 'private' }
FamixPythonVisitor >> findImportMatchingSource: aString ifFound: aBlock [
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
FamixPythonVisitor >> getConstructorOf: aClass [
	"If we instantiate a class, we need to invoke the constructor. If it was not overrident by the developer, we create a stub"

	^ aClass methods
		  detect: [ :method | method isConstructor ]
		  ifNone: [
				  (self createMethodNamed: '__init__')
					  isConstructor: true;
					  parentType: aClass;
					  yourself ]
]

{ #category : 'initialization' }
FamixPythonVisitor >> initialize [

	super initialize.
	self flag: #todo. "Add management and tests on parenthesized_expression kind of node"
	self flag: #todo. "Manage local variables in dictionary comprehension, forIn...."
	self flag: #todo. "Manage classes in classes. Especially for example the symbol resolution of local methods."
	self flag: #todo. "Add a test of a local method invocation, but the method comes from a stub superclass (I know I did not managed the stubs. It should fail first"
	self flag: #todo. "Create local var in loops or conditions"
	importPaths := IdentityDictionary new
]

{ #category : 'testing' }
FamixPythonVisitor >> isAccessOrReferenceNode: anIdentifierNode [
	"I should return true if an Identifier node represent an access or a reference."

	^ #( elif_clause list argument_list return_statement lambda if_statement comparison_operator binary_operator assignment not_operator expression_statement
	     augmented_assignment unary_operator boolean_operator pair list_splat default_parameter dictionary_splat #if_clause #for_in_clause) includes: anIdentifierNode parent type
]

{ #category : 'testing' }
FamixPythonVisitor >> isMetaclassDefinition: aClassDefinitionNode [

	^ aClassDefinitionNode _superclasses
		  ifNil: [ false ]
		  ifNotNil: [ :argumentList | argumentList collectNamedChild anySatisfy: [ :node | node type = #identifier and: [ node sourceText = 'type' ] ] ]
]

{ #category : 'private' }
FamixPythonVisitor >> manageAccessOrReferencesFrom: anIdentifierNode [
	"To know if the identifier can be an access or reference we need to check its parents."

	(self isAccessOrReferenceNode: anIdentifierNode) ifTrue: [
			self
				resolve: ((SRIdentifierResolvable identifier: anIdentifierNode sourceText)
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
					entity isMooseEntity ifTrue: [ entity createAccessOrReferenceFrom: currentEntity node: anIdentifierNode ] ] ]
]

{ #category : 'private' }
FamixPythonVisitor >> manageAttributeWriteAccessTo: aNode [

	| variable pair |
	pair := self attributeAsAssociation: aNode.
	self flag: #todo. "Might not be self..."
	pair key = 'self'
		ifTrue: [
				| class |
				class := self currentEntityOfType: FamixPythonClass.
				variable := (class childOfType: FamixTAttribute named: pair value) ifNil: [
						            variable := (class createLocalVariable: pair value)
							                        isClassSide: false;
							                        yourself.
						            self setSourceAnchor: variable from: aNode.
						            variable ] ]
		ifFalse: [
				self flag: #todo.
				^ self ].
	(self createAccessTo: variable isWrite: true from: aNode assignationNode) accessor: self currentEntity.
	
	^ variable
]

{ #category : 'private' }
FamixPythonVisitor >> manageFunctionDeclarationFrom: aFunctionDefinition [

	| function name signature |
	name := self visit: aFunctionDefinition _name.
	signature := aFunctionDefinition completeSource copyFrom: aFunctionDefinition _name startPosition to: aFunctionDefinition _parameters endPosition.

	self checkShadowingOfName: name during: [
			function := (model newFunctionNamed: name)
				            signature: signature;
				            functionOwner: self currentEntity;
				            yourself ].

	^ self setSourceAnchor: function from: aFunctionDefinition
]

{ #category : 'private' }
FamixPythonVisitor >> manageImport: anImport ofName: aName from: fromName alias: alias [

	| import |
	import := model newImport
		          alias: alias;
		          isFromImport: fromName isNotNil;
		          importingEntity: self currentEntity;
		          yourself.

	self setSourceAnchor: import from: anImport.


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
FamixPythonVisitor >> manageImportedInheritanceDeclaredBy: anAttributeNode [

	| inheritance definition |
	inheritance := self createInheritanceFrom: anAttributeNode.
	definition := self attributeAsAssociation: anAttributeNode.

	self findImportMatchingSource: definition key ifFound: [ :import |
			self
				resolve: ((FamixPythonImportedEntityResolvable identifier: definition value import: import)
						 expectedKind: FamixPythonClass;
						 notFoundReplacementEntity: [ :unresolved :currentEntity |
								 (self ensureStubClassNamed: unresolved identifier)
									 typeContainer: (self ensureStubPackagesFromPath: definition key);
									 yourself ];
						 yourself)
				foundAction: [ :entity :currentEntity | inheritance superclass: entity ].
			^ inheritance ].

	"If we did not find an import, we have a stub."
	inheritance superclass: ((self ensureStubClassNamed: definition value)
			 typeContainer: (self ensureStubPackagesFromPath: definition key);
			 yourself)
]

{ #category : 'private' }
FamixPythonVisitor >> manageInheritanceDeclaredBy: superclassNode [

	| inheritance |
	inheritance := self createInheritanceFrom: superclassNode.

	self
		resolve: ((SRIdentifierResolvable identifier: superclassNode sourceText)
				 expectedKind: FamixPythonClass;
				 notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ];
				 yourself)
		foundAction: [ :entity :currentEntity | inheritance superclass: entity ]
]

{ #category : 'private' }
FamixPythonVisitor >> manageMetaclassUsageDeclaredBy: aKeywordArgumentNode [

	| metaclassUsage |
	metaclassUsage := model newMetaclassUsage.
	metaclassUsage user: self currentEntity.
	self setSourceAnchor: metaclassUsage from: aKeywordArgumentNode. "If it's not an identifier then it means it's an imported metaclass."
	^ aKeywordArgumentNode _value type = #identifier
		  ifTrue: [
				  self
					  resolve: ((SRIdentifierResolvable identifier: aKeywordArgumentNode _value sourceText)
							   expectedKind: FamixPythonMetaclass;
							   notFoundReplacementEntity: [ :unresolvedMetaclass :currentEntity | "We should never end up here but I'm still bulletproofing the parser in case we get code with errors"
								   self ensureStubMetaclassNamed: unresolvedMetaclass identifier ];
							   yourself)
					  foundAction: [ :entity :currentEntity | metaclassUsage metaclass: entity ] ]
		  ifFalse: [
				  | definition |
				  definition := self attributeAsAssociation: aKeywordArgumentNode _value.
				  self findImportMatchingSource: definition key ifFound: [ :import |
						  self
							  resolve: ((FamixPythonImportedEntityResolvable identifier: definition value import: import)
									   expectedKind: FamixPythonMetaclass;
									   notFoundReplacementEntity: [ :unresolved :currentEntity | "We should never end up here because this means we have the sources of the imported entities but I'm still bulletproofing the parser in case we have some code that cannot run"
											   (self ensureStubMetaclassNamed: unresolved identifier)
												   typeContainer: (self ensureStubPackagesFromPath: definition key);
												   yourself ];
									   yourself)
							  foundAction: [ :entity :currentEntity | metaclassUsage metaclass: entity ].
						  ^ metaclassUsage ]. "If we did not find an import, we have a stub."
				  metaclassUsage metaclass: ((self ensureStubMetaclassNamed: definition value)
						   typeContainer: (self ensureStubPackagesFromPath: definition key);
						   yourself) ]
]

{ #category : 'private' }
FamixPythonVisitor >> manageMethodDeclarationFrom: aMethodNode [

	| method name |
	method := (self createMethodNamed: (name := self visit: aMethodNode _name))
		          signature: (aMethodNode completeSource copyFrom: aMethodNode _name startPosition to: aMethodNode _parameters endPosition);
		          parentType: self currentEntity;
		          yourself.

	name = '__init__' ifTrue: [ method isConstructor: true ].

	(name beginsWith: 'get_') ifTrue: [
			self
				resolve: ((SRIdentifierResolvable identifier: (name withoutPrefix: 'get_'))
						 expectedKind: FamixPythonAttribute;
						 yourself)
				foundAction: [ :entity :currentEntity | method beGetter ]
				ifNone: [ "We do nothing" ] ].

	(name beginsWith: 'set_') ifTrue: [
			self
				resolve: ((SRIdentifierResolvable identifier: (name withoutPrefix: 'set_'))
						 expectedKind: FamixPythonAttribute;
						 yourself)
				foundAction: [ :entity :currentEntity | method beSetter ]
				ifNone: [ "We do nothing" ] ].

	^ self setSourceAnchor: method from: aMethodNode
]

{ #category : 'private' }
FamixPythonVisitor >> manageWriteAccessTo: aNode [
	"I'm managing the write access to an identifier. I have an alternative for access to an attibute such as `instance.var = 3`. See #manageAttributeWriteAccessTo: for this."

	| variable name |
	name := aNode sourceText.

	"If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
	(self currentEntity query descendants ofType: FamixTStructuralEntity)
		detect: [ :child | child name = name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
		ifFound: [ :var | variable := var ]
		ifNone: [
				self checkShadowingOfName: name during: [ variable := self currentEntity createLocalVariable: name ].
				self setSourceAnchor: variable from: aNode ].

	(self createAccessTo: variable isWrite: true from: aNode assignationNode) accessor: self currentEntity.

	^ variable
]

{ #category : 'accessing' }
FamixPythonVisitor >> modelClass [

	^ FamixPythonModel
]

{ #category : 'private' }
FamixPythonVisitor >> resolveInvocationOrInstantiationFrom: aCallNode [
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
				  resolve: (SRLocalClassEntityResolvable identifier: receiver second expectedKind: FamixTMethod)
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

{ #category : 'accessing' }
FamixPythonVisitor >> unknownEntityNamed: aString [

	^ (self model allWithType: FamixPythonUnknownEntity)
		  detect: [ :e | e name = aString ]
		  ifNone: [ nil ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitAliasedImport: anAliasImport [
	"
	Children:
		- name: a dotted_name
		- alias: an identifier (we do not visit it because it does not need to be resolved.
		
	Parents:
		- Visiting me: import_statement / import_from_statement / future_import_statement"

	^ (self visit: anAliasImport _name) -> anAliasImport _alias sourceText
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitArgumentList: anArgumentListNode [
	"
	Children:
		- unnamed: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / comment / dictionary / named_expression / call / list / dictionary_splat / boolean_operator / not_operator / float / none / dictionary_comprehension / set / false / conditional_expression / generator_expression / ellipsis / string / keyword_argument / true / attribute / list_splat / parenthesized_expression / integer / lambda / comparison_operator / tuple / list_comprehension / subscript
		
	Parents:
		- Visiting me: call / class_definition
	
	An argument list can either be in a class definition to list superclasses and things like metaclass or in a call."

	^ self visitChildren: anArgumentListNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitAssertStatement: aNode [
	"
	Children:
		- <unnamedChild>: call / subscript / list / string / tuple / binary_operator / attribute / conditional_expression / parenthesized_expression / identifier / line_continuation / false / boolean_operator / comparison_operator / integer / not_operator
		
	Parents:
		- Visiting me: block / module
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitAssignment: anAssignmentNode [
	"
	Children:
		- left: subscript / tuple_pattern / attribute / list_pattern / identifier / pattern_list
		- right: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / await / dictionary / call / list / not_operator / boolean_operator / expression_list / float / none / set / dictionary_comprehension / false / generator_expression / conditional_expression / ellipsis / string / true / attribute / yield / parenthesized_expression / integer / comparison_operator / lambda / tuple / list_comprehension / assignment / subscript
		- type: type
		- unnamed: line_continuation
	
	Parents:
		- Visiting me: assignment / expression_statement"
	
	^ self visitChildren: anAssignmentNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitAttribute: anAttributeNode [
	"
	Children:
		- object: list / subscript / list_splat / string / tuple / attribute / parenthesized_expression / identifier / concatenated_string / list_comprehension / set / dictionary_comprehension / set_comprehension / dictionary / call
		- attribute: identifier
		- <unnamedChild>: comment / line_continuation
	
	Parents:
		Not yet managed:  while_statement / list / set / assert_statement / list_comprehension / list_pattern / yield / raise_statement / tuple / call / list_splat / type / boolean_operator / conditional_expression / as_pattern / binary_operator / assignment / for_statement / expression_list / typed_default_parameter / not_operator / delete_statement / for_in_clause / pattern_list / pair / argument_list / expression_statement / elif_clause / interpolation / default_parameter / comparison_operator / return_statement / if_statement / except_clause / set_comprehension / if_clause / slice / as_pattern_target / keyword_argument / parenthesized_expression / with_item / generator_expression / subscript / augmented_assignment / unary_operator / decorator / dictionary_splat / lambda / tuple_pattern / attribute
	"

	| source fullReceiver name variable |
	
	self flag: #todo. "This method is really ugly and full of holes..."
	
	anAttributeNode parent parent type = #class_definition ifTrue: [ ^ self manageImportedInheritanceDeclaredBy: anAttributeNode ].

	anAttributeNode isLeftSideOfAssignation ifTrue: [ ^ self manageAttributeWriteAccessTo: anAttributeNode ].

	source := anAttributeNode _object sourceText copyWithout: Character space.
	name := self visit: anAttributeNode _attribute.

	"If the parent is a call , we return info to resolve the call"
	anAttributeNode parent type = #call ifTrue: [
			^ {
				  source.
				  name } ].

	"Symbol resolution of accesses and references to imported entities.
	Example:
	
	import moduleAtRoot
	print(moduleAtRoot.moduleVariable)
	"
	self flag: #todo. "Add test with reference and spaces in the namespace."
	fullReceiver := anAttributeNode sourceText.
	self findImportMatchingSource: fullReceiver ifFound: [ :import |
			^ self
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
				  foundAction: [ :entity :currentEntity | entity createAccessOrReferenceFrom: currentEntity node: anAttributeNode ] ].

	self flag: #todo. "Can be something else than self."
	"This means with have an internal access to an ivar."
	source = 'self'
		ifTrue: [
				| class |
				class := self currentEntityOfType: FamixPythonClass.
				variable := (class childOfType: FamixTAttribute named: name) ifNil: [
						            variable := (class createLocalVariable: name)
							                        isClassSide: false;
							                        yourself.
						            self setSourceAnchor: variable from: anAttributeNode.
						            variable ] ]
		ifFalse: [
				self flag: #todo "We are missing instance variable accesses here"
				"1halt" ].
	self flag: #todo. "remove guard once the previous if will be finished."
	variable ifNotNil: [ (self createAccessTo: variable isWrite: false from: anAttributeNode) accessor: self currentEntity ].


	^ source
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitAugmentedAssignment: aNode [
	"
	Children: 
		- left: attribute / identifier / subscript
		- right: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / call / list / boolean_operator / expression_list / float / set / conditional_expression / string / attribute / parenthesized_expression / integer / comparison_operator / tuple / list_comprehension / subscript
		
	Parents:
		- Visiting me: expression_statement
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitBinaryOperator: aNode [
	"
	Children:
		- left: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / call / list / float / none / set / dictionary_comprehension / false / string / true / attribute / parenthesized_expression / integer / tuple / list_comprehension / subscript
		- right: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / dictionary / call / list / float / none / set / false / string / true / attribute / parenthesized_expression / integer / tuple / list_comprehension / subscript
		- <unnamedChild>: comment / line_continuation
		
	Parents:
		- Visiting me: assignment / binary_operator / if_statement / argument_list / expression_statement / elif_clause / comparison_operator / return_statement / if_clause / augmented_assignment / named_expression / unary_operator / boolean_operator / interpolation / pair / list_splat/ default_parameter / assert_statement / lambda / for_in_clause / list / list_comprehension
		- Not yet managed: set / type / yield / raise_statement / tuple / conditional_expression / for_statement / expression_list / typed_default_parameter / not_operator  / set_comprehension / slice / keyword_argument / parenthesized_expression / generator_expression / subscript
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitBlock: aNode [
	"
	Children:
		- unnamed: continue_statement / for_statement / global_statement / with_statement / comment / delete_statement / nonlocal_statement / break_statement / import_from_statement / expression_statement / type_alias_statement / pass_statement / try_statement / decorated_definition / assert_statement / raise_statement / class_definition / import_statement / while_statement / return_statement / function_definition / if_statement
		
	Parents:
		- Visiting me: function_definition / class_definition / while_statement / elif_clause / if_statement / esle_clause
		- Non yet managed: except_clause / with_statement / finaly_clause / for_statement / try_statement
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitBooleanOperator: aNode [
	"
	Children:
		- left: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / call / list / float / none / set / dictionary_comprehension / false / string / true / attribute / parenthesized_expression / integer / tuple / list_comprehension / subscript
		- right: identifier / set_comprehension / binary_operator / concatenated_string / unary_operator / dictionary / call / list / float / none / set / false / string / true / attribute / parenthesized_expression / integer / tuple / list_comprehension / subscript
		- <unnamedChild>: comment / line_continuation
		
	Parents:
		- Visiting me: boolean_operator / assignment / binary_operator / if_statement / not_operator / argument_list / expression_statement / elif_clause / comparison_operator / return_statement / if_clause / augmented_assignment / named_expression / unary_operator / interpolation / pair / list_splat / default_parameter / assert_statement / lambda / for_in_clause / list / list_comprehension
		- Not yet managed: set / type / yield / raise_statement / tuple / conditional_expression / for_statement / expression_list / typed_default_parameter / set_comprehension / slice / keyword_argument / parenthesized_expression / generator_expression / subscript
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitBreakStatement: aNode [
	"
	Children: none
	
	Parents:
		- Visiting me: block
	
	example:
	
		for i in range(5):
		    if i == 3:
 		       break
  		  print(i)
		
	noop, nothing to do at Famix level."

	
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitCall: aCallNode [

	self resolveInvocationOrInstantiationFrom: aCallNode.

	^ self visitChildren: aCallNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitClassDefinition: aClassDefinitionNode [

	| class name |
	name := aClassDefinitionNode _name sourceText. "No need to visit. It will always be an identifier and this identifier do not need symbol resolution."

	self checkShadowingOfName: name during: [
			class := (self isMetaclassDefinition: aClassDefinitionNode)
				         ifTrue: [ self createMetaclassNamed: name ]
				         ifFalse: [ self createClassNamed: name ] ].

	class typeContainer: self currentEntity.

	self setSourceAnchor: class from: aClassDefinitionNode.

	^ self useCurrentEntity: class during: [
			  self flag: #todo. "Add test of a class with a superclass and a metaclass"
			  self flag: #todo. "Add test on multiple inheritance"
			  self visit: aClassDefinitionNode _superclasses.
			  self ensureSuperclassFor: aClassDefinitionNode.
			  self visit: aClassDefinitionNode _body ]
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitComment: aCommentNode [
	"noop - Managed by the comment importer"

	
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitComparisonOperator: aNode [
	"
	Children:
		- <unnamedChild>: identifier / set_comprehension / binary_operator / comment / unary_operator / concatenated_string / dictionary / call / list / float / none / set / false / generator_expression / ellipsis / string / true / attribute / parenthesized_expression / integer / tuple / line_continuation / list_comprehension / subscript
		
	Parents:
		- Visiting me: if_statement / elif_clause / if_clause / augmented_assignment / argument_list / not_operator / expression_statement / while_statement / return_statement / assignment / pair / boolean_operator / assert_statement / lambda / list / list_comprehension
		- Not yet managed:  expression_list / generator_expression / conditional_expression / keyword_argument / parenthesized_expression / tuple / subscript
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitContinueStatement: aNode [
	"
	Children: none
	
	Parents:
		- Visiting me: block
	
	example:
	
		for i in range(5):
		    if i == 3:
 		       continue
  		  print(i)
		
	noop, nothing to do at Famix level."

	
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitDefaultParameter: aNode [
	"
	Children:
		- name: identifier
		- value: list / lambda / none / string / tuple / attribute / binary_operator / unary_operator / identifier / false / true / ellipsis / dictionary / float / integer / call
		
	Parents:
		- Parents visiting me: parameters / lambda_parameters
	"

	(self visit: aNode _name) attributeAt: #hasDefaultValue put: true.
	self visit: aNode _value
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitDictionary: aNode [
	"
	Children:
		- <unnamedChild>: pair / comment / dictionary_splat
		
	Parents:
		- Visiting me: argument_list / assignment / binary_operator / boolean_operator / comparison_operator / dictionary_splat / expression_statement / lambda / pair /  return_statement / list / list_comprehension
		- Not yet managed: attribute / conditional_expression / default_parameter / expression_list / generator_expression / keyword_argument / parenthesized_expression / subscript / tuple / typed_default_parameter
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitDictionaryComprehension: aNode [
	"
	Children:
		- body: pair
		- <unnamedChild>: for_in_clause / if_clause / comment
		
	Parents:
		- Visiting me: argument_list / assignment / binary_operator / dictionary_splat / lambda / pair / return_statement / list / list_comprehension
		- Not yet managed: attribute / conditional_expression / expression_list / keyword_argument / tuple
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitDictionarySplat: aParameterNode [
	"
	Children:
		- <unnamedChild>: subscript / call / dictionary / attribute / parenthesized_expression / identifier / dictionary_comprehension
		
	Parents:
		- Visiting me: argument_list / dictionary
		"

	^ self visitChildren: aParameterNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitDictionarySplatPattern: aNode [
	"
	Children:
		- <unnamedChild>: identifier
		
	Parents:
		- Parents visiting me: lambda_parameters / parameters
		- Not yet managed: typed_parameter
	"

	"There can be only one child"
	^ (self visitChildren: aNode) anyOne
		  attributeAt: #isDictionarySplat put: true;
		  yourself
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitDottedName: aDottedNameNode [
	"
	Children:
		- unnamed: identifier
		
	Parents:
		- Visiting me: aliased_import / import_from_statement / import_statement
		- Skipping me: relative_import
		- Non yet managed: future_import_statement
		
	We do not visit the children."

	^ aDottedNameNode sourceText
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitElifClause: aNode [
	"
	Children:
		- condition: not_operator / subscript / boolean_operator / call / comparison_operator / attribute / parenthesized_expression / identifier / binary_operator
		- consequence: block
		- unnamed: comment
		
	Parents:
		- Visiting me: if_statement
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitElseClause: aNode [
	"
	Children:
		- body: block
		- unnamed: comment
		
	Parents:
		- Visiting me: while_statement / if_statement
		- Not yet managed: try_statement / for_statement
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitExpressionStatement: aNode [

	^ self visitChildren: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitFalse: aNode [
	"noop"

	
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitFloat: aNode [
	"noop"

	
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitForInClause: aNode [
	"
	Children:
		- left: pattern_list / identifier / tuple_pattern
		- right: list / subscript / generator_expression / string / tuple / attribute / binary_operator / parenthesized_expression / identifier / list_comprehension / set / set_comprehension / call
		- <unnamedChild>: comment
		
	Parents:
		- Visiting me: dictionary_comprehension / list_comprehension
		- Not yet managed: generator_expression / set_comprehension
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitFunctionDefinition: aFunctionDefinition [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| entity |
	entity := self currentEntity isClass
		          ifTrue: [ self manageMethodDeclarationFrom: aFunctionDefinition ]
		          ifFalse: [ self manageFunctionDeclarationFrom: aFunctionDefinition ].

	^ self useCurrentEntity: entity during: [
			  self visit: aFunctionDefinition _parameters.
			  self visit: aFunctionDefinition _body ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitFutureImportStatement: aNode [
	"
	Children:
		- name: dotted_name / aliased_import
		
	Parents:
		- Visiting me: module
	"

	| name |
	name := self visit: aNode _name.
	^ self
		  manageImport: aNode
		  ofName: (name isString
				   ifTrue: [ name ]
				   ifFalse: [ name key ])
		  from: '__future__'
		  alias: (name isString
				   ifTrue: [ nil ]
				   ifFalse: [ name value ])
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitGlobalStatement: aNode [

	self flag: #todo
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitIdentifier: anIdentifierNode [
	"An identifier is widly used in the python tree. 
	Some are just names and some can represent an access or a reference."
	
	anIdentifierNode isParameterDeclaration ifTrue: [ ^ self createParameterFrom: anIdentifierNode ].
	
	"In a class definition signature, this represent the declaration of a superclass."
	anIdentifierNode parent parent type = #class_definition ifTrue: [ ^ self manageInheritanceDeclaredBy: anIdentifierNode ].

	"Manages write access separated to read access"
	anIdentifierNode isLeftSideOfAssignation ifTrue: [ ^ self manageWriteAccessTo: anIdentifierNode ].

	self manageAccessOrReferencesFrom: anIdentifierNode.

	^ anIdentifierNode sourceText
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitIfClause: aNode [
	"
	Children:
		- <unnamedChild>: not_operator / binary_operator / boolean_operator / call / comparison_operator / attribute / parenthesized_expression / identifier / subscript
		
	Parents:
		- Visiting me: dictionary_comprehension / list_comprehension
		- Not yet managed: generator_expression / set_comprehension
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitIfStatement: aNode [
	"
	Children:
		- condition: call / subscript / conditional_expression / attribute / binary_operator / parenthesized_expression / identifier / list_comprehension / true / boolean_operator / named_expression / comparison_operator / integer / not_operator
		- consequence: block
		- alternative: elif_clause / else_clause
		- unnamed: comment
		
	Parents:
		- Visiting me: module / block
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitImportFromStatement: anImportFromStatement [

	| moduleName identifiers |
	moduleName := self visit: anImportFromStatement _module_name.

	identifiers := self visit:
		               (anImportFromStatement _name ifNil: [
			                anImportFromStatement detectNamedChild: 'wildcard_import' ifNone: [ self error: 'We should have at least one of them.' ] ]).
	identifiers isAssociation ifTrue: [ identifiers := { identifiers } asDictionary ].
	identifiers isString ifTrue: [ identifiers := { identifiers } ].
	identifiers isDictionary ifFalse: [
			identifiers := (identifiers collect: [ :name |
					                name isAssociation
						                ifTrue: [ name ]
						                ifFalse: [ name -> nil ] ]) asDictionary ].


	identifiers keysAndValuesDo: [ :identifier :alias |
			self
				manageImport: anImportFromStatement
				ofName: identifier
				from: moduleName
				alias: alias ]
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitImportPrefix: aNode [
	"
	Children: none
	
	Parents:
		- Skipping me: relative_import"

	self error: 'We should never end up here. I can only be in a relative import and its visit does not visit me.'
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitImportStatement: anImportStatement [

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
				manageImport: anImportStatement
				ofName: identifier
				from: nil
				alias: alias ]
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitInteger: aNode [
	"noop"

	
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitInterpolation: aNode [
	"
	Children:
		- expression: list / subscript / none / conditional_expression / string / attribute / binary_operator / unary_operator / parenthesized_expression / identifier / tuple / list_comprehension / false / boolean_operator / named_expression / integer / float / call
		- type_conversion: type_conversion
		- format_specifier: format_specifier
		
	Parents:
		- Visiting me: string
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitKeywordArgument: aKeywordArgumentNode [

	"In the class definition, if we have a #metaclass argument, then it's a metaclass usage"
	(aKeywordArgumentNode _name sourceText = #metaclass and: [ aKeywordArgumentNode parent parent type = #class_definition ]) ifTrue: [
		self manageMetaclassUsageDeclaredBy: aKeywordArgumentNode ].

	^ self visit: aKeywordArgumentNode _value
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitKeywordSeparator: aNode [
	"
	Children: none
		
	Parents:
		- Parents visiting me: lambda_parameters / parameters
	"

	self currentEntity attributeAt: #keywordSeparatorPosition put: self currentEntity parameters size + 1
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitLambda: aLambdaNode [
	"
	Children:
		- parameters: lambda_parameters
		- body: identifier / binary_operator / concatenated_string / unary_operator / dictionary / call / list / not_operator / boolean_operator / float / none / set / dictionary_comprehension / false / conditional_expression / string / true / attribute / parenthesized_expression / integer / comparison_operator / tuple / list_comprehension / subscript
	
	Parents:
		- Visiting me: argument_list / assignment /  default_parameter  / pair / return_statement / list
		- Not yet managed: conditional_expression / expression_list / keyword_argument / parenthesized_expression / subscript / tuple / typed_default_parameter
	"

	| lambda |
	lambda := model newLambda
		          lambdaContainer: self currentEntity;
		          signature: (aLambdaNode _parameters
				           ifNotNil: [ :node | node sourceText ]
				           ifNil: [ '' ]);
		          yourself.

	self setSourceAnchor: lambda from: aLambdaNode.

	^ self useCurrentEntity: lambda during: [ self visitChildren: aLambdaNode ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitLambdaParameters: aParameterNode [
	"
	Children: 
		- <unnamedChild>: dictionary_splat_pattern / default_parameter / list_splat_pattern / keyword_separator / identifier
		
	Parents:
		- Visiting me: lambda"

	^ self visitChildren: aParameterNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitList: aNode [
	"
	Children:
		- <unnamedChild>: identifier / binary_operator / comment / unary_operator / concatenated_string / dictionary / call / list / not_operator / boolean_operator / float / none / set / dictionary_comprehension / false / conditional_expression / ellipsis / generator_expression / string / true / attribute / list_splat / parenthesized_expression / integer / lambda / comparison_operator / tuple / list_comprehension / subscript
		
	Parents: 
		- Visiting me: argument_list / assert_statement / assignment / augmented_assignment / binary_operator / boolean_operator / comparison_operator / for_in_clause / lambda / list / list_comprehension / pair / return_statement
		- Not yet managed: attribute / conditional_expression / default_parameter / expression_list / for_statement / generator_expression / interpolation / keyword_argument / list_splat / parenthesized_expression / subscript / tuple / type / typed_default_parameter / yield"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitListComprehension: aNode [
	"
	Children:
		- body: identifier / binary_operator / unary_operator / dictionary / call / list / not_operator / boolean_operator / none / dictionary_comprehension / set / conditional_expression / string / attribute / parenthesized_expression / integer / comparison_operator / tuple / list_comprehension / subscript
		- <unnamedChild>: line_continuation / for_in_clause / if_clause / comment
		
	Parents:
		- Visiting me: argument_list / assignment / augmented_assignment / binary_operator / boolean_operator / comparison_operator / expression_statement / for_in_clause / if_statement / lambda / list_comprehension / not_operator / pair / return_statement / list
		- Not yet managed: attribute / conditional_expression / expression_list / for_statement / generator_expression / interpolation / keyword_argument / list_splat / subscript / tuple / yield
		"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitListPattern: aNode [
	"
	TODO: Comment
	"
	self flag: #todo. "Comment"
	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitListSplat: aNode [
	"
	Children:
		- <unnamedChild>: list / generator_expression / subscript / tuple / binary_operator / attribute / unary_operator / parenthesized_expression / identifier / list_comprehension / call

	Parents:
		- Visiting me: argument_list / list
		- Not yet managed: subscript / call / set / attribute / tuple
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitListSplatPattern: aNode [
	"
	Children:
		- <unnamedChild>: identifier
		
	Parents:
		- Parents visiting me: lambda_parameters / parameters
		- Not yet managed: pattern_list / tuple_pattern / typed_parameter
	"

	| result |
	result := self visitChildren: aNode.

	self flag: #todo. "When managing type check for a list splat in a typed parameter"
	result first class = FamixPythonParameter ifTrue: [ result first attributeAt: #isListSplat put: true ].

	^ result
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitModule: aModuleNode [

	| isPackageDeclaration entity |
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

			self currentEntity: entity ].
	
	(fileReference basename = #'moduleAtRoot100.py') ifTrue: [ 1halt ].
	
	self visitChildren: aModuleNode.

	"Importing the comments of the file."
	FamixPythonCommentVisitor visitor: self importCommentsOf: aModuleNode.

	"If we are in a package declaration we need to keep the package in the context for the modules in the package. The package will be pop later by the importer."
	^ isPackageDeclaration
		  ifTrue: [ self currentEntity ]
		  ifFalse: [ self popScope ]
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitNamedExpression: aNamedExpressionNode [
	"Children: 
		- name: identifier
		- value: string / call / binary_operator / identifier / subscript
		
	Parents: 
		- Visiting me: while_statement / if_statement / interpolation / argument_list
		- Todo: parenthesized_expression / tuple
		
	The write accesses will be managed in my children"

	^ self visitChildren: aNamedExpressionNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitNone: aNode [
	"noop"

	
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitNotOperator: aNode [
	"noop"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitPair: aNode [
	"
	Children:
		- key: subscript / none / string / tuple / attribute / binary_operator / unary_operator / parenthesized_expression / identifier / conditional_expression / false / true / boolean_operator / integer / float / call
		- value: identifier / binary_operator / concatenated_string / unary_operator / dictionary / call / list / not_operator / boolean_operator / float / none / dictionary_comprehension / set / false / conditional_expression / generator_expression / string / true / attribute / parenthesized_expression / integer / lambda / comparison_operator / tuple / list_comprehension / subscript
		
	Parents:
		- Visiting me: dictionary_comprehension / dictionary
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitParameters: aParameterNode [
	"
	Children:
		- <unnamedChild>: positional_separator / dictionary_splat_pattern / comment / list_splat_pattern / default_parameter / keyword_separator / typed_default_parameter / identifier / typed_parameter
		
	Parents:
		- Visiting me: function_definition"

	self flag: #todo. "Manage typed parameters"
	self flag: #todo. "Add test that first param not called self is still self"
	^ self visitChildren: aParameterNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitPassStatement: aNode [
	"
	Children: none
	
	Parents:
		- Visiting me: block
	
	example:
	
		class AClassDefinition:
    			pass
		
	noop, nothing to do at Famix level."

	
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitPatternList: aNode [
	"
	TODO: Comment
	"
	self flag: #todo. "Comment"
	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitPositionalSeparator: aNode [
	"
	Children: none
		
	Parents:
		- Parents visiting me: lambda_parameters / parameters
	"

	self currentEntity attributeAt: #positionalSeparatorPosition put: self currentEntity parameters size + 1
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitRelativeImport: aRelativeImportNode [
	"
	Children: 
		- unnamed : dotted_name / import_prefix
		
	Parents:
		- Visiting me: import_from_statement
	
	I don't need to visit the children, I just need the path"

	^ aRelativeImportNode sourceText
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitReturnStatement: aNode [
	"
	Children:
		- <unnamedChild>: identifier / set_comprehension / binary_operator / unary_operator / await / dictionary / call / list / not_operator / boolean_operator / expression_list / float / none / dictionary_comprehension / set / false / conditional_expression / generator_expression / string / true / attribute / parenthesized_expression / integer / comparison_operator / lambda / tuple / list_comprehension / subscript
		
	Parents:
		- Visiting me: block
		"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitString: aStringNode [
	"
	Children:
		- unnamed: string_end / string_content / string_start / interpolation
		
	Parents:
		- Visiting me: for_statement / named_expression / argument_list / augmented_assignment / expression_statement / assignment / subscript / return_statement / binary_operator / boolean_operator / pair / interpolation / default_parameter  / assert_statement / lambda / for_in_clause / list / list_comprehension
		- Not yet managed:  set_comprehension / concatenated_string / type / typed_default_parameter / slice / expression_list / set / generator_expression / conditional_expression / keyword_argument / attribute / yield / parenthesized_expression / comparison_operator / tuple"

	^ self visitChildren: aStringNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitStringContent: aNode [
	" noop
	
	Children:
		- <unnamedChild>: escape_interpolation / escape_sequence
	
	Parents:
		- Visiting me: string"

	^ self visitChildren: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitStringEnd: aNode [
	" noop
	
	Children: none
	
	Parents:
		- Visiting me: string"

	
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitStringStart: aNode [
	" noop
	
	Children: none
	
	Parents:
		- Visiting me: string"

	
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitSubscript: aNode [

	self flag: #todo. "comment"

	aNode isLeftSideOfAssignation ifTrue: [ self flag: #todo ].

	^ self visitChildren: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitTrue: aNode [
	"noop"

	
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitTuplePattern: aNode [
	"
	TODO: Comment
	"
	self flag: #todo. "Comment"
	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitUnaryOperator: aNode [
	"
	Children:
		- argument: subscript / attribute / binary_operator / parenthesized_expression / identifier / false / true / float / integer / call
		
	Parents:
		- Visiting me: binary_operator / argument_list / augmented_assignment / expression_statement / comparison_operator / return_statement / assignment / boolean_operator / pair / interpolation / list_splat / default_parameter/ lambda / list / list_comprehension
		- Not yet managed: type / typed_default_parameter / slice / expression_list / set / conditional_expression / keyword_argument / parenthesized_expression  / tuple / subscript
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting - visitChildren' }
FamixPythonVisitor >> visitWhileStatement: aNode [
	"
	Children:
		- condition: not_operator / subscript / conditional_expression / attribute / parenthesized_expression / identifier / true / boolean_operator / named_expression / comparison_operator / integer / call
		- body: block
		- unnamed: comment
		
	Parents:
		- Visiting me: block
	"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitWildcardImport: aWildcarImportNode [
	"
	Children: none
	
	Parents:
		- Visiting me: import_from_statement"

	^ #( #* )
]
