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
	self assert: importer classes size equals: 3.
	self assert: (importer classes keys includesAll:  #('Ball' 'Wall' 'Player'))
]

{ #category : #tests }
MSEPythonImporterTest >> testClassesImportedTwiceAreOnlyImportedOnce [

	importer accept: pyDoc.
	self assert: importer classes size equals: 3.

	importer accept: pyDoc.

	self assert: importer classes size equals: 3
]

{ #category : #'tests - famix classes' }
MSEPythonImporterTest >> testImportFamixClass [
	
	| firstClass | 
	importer accept: pyDoc.
	firstClass := importer classNamed: 'Ball'.
	self assert: firstClass class equals: FamixPythonClass.
	self assert: firstClass name equals: 'Ball'.
	self assert: firstClass isStub
]

{ #category : #tests }
MSEPythonImporterTest >> testImportFunctions [


	importer accept: pyDoc.
	self assert: importer functions size equals: 5
]
