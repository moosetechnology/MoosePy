Class {
	#name : 'FamixPythonAbstractSnippetImporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonAbstractSnippetImporterTest >> import: aString [

	| file |
	file := FileSystem memory / 'file.py'.
	file writeStreamDo: [ :out | out nextPutAll: aString withPlatformLineEndings ].
	model := FamixPythonImporter import: file
]
