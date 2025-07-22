Extension { #name : 'FamixTSNodeWrapper' }

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> assignationNode [

	(#( assignment augmented_assignment named_expression ) includes: self type) ifTrue: [ ^ self ].
	^ self parent ifNotNil: [ self parent assignationNode ]
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isLeftSideOfAssignation [

	self parentsDo: [ :node |
		(#( assignment augmented_assignment ) includes: node type) ifTrue: [ ^ node _left includesChild: self ].
		node type = #named_expression ifTrue: [ ^ node _name = self ] ].
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
