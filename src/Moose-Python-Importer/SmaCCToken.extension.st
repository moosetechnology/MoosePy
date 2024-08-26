Extension { #name : 'SmaCCToken' }

{ #category : '*Moose-Python-Importer' }
SmaCCToken >> acceptVisitor: aSmaCCNodeVisitor [
	^aSmaCCNodeVisitor visitSmaCCToken: self
]
