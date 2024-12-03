"
I am a visitor that will specialize some nodes of the SmaCC Python pseudo AST in order to have a cleaner tree and something easier to visit.
"
Class {
	#name : 'FamixPythonSmaCCASTSpecializer',
	#superclass : 'PyRootNodeVisitor',
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'generated' }
FamixPythonSmaCCASTSpecializer >> visitVariableExpression: aVariableExpression [
	"This node is used in multiple situations. I am trying to remove some ambiguity by specializing the nodes."

	aVariableExpression isReservedLiteral ifTrue: [ ^ FamixPythonReservedLiteralNode adoptInstance: aVariableExpression ].

	aVariableExpression isPlaceholderVariable ifTrue: [ ^ FamixPythonPlaceholderVariableNode adoptInstance: aVariableExpression ].

	"aVariableExpression isFunctionCallExpression ifTrue: [ ^ FamixPythonFunctionCallReceiverVariableNode adoptInstance: aVariableExpression ].

	aVariableExpression isInImport ifTrue: [ ^ FamixPythonImportVariableExpressionNode adoptInstance: aVariableExpression ]"
]
