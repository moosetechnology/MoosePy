Extension { #name : 'PyRootNode' }

{ #category : '*Famix-Python-Importer' }
PyRootNode >> fileReference [
	"Currently #filename return a FileReference and I find it weird so let's implement a method with a better name."

	^ self filename
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> sourceFrom: startPosition to: stopPosition [

	^ self completeSource ifNotNil: [ :value | (value copyFrom: startPosition to: stopPosition) asString ]
]
