Extension { #name : 'FamixPythonFunction' }

{ #category : '*Moose-Python-Importer' }
FamixPythonFunction >> createLocalVariable: aString [ 
	^mooseModel newLocalVariable
		name: aString ;
		parentBehaviouralEntity: self ;
		yourself
]
