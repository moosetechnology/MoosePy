Class {
	#name : 'FamixPythonWithClassesTestResource',
	#superclass : 'FamixPythonAbstractTestResource',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonWithClassesTestResource >> sourcesToParse [

	^  PythonParserTests new sourceBig2 
]
