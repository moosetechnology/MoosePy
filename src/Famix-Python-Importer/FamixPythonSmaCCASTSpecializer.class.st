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
FamixPythonSmaCCASTSpecializer >> visitFieldAccessExpression: aFieldAccessExpression [
	"This node is used in multiple situations. I am trying to remove some ambiguity by specializing the nodes."

	aFieldAccessExpression isInstanceVariableAssignation ifTrue: [ ^ FamixPythonAssignedInstanceVariableNode adoptInstance: aFieldAccessExpression ].

	aFieldAccessExpression isInImport ifTrue: [ ^ FamixPythonImportPathNode adoptInstance: aFieldAccessExpression ].

	"This one needs to be after #isInstanceVariableAssignation."
	aFieldAccessExpression isInternalInstanceVariableAccess ifTrue: [ ^ FamixPythonInternalInstanceVariableAccessNode adoptInstance: aFieldAccessExpression ]
]

{ #category : 'generated' }
FamixPythonSmaCCASTSpecializer >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self flag: #todo
]

{ #category : 'generated' }
FamixPythonSmaCCASTSpecializer >> visitVariableExpression: aVariableExpression [
	"This node is used in multiple situations. I am trying to remove some ambiguity by specializing the nodes."

	aVariableExpression isInvocationOrInstantiationIdentifier ifTrue: [ ^ FamixPythonInstatiationOrInvocationIdentifierNode adoptInstance: aVariableExpression ].

	aVariableExpression isReservedLiteral ifTrue: [ ^ FamixPythonReservedLiteralNode adoptInstance: aVariableExpression ].

	aVariableExpression isPlaceholderVariable ifTrue: [ ^ FamixPythonPlaceholderVariableNode adoptInstance: aVariableExpression ].

	aVariableExpression isInImport ifTrue: [ ^ FamixPythonImportVariableExpressionNode adoptInstance: aVariableExpression ].

	aVariableExpression isLeftSideOfAssignation ifTrue: [ ^ FamixPythonAssignedVariableNode adoptInstance: aVariableExpression ].

	aVariableExpression isSuperclassDeclaration ifTrue: [ ^ FamixPythonSuperclassNode adoptInstance: aVariableExpression ].

	aVariableExpression isArgumentKeyword ifTrue: [ ^ FamixPythonArgumentKeywordNode adoptInstance: aVariableExpression ]
]
