Extension { #name : 'FamixPythonIndexedFileAnchor' }

{ #category : '*Famix-Python-Importer' }
FamixPythonIndexedFileAnchor >> includesInterval: anInterval [

	anInterval first >= self startPos ifFalse: [ ^ false ].

	^ anInterval last <= self endPos
]

{ #category : '*Famix-Python-Importer' }
FamixPythonIndexedFileAnchor >> numberOfCharacters [

	^ self endPos - self startPos
]
