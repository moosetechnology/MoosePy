Extension { #name : #FamixPythonClass }

{ #category : #'*MoosePy' }
FamixPythonClass >> createLocalVariable: aString [ 
	^mooseModel newAttribute
		name: aString ;
		parentType: self ;
		yourself
]

{ #category : #'*MoosePy' }
FamixPythonClass >> dictLocalVariables [
	^self attributeAt: #dictLocalVariables ifAbsentPut: [ Dictionary new ] 
]
