Class {
	#name : #MSEPythonImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'pyDoc',
		'importer'
	],
	#category : #MoosePy
}

{ #category : #tests }
MSEPythonImporterTest >> importer [

	^ MSEPythonToFamixImporterVisitor new
]

{ #category : #accessing }
MSEPythonImporterTest >> parserClass [

	^ PythonParser
]

{ #category : #tests }
MSEPythonImporterTest >> setUp [

	pyDoc := self sourceBig2.
	importer := self importer.
	
]

{ #category : #tests }
MSEPythonImporterTest >> sourceBig2 [

	^ self parserClass parse: PythonParserTests new sourceBig2
]

{ #category : #tests }
MSEPythonImporterTest >> testClasses [
	
	importer accept: pyDoc.
	self assert: importer classes size equals: 3
]

{ #category : #tests }
MSEPythonImporterTest >> testClassesImportedTwiceAreOnlyImportedOnce [

	importer accept: pyDoc.
	self assert: importer classes size equals: 3.

	importer accept: pyDoc.

	self assert: importer classes size equals: 3
]

{ #category : #tests }
MSEPythonImporterTest >> testImportFamixClass [

	importer accept: pyDoc.

	self assert: importer classes size equals: 3
]

{ #category : #tests }
MSEPythonImporterTest >> testImportFunctions [


	importer accept: pyDoc.
	self assert: importer functions size equals: 5
]

{ #category : #tests }
MSEPythonImporterTest >> testParseClassFindsClasses [

	importer accept: pyDoc.
	self assert: importer classes size equals: 3
]
