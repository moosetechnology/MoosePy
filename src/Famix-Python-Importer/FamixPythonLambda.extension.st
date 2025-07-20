Extension { #name : 'FamixPythonLambda' }

{ #category : '*Famix-Python-Importer' }
FamixPythonLambda >> createLocalVariable: aString [

	^ (mooseModel newLocalVariableNamed: aString)
		  parentBehaviouralEntity: self;
		  yourself
]
