Class {
	#name : #MSEPythonImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'pyDoc',
		'importer',
		'fileSystem',
		'file',
		'pyDoc2',
		'file2'
	],
	#category : #MoosePy
}

{ #category : #accessing }
MSEPythonImporterTest >> codeBig1 [
	
	^ PythonParser parseFileWithErrors: (fileSystem / (self moduleName2 , '.py')) 
]

{ #category : #accessing }
MSEPythonImporterTest >> importer [

	^ MSEPythonToFamixImporterVisitor new
]

{ #category : #running }
MSEPythonImporterTest >> moduleName [
	^ 'sprite_collect_blocks'


]

{ #category : #running }
MSEPythonImporterTest >> moduleName2 [
	^ 'sprite_collect_blocks_2'


]

{ #category : #'tests - module' }
MSEPythonImporterTest >> parseCode: aString [
	
	^ (PythonParser parseWithErrors: aString)
		ifNotNil: [ :each | 
			(each isKindOf: SmaCCParseNode)
				ifTrue: [ each completeSource: aString.
					each filename: 'fileForTest.py' asFileReference  ].
			each ]

]

{ #category : #running }
MSEPythonImporterTest >> setUp [

	fileSystem := FileSystem memory.
	
	"load sourceBug2"
	file := fileSystem workingDirectory / (self moduleName, '.py').
	file writeStreamDo:  [ :stream | stream nextPutAll: PythonParserTests new sourceBig2 ].
	pyDoc := self sourceBig2.
	
	
	"load codeBig1"
	file2 := fileSystem workingDirectory / (self moduleName2, '.py').
	file2 writeStreamDo:  [ :stream | stream nextPutAll: PythonParserTests new codeBig1 ].
	pyDoc2 := self codeBig1.

	importer := self importer.
	"file writeStreamDo:  [ :stream | stream nextPutAll: PythonParserTests new sourceBig2 ].
	pyDoc := self sourceBig2.
	importer := self importer."

	
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
	self assert: (fileSystem / (self moduleName, '.py')) contents size equals: 7586.
	self assert: (fileSystem / (self moduleName2, '.py')) contents size equals: 3259
	
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportClassKnowsItsMethods [
	
	| cl | 
	importer accept: pyDoc.
	cl := importer classNamed: 'Player'.
	self assert: cl methods first name equals: '__init__'.
	self assert: cl methods first signature equals: 'self, x, y, joystick_no'.
	
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixClass [
	
	| firstClass secondClass | 
	importer accept: pyDoc.
	firstClass := importer classNamed: 'Ball'.
	self assert: firstClass class equals: FamixPythonClass.
	self assert: firstClass name equals: 'Ball'.
	self assert: firstClass isStub.
	
	secondClass := importer classNamed: 'Wall'.
	self assert: secondClass name equals: 'Wall'.
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixFunction [
	
	| func | 
	importer accept: pyDoc2.
	func := importer functionNamed: 'sprite_collect_blocks_2.tryToPlaceWord'.
	self assert: func class equals: FamixPythonFunction.
	self assert: func name equals: 'tryToPlaceWord'.
	self assert: func signature equals: 'grid, word'

]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixFunctionKnowsItsModule [

	| func module |
	importer accept: pyDoc2.
	func := importer functionNamed: 'sprite_collect_blocks_2.tryToPlaceWord'.
	module := importer moduleNamed: 'sprite_collect_blocks_2'.
	self assert: func functionOwner equals: module.
	self assert: func functionOwner class equals: FamixPythonModule
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
	self assert: mth parentType class equals: FamixPythonClass
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixParameter [

	| param |
	importer accept: pyDoc.
	param := importer parameterNamed: 'Player.__init__.joystick_no'.
	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'joystick_no'.
	
	importer accept: pyDoc2.
	param := importer parameterNamed: 'sprite_collect_blocks_2.tryToPlaceWord.word'.
	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'word'.
]

{ #category : #tests }
MSEPythonImporterTest >> testImportFunctions [

	importer accept: pyDoc2.
	self assert: importer functions size equals: 4.
	self assert: importer functions keys equals: #('sprite_collect_blocks_2.tryToPlaceWord' 'sprite_collect_blocks_2.placeWord'
'sprite_collect_blocks_2.printGrid' 'sprite_collect_blocks_2.createGrid')
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
MSEPythonImporterTest >> testImportInvocation [

	importer accept: (self parseCode: '
grid[row].append(".")
').
	self assert: importer invocations size equals: 1.
	self assert: importer invocations anyOne class equals: PyPowerNode 
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportInvocationInLoop [

	importer accept: (self parseCode: '
for row in array:
	grid[row].append(".")
').
	self assert: importer invocations size equals: 1.
	self assert: importer invocations anyOne class equals: PyPowerNode
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportInvocationInNestedLoop [

	importer accept: (self parseCode: '
for row in array:
	test()
	for column in array:
		grid[row].append(".")
').
	self assert: importer invocations size equals: 2.
	self assert: importer invocations anyOne class equals: PyPowerNode
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

{ #category : #tests }
MSEPythonImporterTest >> testImportMethods [

	importer accept: pyDoc.
	self assert: importer methods size equals: 5.
	self assert: importer methods keys equals: #('Wall.__init__' 'Ball.update' 'Player.update' 'Player.__init__' 'Ball.__init__')
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
