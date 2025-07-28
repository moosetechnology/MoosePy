Extension { #name : 'FamixPythonClass' }

{ #category : '*Famix-Python-Importer' }
FamixPythonClass >> createVariable: aString [ 
	^mooseModel newAttribute
		name: aString ;
		parentType: self ;
		isClassSide: true;
		yourself
]
