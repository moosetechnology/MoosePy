Extension { #name : 'FamixTSNodeWrapper' }

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> assignationNode [

	self type = #assignment ifTrue: [ ^ self ].
	^ self parent ifNotNil: [ self parent assignationNode ]
]

{ #category : '*Famix-Python-Importer' }
FamixTSNodeWrapper >> isLeftSideOfAssignation [

	self parentsDo: [ :node | node type = #assignment ifTrue: [ ^ node _left includesChild: self ] ].
	^ false
]
