Extension { #name : 'FamixPythonModule' }

{ #category : '*Moose-Python-Importer' }
FamixPythonModule >> createLocalVariable: aString [ 
	
]

{ #category : '*Moose-Python-Importer' }
FamixPythonModule >> manualAddImport: aFamixImport [

	(self attributeAt: #manualImports ifAbsentPut: OrderedCollection new)
		add: aFamixImport
]

{ #category : '*Moose-Python-Importer' }
FamixPythonModule >> manualIncomingImports [

	^self attributeAt: #manualImports ifAbsent: OrderedCollection new
]
