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

{ #category : '*Famix-Python-Importer' }
FamixPythonImport >> manualImportingEntity [

	^self attributeAt: #manualImportingEntity ifAbsent: [ nil ]
]

{ #category : '*Famix-Python-Importer' }
FamixPythonImport >> manualImportingEntity: anObject [

	self attributeAt: #manualImportingEntity put: anObject
]
