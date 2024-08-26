Extension { #name : 'FamixPythonImport' }

{ #category : '*Moose-Python-Importer' }
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

{ #category : '*Moose-Python-Importer' }
FamixPythonImport >> manualImportingEntity [

	^self attributeAt: #manualImportingEntity ifAbsent: [ nil ]
]

{ #category : '*Moose-Python-Importer' }
FamixPythonImport >> manualImportingEntity: anObject [

	self attributeAt: #manualImportingEntity put: anObject
]
