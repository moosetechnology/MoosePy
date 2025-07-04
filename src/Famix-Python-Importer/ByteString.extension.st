Extension { #name : 'ByteString' }

{ #category : '*Famix-Python-Importer' }
ByteString >> hasNoLineReturnBetween: start and: end [

	^ (self copyFrom: start to: end) noneSatisfy: [ :character | character = Character lf or: [ character = Character cr ] ]
]

{ #category : '*Famix-Python-Importer' }
ByteString >> hasOnlySpacesAndTabsBetween: start and: end [

	^ (self copyFrom: start to: end) allSatisfy: [ :character | character isSpaceSeparator or: [ character = Character tab ] ]
]
