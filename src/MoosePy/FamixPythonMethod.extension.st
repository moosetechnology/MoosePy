Extension { #name : #FamixPythonMethod }

{ #category : #'*MoosePy' }
FamixPythonMethod >> createLocalVariable: aString [ 
	^mooseModel newLocalVariable
		name: aString ;
		parentBehaviouralEntity: self ;
		yourself
]

{ #category : #'*MoosePy' }
FamixPythonMethod >> dictLocalVariables [
	^self attributeAt: #dictLocalVariables ifAbsentPut: [ Dictionary new ] 
]
