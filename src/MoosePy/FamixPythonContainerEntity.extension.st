Extension { #name : #FamixPythonContainerEntity }

{ #category : #'*MoosePy' }
FamixPythonContainerEntity >> dictLocalVariables [
	^self attributeAt: #dictLocalVariables ifAbsentPut: [ Dictionary new ] 
]
