Extension { #name : 'FamixPythonFunction' }

{ #category : '*MoosePy' }
FamixPythonFunction >> createLocalVariable: aString [ 
	^mooseModel newLocalVariable
		name: aString ;
		parentBehaviouralEntity: self ;
		yourself
]
