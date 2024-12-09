Extension { #name : 'FamixPythonFunction' }

{ #category : '*Famix-Python-Importer' }
FamixPythonFunction >> createAccessOrReferenceFrom: anEntity node: aNode [

	^ anEntity mooseModel newFunctionReference
		  referredFunction: self;
		  referencer: anEntity;
		  yourself
]

{ #category : '*Famix-Python-Importer' }
FamixPythonFunction >> createLocalVariable: aString [

	^ mooseModel newLocalVariable
		  name: aString;
		  parentBehaviouralEntity: self;
		  yourself
]
