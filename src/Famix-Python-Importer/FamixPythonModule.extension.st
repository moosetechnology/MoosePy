Extension { #name : 'FamixPythonModule' }

{ #category : '*Famix-Python-Importer' }
FamixPythonModule >> createLocalVariable: aString [

	^ mooseModel newGlobalVariable
		  name: aString;
		  parentScope: self;
		  yourself
]
