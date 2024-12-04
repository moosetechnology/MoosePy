Extension { #name : 'FamixPythonClass' }

{ #category : '*Famix-Python-Importer' }
FamixPythonClass >> createAccessOrReferenceFrom: anEntity node: aNode [

	^ anEntity mooseModel newReference
		  referredType: self;
		  referencer: anEntity;
		  yourself
]

{ #category : '*Famix-Python-Importer' }
FamixPythonClass >> createLocalVariable: aString [ 
	^mooseModel newAttribute
		name: aString ;
		parentType: self ;
		isClassSide: true;
		yourself
]
