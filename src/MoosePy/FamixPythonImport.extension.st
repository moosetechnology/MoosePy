Extension { #name : 'FamixPythonImport' }

{ #category : '*MoosePy' }
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

{ #category : '*MoosePy' }
FamixPythonImport >> manualImportingEntity [

	^self attributeAt: #manualImportingEntity ifAbsent: [ nil ]
]

{ #category : '*MoosePy' }
FamixPythonImport >> manualImportingEntity: anObject [

	self attributeAt: #manualImportingEntity put: anObject
]
