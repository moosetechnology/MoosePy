Extension { #name : 'FamixPythonMethod' }

{ #category : '*MoosePy' }
FamixPythonMethod >> createLocalVariable: aString [ 
	^mooseModel newLocalVariable
		name: aString ;
		parentBehaviouralEntity: self ;
		yourself
]
