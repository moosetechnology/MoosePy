Extension { #name : 'PyFileNode' }

{ #category : '*Famix-Python-Importer' }
PyFileNode >> hasNoLineReturnBetween: start and: end [

	^ (self sourceFrom: start to: end) noneSatisfy: [ :character | character = Character lf or: [ character = Character cr ] ]
]

{ #category : '*Famix-Python-Importer' }
PyFileNode >> hasOnlySpacesAndTabsBetween: start and: end [

	^ (self sourceFrom: start to: end) allSatisfy: [ :character | character isSpaceSeparator or: [ character = Character tab ] ]
]

{ #category : '*Famix-Python-Importer' }
PyFileNode >> packageName [
	"If we have a __init__.py file, the package name should be the name of the parent folder"

	^ self fileReference parent basename
]
