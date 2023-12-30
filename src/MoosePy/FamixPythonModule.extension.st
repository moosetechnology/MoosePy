Extension { #name : #FamixPythonModule }

{ #category : #'*MoosePy' }
FamixPythonModule >> manualAddImport: aFamixImport [

	(self attributeAt: #manualImports ifAbsentPut: OrderedCollection new)
		add: aFamixImport
]

{ #category : #'*MoosePy' }
FamixPythonModule >> manualIncomingImports [

	^self attributeAt: #manualImports ifAbsent: OrderedCollection new
]
