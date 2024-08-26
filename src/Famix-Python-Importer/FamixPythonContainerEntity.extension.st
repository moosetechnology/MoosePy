Extension { #name : 'FamixPythonContainerEntity' }

{ #category : '*Famix-Python-Importer' }
FamixPythonContainerEntity >> dictLocalVariables [
	^self attributeAt: #dictLocalVariables ifAbsentPut: [ Dictionary new ] 
]
