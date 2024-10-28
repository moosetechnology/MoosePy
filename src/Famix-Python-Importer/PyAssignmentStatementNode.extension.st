Extension { #name : 'PyAssignmentStatementNode' }

{ #category : '*Famix-Python-Importer' }
PyAssignmentStatementNode >> isInstanceVariableAssignation [
	"I am an inst var assignation if I am in the form of `self.x = y`. For now I don't know if I need to do more than checking if the value of the receiver of the left side is #self. I might refine this method later."

	self lhs isSubscriptExpression ifTrue: [ ^ false ].

	^ self lhs receiver name = #self
]
