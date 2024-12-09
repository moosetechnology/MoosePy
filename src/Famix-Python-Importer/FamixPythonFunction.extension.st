Extension { #name : 'FamixPythonFunction' }

{ #category : '*Famix-Python-Importer' }
FamixPythonFunction >> createAccessOrReferenceFrom: anEntity node: aNode [
1halt.
	self flag: #todo.
	^ nil
]

{ #category : '*Famix-Python-Importer' }
FamixPythonFunction >> createLocalVariable: aString [

	^ mooseModel newLocalVariable
		  name: aString;
		  parentBehaviouralEntity: self;
		  yourself
]
