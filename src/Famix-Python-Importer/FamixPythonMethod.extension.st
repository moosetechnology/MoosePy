Extension { #name : 'FamixPythonMethod' }

{ #category : '*Famix-Python-Importer' }
FamixPythonMethod >> createLocalVariable: aString [

	^ (mooseModel newLocalVariableNamed: aString)
		  parentBehaviouralEntity: self;
		  yourself
]
