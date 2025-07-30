Extension { #name : 'FamixTSNodeWrapper' }

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> assignationNode [

	(#( assignment augmented_assignment named_expression ) includes: self type) ifTrue: [ ^ self ].
	^ self parent ifNotNil: [ self parent assignationNode ]
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isAccessOrReferenceNode [
	"I should return true if an Identifier node represent an access or a reference."

	^ #( elif_clause list argument_list return_statement lambda if_statement comparison_operator binary_operator assignment not_operator expression_statement
	     augmented_assignment unary_operator boolean_operator pair list_splat default_parameter dictionary_splat #if_clause #for_in_clause generator_expression
	     list_comprehension dictionary_comprehension string_content interpolation) includes: self parent type
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isLeftSideOfAssignation [

	self parentsDo: [ :node |
		(#( assignment augmented_assignment ) includes: node type) ifTrue: [ ^ node _left includesChild: self ].
		node type = #named_expression ifTrue: [ ^ node _name = self ] ].
^ false
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isLocalVariableDeclaration [

	"print(localVarInGeneratorExpression2 * localVarInGeneratorExpression2 for localVarInGeneratorExpression2 in range(5)) ==> When it's in the body, it can be a local variable declaration. But not in the other children."
	(self isInField: #body ofParentOfType: #generator_expression) ifTrue: [ ^ true ].
	
	"[localVarInListComprehension for localVarInListComprehension in [4, 5] if localVarInListComprehension > 2]"
	(self isInField: #body ofParentOfType: #list_comprehension) ifTrue: [ ^ true ].
	
	"{localVariableInDictionaryComprehension * localVariableInDictionaryComprehension: localVariableInDictionaryComprehension for localVariableInDictionaryComprehension in [4, 5] if localVariableInDictionaryComprehension > 10}"
	(self isInField: #body ofParentOfType: #dictionary_comprehension) ifTrue: [ ^ true ].
	
	^ false
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isParameterDeclaration [

	"def f(arg):"
	self parent isParameterList ifTrue: [ ^ true ].
	
	"def f(*args):"
	(self parent type = #list_splat_pattern and: [ self parent parent isParameterList ]) ifTrue: [ ^ true ].
	
	"def f(**kwarg):"
	self parent type = #dictionary_splat_pattern ifTrue: [ ^ true ].

	"In a default parameter, it represent the parameter if it's in the name field."
	"def f(arg=3):"
	(self parent type = #default_parameter and: [ self parent _name = self ]) ifTrue: [ ^ true ].

	^ false
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isParameterList [

	^ #( lambda_parameters parameters ) includes: self type
]
