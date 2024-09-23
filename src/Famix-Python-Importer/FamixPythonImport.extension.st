Extension { #name : 'FamixPythonImport' }

{ #category : '*Famix-Python-Importer' }
FamixPythonImport >> displayStringOn: aStream [

	aStream
		nextPutAll: 'a ' ;
		nextPutAll: self class name ;
		nextPutAll: '('.
	self source displayStringOn: aStream.
	aStream nextPutAll: ' -> '.
	self target displayStringOn: aStream.
	aStream nextPutAll: ')'
]
