Extension { #name : 'FamixTStructuralEntity' }

{ #category : '*Famix-Python-Importer' }
FamixTStructuralEntity >> createAccessOrReferenceFrom: anEntity node: aNode [
	self flag: #todo.
	^ anEntity mooseModel newAccess
		  variable: self;
		  accessor: anEntity;
		 " isWrite: (aNode isLeftSideOfAssignation);"
		  yourself
]
