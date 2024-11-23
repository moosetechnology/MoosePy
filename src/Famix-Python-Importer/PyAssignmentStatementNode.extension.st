Extension { #name : 'PyAssignmentStatementNode' }

{ #category : '*Famix-Python-Importer' }
PyAssignmentStatementNode >> isAssignation [

	^ true
]

{ #category : '*Famix-Python-Importer' }
PyAssignmentStatementNode >> isLeftSideOfAssignation: aNode [

	^ self lhs = aNode
]
