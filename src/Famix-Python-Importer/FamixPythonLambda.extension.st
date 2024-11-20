Extension { #name : 'FamixPythonLambda' }

{ #category : '*Famix-Python-Importer' }
FamixPythonLambda >> createLocalVariable: aString [

	^ mooseModel newLocalVariable
		  name: aString;
		  parentBehaviouralEntity: self;
		  yourself
]
