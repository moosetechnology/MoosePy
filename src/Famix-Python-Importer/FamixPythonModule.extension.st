Extension { #name : 'FamixPythonModule' }

{ #category : '*Famix-Python-Importer' }
FamixPythonModule >> createVariable: aString [

	^ mooseModel newGlobalVariable
		  name: aString;
		  parentScope: self;
		  yourself
]
