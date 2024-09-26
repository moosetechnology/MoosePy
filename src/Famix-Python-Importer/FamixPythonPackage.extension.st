Extension { #name : 'FamixPythonPackage' }

{ #category : '*Famix-Python-Importer' }
FamixPythonPackage >> createLocalVariable: aString [

	^ mooseModel newGlobalVariable
		  name: aString;
		  parentScope: self;
		  yourself
]
