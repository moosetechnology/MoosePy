Extension { #name : 'SmaCCToken' }

{ #category : '*MoosePy' }
SmaCCToken >> acceptVisitor: aSmaCCNodeVisitor [
	^aSmaCCNodeVisitor visitSmaCCToken: self
]
