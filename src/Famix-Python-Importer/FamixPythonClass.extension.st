Extension { #name : 'FamixPythonClass' }

{ #category : '*Famix-Python-Importer' }
FamixPythonClass >> createLocalVariable: aString [ 
	^mooseModel newAttribute
		name: aString ;
		parentType: self ;
		yourself
]
