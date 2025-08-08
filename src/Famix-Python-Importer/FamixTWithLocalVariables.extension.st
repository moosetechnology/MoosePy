Extension { #name : 'FamixTWithLocalVariables' }

{ #category : '*Famix-Python-Importer' }
FamixTWithLocalVariables >> createVariable: aString [

	^ (self mooseModel newLocalVariableNamed: aString)
		  parentBehaviouralEntity: self;
		  yourself
]
