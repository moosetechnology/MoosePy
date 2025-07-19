Class {
	#name : 'FamixPythonVisitor',
	#superclass : 'FamixTSAbstractVisitor',
	#instVars : [
		'importPaths'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'private' }
FamixPythonVisitor >> attributeAsAssociation: anAttributeNode [

	^ (anAttributeNode _object sourceText copyWithout: Character space) -> (self visit: anAttributeNode _attribute)
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

{ #category : 'private' }
FamixPythonVisitor >> createAssociationsForFunctionCallNode: aCallNode forResult: result in: currentEntity [

	^ (result isCollection not and: [ result isClass ])
		  ifTrue: [
				  result createAccessOrReferenceFrom: currentEntity node: aCallNode.
				  self createInvocationOf: (self getConstructorOf: result) from: currentEntity node: aCallNode ]
		  ifFalse: [ self createInvocationOf: result from: currentEntity node: aCallNode ]
]

{ #category : 'private' }
FamixPythonVisitor >> createFunction: aFunctionDefinition [

	| function name signature |
	name := self visit: aFunctionDefinition _name.
	signature := aFunctionDefinition completeSource copyFrom: aFunctionDefinition _name startPosition to: aFunctionDefinition _parameters endPosition.

	self checkShadowingOfName: name during: [
			function := model newFunction
				            name: name;
				            signature: signature;
				            functionOwner: self currentEntity;
				            yourself ].

	^ self setSourceAnchor: function from: aFunctionDefinition
]

{ #category : 'private' }
FamixPythonVisitor >> createImport: anImport ofName: aName from: fromName alias: alias [

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
FamixPythonVisitor >> createImportedInheritanceFrom: anAttributeNode [

	| inheritance definition |
	"We should never end up here because this means we have the sources of the imported entities but I'm still bulletproofing the parser in case we have some code that cannot run""If we did not find an import, we have a stub."
	inheritance := self ensureInheritance: anAttributeNode.
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

	inheritance superclass: ((self ensureStubClassNamed: definition value)
			 typeContainer: (self ensureStubPackagesFromPath: definition key);
			 yourself)
]

{ #category : 'private' }
FamixPythonVisitor >> createInheritanceFrom: superclassNode [

	| inheritance |
	inheritance := self ensureInheritance: superclassNode.

	self
		resolve: ((SRIdentifierWithNode identifier: superclassNode sourceText)
				 expectedKind: FamixPythonClass;
				 notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ];
				 yourself)
		foundAction: [ :entity :currentEntity | inheritance superclass: entity ]
]

{ #category : 'private' }
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

{ #category : 'private' }
FamixPythonVisitor >> createMethod: aMethodNode [

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
FamixPythonVisitor >> createStubPackageNamed: aString [

	^ (model newPackageNamed: aString)
		  isStub: true;
		  yourself
]

{ #category : 'private' }
FamixPythonVisitor >> createWriteAccessTo: variable from: anAssignmentNode [

	| access |
	access := model newAccess
		          variable: variable;
		          accessor: self currentEntity;
		          isWrite: true;
		          yourself.
	self setSourceAnchor: access from: anAssignmentNode
]

{ #category : 'as yet unclassified' }
FamixPythonVisitor >> ensureInheritance: anAttributeNode [

	^ model newInheritance
		  subclass: self currentEntity;
		  in: [ :inheritance | self setSourceAnchor: inheritance from: anAttributeNode ];
		  yourself
]

{ #category : 'private' }
FamixPythonVisitor >> ensureMethod: aMethodNode [

	^ (self methodNamed: aMethodNode _name inClassNamed: self currentEntity name) ifNil: [ self createMethod: aMethodNode ]
]

{ #category : 'private' }
FamixPythonVisitor >> ensureStubClassNamed: aName [

	^ model allClasses
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [
				  (model newClassNamed: aName)
					  isStub: true;
					  yourself ]
]

{ #category : 'private' }
FamixPythonVisitor >> ensureStubMetaclassNamed: aName [

	^ (model allWithType: FamixPythonMetaclass)
		  detect: [ :class | class isStub and: [ class name = aName ] ]
		  ifNone: [
				  model newMetaclass
					  name: aName;
					  isStub: true;
					  yourself ]
]

{ #category : 'private' }
FamixPythonVisitor >> ensureStubMethodNamed: aName [

	^ model allMethods
		  detect: [ :method | method isStub and: [ method name = aName ] ]
		  ifNone: [
				  (model newMethodNamed: aName)
					  isStub: true;
					  yourself ]
]

{ #category : 'private' }
FamixPythonVisitor >> ensureStubPackageNamed: aString [

	^ model allPackages
		  detect: [ :class | class isStub and: [ class name = aString ] ]
		  ifNone: [ self createStubPackageNamed: aString ]
]

{ #category : 'private' }
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

{ #category : 'private' }
FamixPythonVisitor >> ensureStubUnknownEntityNamed: aString [

	^ (self unknownEntityNamed: aString) ifNil: [
			  model newUnknownEntity
				  name: aString;
				  yourself ]
]

{ #category : 'private' }
FamixPythonVisitor >> ensureSuperclassFor: aClassDefinitionNode [
	"Visiting the children of the superclasses should create the superclass of the class definition. But, if there are none, this means we should inherit from object."

	self currentEntity superInheritances ifEmpty: [
			model newInheritance
				superclass: (self ensureStubClassNamed: 'object');
				subclass: self currentEntity ]
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
FamixPythonVisitor >> initialize [

	super initialize.
	self flag: #todo. "Add management and tests on parenthesized_expression kind of node"
	importPaths := IdentityDictionary new
]

{ #category : 'testing' }
FamixPythonVisitor >> isMetaclassDefinition: aClassDefinitionNode [

	^ aClassDefinitionNode _superclasses
		  ifNil: [ false ]
		  ifNotNil: [ :argumentList | argumentList collectNamedChild anySatisfy: [ :node | node type = #identifier and: [ node sourceText = 'type' ] ] ]
]

{ #category : 'private' }
FamixPythonVisitor >> manageAssignationTo: aNode [

	| variable |
	aNode type = #attribute
		ifTrue: [
				| pair |
				pair := self attributeAsAssociation: aNode.
				self flag: #todo. "Might not be self..."
				pair key = 'self'
					ifTrue: [
							| class |
							class := self currentEntityOfType: FamixPythonClass.
							variable := (class childOfType: FamixTAttribute named: pair value) ifNil: [
									            variable := self model newAttribute
										                        name: pair value;
										                        parentType: class;
										                        isClassSide: false;
										                        yourself.
									            self setSourceAnchor: variable from: aNode.
									            variable ] ]
					ifFalse: [
							self flag: #todo.
							^ self ] ]
		ifFalse: [
				| name |
				name := self visit: aNode.
				"If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
				(self currentEntity query descendants ofType: FamixTStructuralEntity)
					detect: [ :child | child name = name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
					ifFound: [ :var | variable := var ]
					ifNone: [
							self checkShadowingOfName: name during: [ variable := self currentEntity createLocalVariable: name ].
							self setSourceAnchor: variable from: aNode ] ].
	self createWriteAccessTo: variable from: aNode assignationNode.
	"In the case of an augmented assignment, we produce a read access on top of the write access"
	aNode assignationNode type = #augmented_assignment ifTrue: [ variable createAccessOrReferenceFrom: self currentEntity node: aNode assignationNode ].
	^ variable
]

{ #category : 'private' }
FamixPythonVisitor >> manageMetaclassUsageFrom: aKeywordArgumentNode [

	| metaclassUsage |
	metaclassUsage := model newMetaclassUsage.
	metaclassUsage user: self currentEntity.
	self setSourceAnchor: metaclassUsage from: aKeywordArgumentNode. "If it's not an identifier then it means it's an imported metaclass."
	^ aKeywordArgumentNode _value type = #identifier
		  ifTrue: [
				  self
					  resolve: ((SRIdentifierWithNode identifier: aKeywordArgumentNode _value sourceText)
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

{ #category : 'accessing' }
FamixPythonVisitor >> methodNamed: aString inClassNamed: aClassName [

	^ (self model allWithType: FamixPythonMethod)
		  detect: [ :e | e name = aString and: [ e parentType name = aClassName ] ]
		  ifNone: [ nil ]
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

{ #category : 'private' }
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
		- Visiting me: import_statement / import_from_statement"

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

{ #category : 'visiting' }
FamixPythonVisitor >> visitAssignment: anAssignmentNode [
	"I represent an assignation expression that is different from an assignation statement we can find in lambdas"

	anAssignmentNode _left type = #subscript ifTrue: [ ^ self visitChildren: anAssignmentNode ].

	anAssignmentNode _left type = #pattern_list
		ifTrue: [ (self visit: anAssignmentNode _left) collect: [ :node | self manageAssignationTo: node ] ]
		ifFalse: [ self manageAssignationTo: anAssignmentNode _left ].

	"We visitied the left side above, now we need to visit the right side."
	self visit: anAssignmentNode _right
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitAttribute: anAttributeNode [
	"An attribute can signify two things:
		- It's the receiver of a method or function call so we use it to produce an invocation or instantiation
		- Else it is probably a reference or access to something imported with a simple import."

	| source name |
	
	anAttributeNode parent parent type = #class_definition ifTrue: [ ^ self createImportedInheritanceFrom: anAttributeNode ].
	
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
				foundAction: [ :entity :currentEntity | entity createAccessOrReferenceFrom: currentEntity node: anAttributeNode ].
			^ source ].

	self flag: #todo. "We are missing instance variable accesses here"
	"1halt"
	^ source
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitAugmentedAssignment: aNode [
	"We should manage it the same way as a normal assignment in Famix. The only change is that we will create a read access to the variable on the left side, but this will be dealt with in another place."

	^ self visitAssignment: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitBlock: aNode [

	^ self visitChildren: aNode
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
				         ifTrue: [ model newMetaclassNamed: name ]
				         ifFalse: [ model newClassNamed: name ] ].

	class typeContainer: self currentEntity.

	self setSourceAnchor: class from: aClassDefinitionNode.

	^ self useCurrentEntity: class during: [
			  self flag: #todo. "Add test of a class with a superclass and a metaclass"
			  self flag: #todo. "Add test on multiple inheritance"
			  self visit: aClassDefinitionNode _superclasses.
			  self ensureSuperclassFor: aClassDefinitionNode.
			  self flag: #todo. "Setting the metaclass should be done while visiting keywork parameters I think. Not here"
			  "  self setMetaclassOf: aClassDefinitionNode."
			  self visit: aClassDefinitionNode _body ]
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitComment: aCommentNode [
	"noop - Managed by the comment importer"

	
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

{ #category : 'visiting' }
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

{ #category : 'visiting' }
FamixPythonVisitor >> visitFunctionDefinition: aFunctionDefinition [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."

	| entity |
	entity := self currentEntity isClass
		          ifTrue: [ self ensureMethod: aFunctionDefinition ]
		          ifFalse: [ self createFunction: aFunctionDefinition ].

	^ self useCurrentEntity: entity during: [
			  self visit: aFunctionDefinition _parameters.
			  self visit: aFunctionDefinition _body ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitGlobalStatement: aNode [

	self flag: #todo
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitIdentifier: anIdentifierNode [

	anIdentifierNode parent parent type = #class_definition ifTrue: [ ^ self createInheritanceFrom: anIdentifierNode ].

	self flag: #todo. "review some + clean method"
	self flag: #todo. "Manage the for_statement"
	(#( attribute call function_definition parameters keyword_argument lambda_parameters named_expression pattern_list list_comprehension parenthesized_expression
	    for_statement subscript ERROR ) includes: anIdentifierNode parent type) ifTrue: [ ^ anIdentifierNode sourceText ].
	anIdentifierNode isLeftSideOfAssignation ifTrue: [ ^ anIdentifierNode sourceText ].
	(#( list argument_list return_statement lambda if_statement comparison_operator binary_operator assignment not_operator ) includes:
		 anIdentifierNode parent type) ifTrue: [
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
					  entity isMooseEntity ifTrue: [ entity createAccessOrReferenceFrom: currentEntity node: anIdentifierNode ] ] ].



	1 halt
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitImportFromStatement: anImportFromStatement [

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
				createImport: anImportStatement
				ofName: identifier
				from: nil
				alias: alias ]
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitInteger: aNode [
	"noop"

	
]

{ #category : 'private' }
FamixPythonVisitor >> visitKeywordArgument: aKeywordArgumentNode [

	"In the class definition, if we have a #metaclass argument, then it's a metaclass usage"
	(aKeywordArgumentNode _name sourceText = #metaclass and: [ aKeywordArgumentNode parent parent type = #class_definition ]) ifTrue: [
		self manageMetaclassUsageFrom: aKeywordArgumentNode ].

	^ self visit: aKeywordArgumentNode _value
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitLambda: aLambdaNode [

	| lambda |
	lambda := model newLambda.
	lambda signature: (aLambdaNode _parameters
			 ifNotNil: [ :node | aLambdaNode completeSource copyFrom: node startPosition to: node endPosition ]
			 ifNil: [ '' ]).
	lambda lambdaContainer: self currentEntity.

	self setSourceAnchor: lambda from: aLambdaNode.
	^ self useCurrentEntity: lambda during: [ self visitChildren: aLambdaNode ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitLambdaParameters: aParameterNode [

	^ self visitParameters: aParameterNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitList: aNode [
	"noop"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitListComprehension: aNode [
	"noop"

	
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
	
	"(fileReference basename = #'moduleAtRoot5.py') ifTrue: [ 1halt ]."
	
	self visitChildren: aModuleNode.

	"Importing the comments of the file."
	FamixPythonCommentVisitor visitor: self importCommentsOf: aModuleNode.

	"If we are in a package declaration we need to keep the package in the context for the modules in the package. The package will be pop later by the importer."
	^ isPackageDeclaration
		  ifTrue: [ self currentEntity ]
		  ifFalse: [ self popScope ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitNamedExpression: aNamedExpressionNode [

	| name variable |
	name := self visit: aNamedExpressionNode _name.

	"If we have a variable of this name already, we should not recreate it. Except if this variable got shadowed! In that case, we should recreate it."
	(self currentEntity query descendants ofType: FamixPythonLocalVariable)
		detect: [ :child | child name = name and: [ child isShadowable not or: [ child isShadowed not ] ] ]
		ifFound: [ :var | variable := var ]
		ifNone: [
				self flag: #todo. "Add test on shadowing at this level. This is not yet covered by test. If you comment the next line the parser is still passing all tests."
				self checkShadowingOfName: name during: [ variable := self currentEntity createLocalVariable: name ].
				self setSourceAnchor: variable from: aNamedExpressionNode _name ].

	self createWriteAccessTo: variable from: aNamedExpressionNode.

	self visitChildren: aNamedExpressionNode.
	^ variable
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitNone: aNode [
	"noop"

	
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitNotOperator: aNode [
	"noop"

	^ self visitChildren: aNode
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitParameters: aParameterNode [

	self flag: #todo. "Manage weird cases like \"
	self flag: #todo. "Add test that first param not called self is still self"
	^ aParameterNode collectNamedChild collect: [ :parameter |
			  (model newParameterNamed: (self visit: parameter))
				  parentBehaviouralEntity: self currentEntity;
				  in: [ :param | self setSourceAnchor: param from: parameter ] ]
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitPatternList: aPatternListNode [

	^ aPatternListNode collectNamedChild
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

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitReturnStatement: aNode [

	^ self visitChildren: aNode
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitString: aStringNode [
	"noop - we don't need the children and comments are managed in a separated visitor."

	^ self
]

{ #category : 'visiting - noop' }
FamixPythonVisitor >> visitTrue: aNode [
	"noop"

	
]

{ #category : 'visiting' }
FamixPythonVisitor >> visitWildcardImport: aWildcarImportNode [

	^ #( #* )
]
