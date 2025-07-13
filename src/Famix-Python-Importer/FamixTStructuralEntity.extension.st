Extension { #name : 'FamixTStructuralEntity' }

{ #category : '*Famix-Python-Importer' }
FamixTStructuralEntity >> createAccessOrReferenceFrom: anEntity node: aNode [

	^ anEntity mooseModel newAccess
		  variable: self;
		  accessor: anEntity;
		  isWrite: aNode isLeftSideOfAssignation;
		  yourself
]
