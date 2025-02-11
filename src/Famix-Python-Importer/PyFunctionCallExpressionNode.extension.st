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

{ #category : '*Famix-Python-Importer' }
PyFunctionCallExpressionNode >> isLocalMethodInvocation [
	"A local method invocation is a method invocation in the class defining the method. E.g `self.method(x)"

	^ self receiver receiver isSelf
]
