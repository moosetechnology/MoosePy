Extension { #name : 'PyTrailersNode' }

{ #category : '*Moose-Python-Importer' }
PyTrailersNode >> name [

	^ String streamContents: [ :s |
		  s << self atom name.
		  trailers do: [ :part |
			  s
				  << '.';
				  << part name ] ]
]
