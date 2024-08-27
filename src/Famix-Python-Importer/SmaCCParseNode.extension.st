Extension { #name : 'SmaCCParseNode' }

{ #category : '*Famix-Python-Importer' }
SmaCCParseNode >> sourceFrom: startPosition to: stopPosition [

	^ self completeSource ifNotNil: [ :value | (value copyFrom: startPosition to: stopPosition) asString ]
]
