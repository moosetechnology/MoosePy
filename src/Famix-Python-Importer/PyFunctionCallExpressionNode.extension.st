Extension { #name : 'PyFunctionCallExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyFunctionCallExpressionNode >> hasReceiver [
	"I return true if my `receiver` has a receiver. (Because my receiver is not really a receiver but what is been invoked or referenced."

	^ self receiver hasReceiver
]

{ #category : '*Famix-Python-Importer' }
PyFunctionCallExpressionNode >> isFunctionCallExpression [

	^ true
]
