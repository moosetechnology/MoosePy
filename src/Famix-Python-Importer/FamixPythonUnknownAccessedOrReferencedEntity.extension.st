Extension { #name : 'FamixPythonUnknownAccessedOrReferencedEntity' }

{ #category : '*Famix-Python-Importer' }
FamixPythonUnknownAccessedOrReferencedEntity >> createAccessOrReferenceFrom: anEntity node: aNode [

	^ anEntity mooseModel newUnknowAccessOrReference
		  unknownEntity: self;
		  accessorOrReferencer: anEntity;
		  yourself
]
