"
Check my super class comment for more info.

I consider that single line comments are node of type comment and the multiline comments are the string nodes that are in expression statements (so not in assignations or argument list, etc)
"
Class {
	#name : 'FamixPythonCommentVisitor',
	#superclass : 'FamixTSAbstractCommentsVisitor',
	#category : 'Famix-Python-Importer-Core',
	#package : 'Famix-Python-Importer',
	#tag : 'Core'
}

{ #category : 'visiting' }
FamixPythonCommentVisitor >> visitNode: aTSNode [

	aTSNode type = #comment ifTrue: [ self addSingleLineCommentNode: aTSNode ].

	(aTSNode type = #string and: [ aTSNode parent type = #expression_statement ]) ifTrue: [ self addMultilineCommentNode: aTSNode ].

	super visitNode: aTSNode
]
