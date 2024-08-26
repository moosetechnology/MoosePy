Extension { #name : 'FamixPythonMethod' }

{ #category : '*Moose-Python-Importer' }
FamixPythonMethod >> createLocalVariable: aString [ 
	^mooseModel newLocalVariable
		name: aString ;
		parentBehaviouralEntity: self ;
		yourself
]
