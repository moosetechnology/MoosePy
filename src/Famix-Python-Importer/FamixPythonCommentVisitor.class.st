Class {
	#name : 'FamixPythonCommentVisitor',
	#superclass : 'FamixTSAbstractCommentsVisitor',
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'visiting' }
FamixPythonCommentVisitor >> visitNode: aTSNode [

	aTSNode type = #comment ifTrue: [ self addSingleLineCommentNode: aTSNode ].

	(aTSNode type = #string and: [ aTSNode parent type = #expression_statement ]) ifTrue: [ self addMultilineCommentNode: aTSNode ].

	super visitNode: aTSNode
]
