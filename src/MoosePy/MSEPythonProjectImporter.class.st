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
	visitor := MSEPythonToFamixImporterVisitor new.
	visitor rootFilePath: aFileName.

	self importFileReference: aFileName asFileReference.

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
