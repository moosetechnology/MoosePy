Extension { #name : 'FamixPythonModule' }

{ #category : '*Famix-Python-Importer' }
FamixPythonModule >> createLocalVariable: aString [ 
	
]

{ #category : '*Famix-Python-Importer' }
FamixPythonModule >> manualAddImport: aFamixImport [

	(self attributeAt: #manualImports ifAbsentPut: OrderedCollection new)
		add: aFamixImport
]

{ #category : '*Famix-Python-Importer' }
FamixPythonModule >> manualIncomingImports [

	^self attributeAt: #manualImports ifAbsent: OrderedCollection new
]
