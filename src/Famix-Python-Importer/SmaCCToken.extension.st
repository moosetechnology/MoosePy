Extension { #name : 'SmaCCToken' }

{ #category : '*Famix-Python-Importer' }
SmaCCToken >> acceptVisitor: aSmaCCNodeVisitor [
	^aSmaCCNodeVisitor visitSmaCCToken: self
]
