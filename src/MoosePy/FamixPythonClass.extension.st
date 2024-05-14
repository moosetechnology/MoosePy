Extension { #name : #FamixPythonClass }

{ #category : #'*MoosePy' }
FamixPythonClass >> createLocalVariable: aString [ 
	^mooseModel newAttribute
		name: aString ;
		parentType: self ;
		yourself
]
