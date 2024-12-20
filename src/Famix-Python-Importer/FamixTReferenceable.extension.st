Extension { #name : 'FamixTReferenceable' }

{ #category : '*Famix-Python-Importer' }
FamixTReferenceable >> createAccessOrReferenceFrom: anEntity node: aNode [

	^ anEntity mooseModel newReference
		  referredEntity: self;
		  referencer: anEntity;
		  yourself
]
