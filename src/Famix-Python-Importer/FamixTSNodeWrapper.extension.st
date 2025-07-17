Extension { #name : 'FamixTSNodeWrapper' }

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> assignationNode [

	self type = #assignment ifTrue: [ ^ self ].
	^ self parent ifNotNil: [ self parent assignationNode ]
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isLeftSideOfAssignation [

	self parentsDo: [ :node | (#( assignment augmented_assignment ) includes: node type) ifTrue: [ ^ node _left includesChild: self ] ].
	^ false
]
