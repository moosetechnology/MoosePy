Extension { #name : 'FamixPythonImport' }

{ #category : '*Famix-Python-Importer' }
FamixPythonImport >> displayStringOn: aStream [

	aStream
		nextPutAll: 'a ' ;
		nextPutAll: self class name ;
		nextPutAll: '('.
	self fromName displayStringOn: aStream.
	aStream nextPutAll: ' -> '.
	self entityName displayStringOn: aStream.
	aStream nextPutAll: ')'
]
