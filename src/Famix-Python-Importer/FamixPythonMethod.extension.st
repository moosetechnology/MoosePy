Extension { #name : 'FamixPythonMethod' }

{ #category : '*Famix-Python-Importer' }
FamixPythonMethod >> createLocalVariable: aString [ 
	^mooseModel newLocalVariable
		name: aString ;
		parentBehaviouralEntity: self ;
		yourself
]
