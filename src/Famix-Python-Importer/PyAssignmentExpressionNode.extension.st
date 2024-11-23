Extension { #name : 'PyAssignmentExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyAssignmentExpressionNode >> isAssignation [

	^ true
]

{ #category : '*Famix-Python-Importer' }
PyAssignmentExpressionNode >> isLeftSideOfAssignation: aNode [

	^ self variable = aNode
]
