Extension { #name : 'PyTrailersNode' }

{ #category : '*Famix-Python-Importer' }
PyTrailersNode >> name [

	^ String streamContents: [ :s |
		  s << self atom name.
		  trailers do: [ :part |
			  s
				  << '.';
				  << part name ] ]
]
