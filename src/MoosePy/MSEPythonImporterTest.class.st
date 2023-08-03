Class {
	#name : #MSEPythonImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'pyDoc',
		'importer'
	],
	#category : #MoosePy
}

{ #category : #'tests - module' }
MSEPythonImporterTest >> atestModuleKnowsItsImport [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: 'Main Module'.
	self assert: module manualIncomingImports size equals: 2.
	"does not work probably because of the bidirectional slots 
		self assert: module incomingImports size equals: 2."

]

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

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testClassIsInModel [
	
	importer accept: pyDoc.
	self assert: importer model numberOfClasses equals: 3.
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

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportClassKnowsItsMethods [
	
	| cl | 
	importer accept: pyDoc.
	cl := importer classNamed: 'Player'.
	self assert: cl methods first name equals: '__init__'.
	self assert: cl methods first signature equals: 'self, x, y, joystick_no'.
	self assert: cl methods second name equals: 'update'.
	
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixClass [
	
	| firstClass | 
	importer accept: pyDoc.
	firstClass := importer classNamed: 'Ball'.
	self assert: firstClass class equals: FamixPythonClass.
	self assert: firstClass name equals: 'Ball'.
	self assert: firstClass isStub
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixMethod [
	
	| mth | 
	importer accept: pyDoc.
	mth := importer methodNamed: 'Player.__init__'.
	self assert: mth class equals: FamixPythonMethod.
	self assert: mth name equals: '__init__'.
	self assert: mth signature equals: 'self, x, y, joystick_no'

]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixMethodKnowsItsClass [
	
	| mth cl | 
	importer accept: pyDoc.
	mth := importer methodNamed: 'Player.__init__'.
	cl := importer classNamed: 'Player'.
	self assert: mth parentType equals: cl.
	
]

{ #category : #tests }
MSEPythonImporterTest >> testImportFunctions [

	importer accept: pyDoc.
	self assert: importer methods size equals: 5.
	self assert: importer methods keys equals: #('Wall.__init__' 'Ball.update' 'Player.update' 'Player.__init__' 'Ball.__init__')
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportImport [
	
	| import | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	self assert: import class equals: FamixPythonImport.
	self assert: import entityName equals: 'pygame'.

]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportIsModel [
	
	importer accept: pyDoc.
	importer model entityNamed: 'pygame'.
	"Yes mom this is smoke test"
	
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportKnowsItsModule [
	
	| import module | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	module := importer moduleNamed: 'Main Module'.
	self assert: import manualImportingEntity equals: module.

]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportModule [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: 'Main Module'.
	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: 'Main Module'.

]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testMethodIsInModel [
	importer accept: pyDoc.
	self assert: importer model numberOfMethods equals: 5.
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testModuleIsModel [
	
	importer accept: pyDoc.
	importer model entityNamed: 'Main Module'.
	
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testModuleKnowsItsImport [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: 'Main Module'.
	self assert: module manualIncomingImports size equals: 2.
	"does not work probably because of the bidirectional slots 
		self assert: module incomingImports size equals: 2."

]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testTwoSiblingImportsHaveTheSameModule [
	
	| import module import2 | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	import2 := importer importNamed: 'random'.
	module := importer moduleNamed: 'Main Module'.
	self assert: import manualImportingEntity equals: module.
	self assert: import2 manualImportingEntity equals: module.
	self assert: import manualImportingEntity == import2 manualImportingEntity  

]
