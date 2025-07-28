Extension { #name : 'FamixPythonPackage' }

{ #category : '*Famix-Python-Importer' }
FamixPythonPackage >> createVariable: aString [

	^ mooseModel newGlobalVariable
		  name: aString;
		  parentScope: self;
		  yourself
]
