Extension { #name : 'FamixPythonClass' }

{ #category : '*Moose-Python-Importer' }
FamixPythonClass >> createLocalVariable: aString [ 
	^mooseModel newAttribute
		name: aString ;
		parentType: self ;
		yourself
]
