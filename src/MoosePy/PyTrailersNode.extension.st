Extension { #name : #PyTrailersNode }

{ #category : #'*MoosePy' }
PyTrailersNode >> name [

	^ String streamContents: [ :s |
		  s << self atom name.
		  trailers do: [ :part |
			  s
				  << '.';
				  << part name ] ]
]
