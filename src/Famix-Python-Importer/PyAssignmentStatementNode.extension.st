Extension { #name : 'PyAssignmentStatementNode' }

{ #category : '*Famix-Python-Importer' }
PyAssignmentStatementNode >> isAssignation [

	^ true
]

{ #category : '*Famix-Python-Importer' }
PyAssignmentStatementNode >> isLeftSideOfAssignation: aNode [

	self lhs = aNode ifTrue: [ ^ true ].

	"We cannot just look at the left side because we might have multiple assignations like this:
	
	local_multiple1 = local_multiple2 = local_multiple3 = 2
	
	In that case we consider that local_multiple2 and 3  are also on the left side."

	^ self tos allButLast includes: aNode
]
