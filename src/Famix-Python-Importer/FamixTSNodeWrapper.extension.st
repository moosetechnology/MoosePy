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

	^ self parent isNotNil and: [ self parent type = #parameters ]
]
