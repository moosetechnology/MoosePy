"
An importer for Python projects

API:
```St
MSEPythonProjectImporter import: 'python/project/root/directory'
```

will return a `FamixPythonModel`
"
Class {
	#name : #MSEPythonProjectImporter,
	#superclass : #Object,
	#instVars : [
		'visitor'
	],
	#category : #'MoosePy-Importer'
}

{ #category : #api }
MSEPythonProjectImporter class >> import: aFileName [

	^self new
		import: aFileName
]

{ #category : #api }
MSEPythonProjectImporter >> import: aFileName [

	| fileReference |
	visitor := MSEPythonToFamixImporterVisitor new.
	visitor rootFilePath: aFileName.

	fileReference := aFileName asFileReference.
	visitor model name: fileReference basename.

	self importFileReference: fileReference.

	^visitor model
]

{ #category : #api }
MSEPythonProjectImporter >> importFileReference: aFileReference [

	aFileReference isDirectory 
		ifTrue: [
			aFileReference children do: [ :child | self importFileReference: child ].
			^self
		].

	(self isPythonExtension: aFileReference extension)
		ifFalse: [ ^self ].

	self importPythonFile: aFileReference.
]

{ #category : #api }
MSEPythonProjectImporter >> importPythonFile: aFileReference [

	'importing: ' trace.
	aFileReference fullName traceCr.

	(PythonParser parseFileWithErrors: aFileReference) acceptVisitor: visitor
]

{ #category : #testing }
MSEPythonProjectImporter >> isPythonExtension: aString [

	^aString = 'py'
]
