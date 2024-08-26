Extension { #name : 'FamixPythonContainerEntity' }

{ #category : '*Moose-Python-Importer' }
FamixPythonContainerEntity >> dictLocalVariables [
	^self attributeAt: #dictLocalVariables ifAbsentPut: [ Dictionary new ] 
]
