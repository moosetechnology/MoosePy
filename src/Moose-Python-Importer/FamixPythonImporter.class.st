"
An importer for Python projects

API:
```St
MSEPythonProjectImporter import: 'python/project/root/directory'
```

will return a `FamixPythonModel`
"
Class {
	#name : 'FamixPythonImporter',
	#superclass : 'Object',
	#instVars : [
		'visitor'
	],
	#category : 'Moose-Python-Importer-Importer',
	#package : 'Moose-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'api' }
FamixPythonImporter class >> import: aFileName [

	^self new
		import: aFileName
]

{ #category : 'api' }
FamixPythonImporter >> import: aFileName [

	| fileReference |
	visitor := FamixPythonImporterVisitor new.
	visitor rootFilePath: aFileName.

	fileReference := aFileName asFileReference.
	visitor model name: fileReference basename.

	self importFileReference: fileReference.

	^visitor model
]

{ #category : 'api' }
FamixPythonImporter >> importFileReference: aFileReference [

	aFileReference isDirectory 
		ifTrue: [
			aFileReference children do: [ :child | self importFileReference: child ].
			^self
		].

	(self isPythonExtension: aFileReference extension)
		ifFalse: [ ^self ].

	self importPythonFile: aFileReference.
]

{ #category : 'api' }
FamixPythonImporter >> importPythonFile: aFileReference [

	'importing: ' trace.
	aFileReference fullName traceCr.

	(PythonParser parseFileWithErrors: aFileReference) acceptVisitor: visitor
]

{ #category : 'testing' }
FamixPythonImporter >> isPythonExtension: aString [

	^aString = 'py'
]
