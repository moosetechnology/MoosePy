Extension { #name : 'FamixPythonFunction' }

{ #category : '*Famix-Python-Importer' }
FamixPythonFunction >> createLocalVariable: aString [

	^ (mooseModel newLocalVariableNamed: aString)
		  parentBehaviouralEntity: self;
		  yourself
]
