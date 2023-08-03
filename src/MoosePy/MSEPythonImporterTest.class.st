Class {
	#name : #MSEPythonImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'pyDoc',
		'importer',
		'fileSystem',
		'file'
	],
	#category : #MoosePy
}

{ #category : #accessing }
MSEPythonImporterTest >> importer [

	^ MSEPythonToFamixImporterVisitor new
]

{ #category : #running }
MSEPythonImporterTest >> moduleName [
	^ 'sprite_collect_blocks'


]

{ #category : #running }
MSEPythonImporterTest >> setUp [

	fileSystem := FileSystem memory.
	file := fileSystem workingDirectory / (self moduleName, '.py').
	file writeStreamDo:  [ :stream | stream nextPutAll: PythonParserTests new sourceBig2 ].
	pyDoc := self sourceBig2.
	importer := self importer.

	
	file writeStreamDo:  [ :stream | stream nextPutAll: PythonParserTests new sourceBig2 ].
	pyDoc := self sourceBig2.
	importer := self importer.

	
]

{ #category : #accessing }
MSEPythonImporterTest >> sourceBig2 [
	
	^ PythonParser parseFileWithErrors: (fileSystem / (self moduleName, '.py')) 
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

{ #category : #'tests - files' }
MSEPythonImporterTest >> testFileIsOk [
	self assert: (fileSystem / (self moduleName, '.py')) contents size equals: 7586
	
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
	module := importer moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module.

]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportModule [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: self moduleName.
	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: self moduleName.

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
	module := importer moduleNamed: self moduleName.
	self assert: module manualIncomingImports size equals: 2.
	"does not work probably because of the bidirectional slots 
		self assert: module incomingImports size equals: 2."

]

{ #category : #'tests - files' }
MSEPythonImporterTest >> testParseWithFile [


	| doc |
	doc := PythonParser parseFileWithErrors: (fileSystem / 'sprite_collect_blocks.py').
	self assert: doc filename basename equals: 'sprite_collect_blocks.py'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testTwoSiblingImportsHaveTheSameModule [
	
	| import module import2 | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	import2 := importer importNamed: 'random'.
	module := importer moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module.
	self assert: import2 manualImportingEntity equals: module.
	self assert: import manualImportingEntity == import2 manualImportingEntity  

]
