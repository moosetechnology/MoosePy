Class {
	#name : #MSEPythonImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'pyDoc',
		'importer'
	],
	#category : #MoosePy
}

{ #category : #accessing }
MSEPythonImporterTest >> importer [

	^ MSEPythonToFamixImporterVisitor new
]

{ #category : #accessing }
MSEPythonImporterTest >> parserClass [

	^ PythonParser
]

{ #category : #running }
MSEPythonImporterTest >> setUp [

	pyDoc := self sourceBig2.
	importer := self importer.
	
]

{ #category : #accessing }
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

{ #category : #'tests - famix classes' }
MSEPythonImporterTest >> testImportFamixMethod [
	
	| mth | 
	importer accept: pyDoc.
	mth := importer methodNamed: 'Player.__init__'.
	self assert: mth class equals: FamixPythonMethod.
	self assert: mth name equals: '__init__'.

]

{ #category : #tests }
MSEPythonImporterTest >> testImportFunctions [

	importer accept: pyDoc.
	self assert: importer functions size equals: 5.
	self assert: importer functions keys equals: #('Wall.__init__' 'Ball.update' 'Player.update' 'Player.__init__' 'Ball.__init__')
]
