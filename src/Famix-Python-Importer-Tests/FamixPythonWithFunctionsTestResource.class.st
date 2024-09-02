Class {
	#name : 'FamixPythonWithFunctionsTestResource',
	#superclass : 'FamixPythonAbstractTestResource',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonWithFunctionsTestResource >> sourcesToParse [

	^ PythonParserTests new codeBig1
]
