Extension { #name : 'PyVariableExpressionNode' }

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> hasReceiver [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isArgumentKeyword [

	^ self parent isArgumentNode
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isInvocationOrInstantiationIdentifier [
	"If we have an invocation or instantiation such as `print(3)` or `AClass()`, then I represent the identifier `print` or `AClass`."

	^ self parent isFunctionCallExpression and: [ self parent receiver = self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isInvocationOrInstantiationReceiver [

	^ self parent isNotNil and: [ self parent isInstantiationOrInvocationWithReceiver: self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isLeftSideOfAssignation [

	^ self parent
		  ifNil: [ false ]
		  ifNotNil: [ :node | node isLeftSideOfAssignation: self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isPlaceholderVariable [
	"A placeholder variable is the use of `_` instead of a variable to ignore it."

	^ self name = '_'
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isReservedLiteral [

	^ #( True False None NotImplemented Ellipsis __debug__ ) includes: self name
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isSelf [

	^ self name = #self
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isSuperclassDeclaration [

	^ self parent isClassDefinition and: [ self parent superClasses includes: self ]
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> isVariableExpression [

	^ true
]

{ #category : '*Famix-Python-Importer' }
PyVariableExpressionNode >> name [

	^ self nameToken value
]
