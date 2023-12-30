Extension { #name : #FamixPythonImport }

{ #category : #'*MoosePy' }
FamixPythonImport >> manualImportingEntity [

	^self attributeAt: #manualImportingEntity ifAbsent: [ nil ]
]

{ #category : #'*MoosePy' }
FamixPythonImport >> manualImportingEntity: anObject [

	self attributeAt: #manualImportingEntity put: anObject
]
