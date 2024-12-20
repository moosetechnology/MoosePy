Extension { #name : 'FamixPythonFunction' }

{ #category : '*Famix-Python-Importer' }
FamixPythonFunction >> createLocalVariable: aString [

	^ mooseModel newLocalVariable
		  name: aString;
		  parentBehaviouralEntity: self;
		  yourself
]
