Extension { #name : 'PyRootNode' }

{ #category : '*Famix-Python-Importer' }
PyRootNode >> assignationNode [
	"If I am in an assignation node, I'll return this node. Else I'll return nil."

	^ self parent ifNotNil: [ :node |
		  node isAssignation
			  ifTrue: [ node ]
			  ifFalse: [ node assignationNode ] ]
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> fileReference [
	"Currently #filename return a FileReference and I find it weird so let's implement a method with a better name."

	^ self filename
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> isAssignation [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> isFunctionCallExpression [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> isImport [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> isLeftSideOfAssignation: aNode [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> isSubscriptExpression [

	^ false
]

{ #category : '*Famix-Python-Importer' }
PyRootNode >> sourceFrom: startPosition to: stopPosition [

	^ self completeSource ifNotNil: [ :value | (value copyFrom: startPosition to: stopPosition) asString ]
]
