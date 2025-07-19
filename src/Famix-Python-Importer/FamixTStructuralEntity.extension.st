Extension { #name : 'FamixTStructuralEntity' }

{ #category : '*Famix-Python-Importer' }
FamixTStructuralEntity >> createAccessOrReferenceFrom: anEntity node: aNode [

	^ (aNode visitor createAccessTo: self isWrite: aNode isLeftSideOfAssignation from: aNode)
		  accessor: anEntity;
		  yourself
]
