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
	#category : #'MoosePy-Tests'
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

{ #category : #running }
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
	file := fileSystem workingDirectory / (self moduleName , '.py').
	file writeStreamDo: [ :stream |
		stream nextPutAll: PythonParserTests new sourceBig2 ].
	pyDoc := self sourceBig2.


	"load codeBig1"
	file2 := fileSystem workingDirectory / (self moduleName2 , '.py').
	file2 writeStreamDo: [ :stream |
		stream nextPutAll: PythonParserTests new codeBig1 ].
	pyDoc2 := self codeBig1.

	importer := self importer.

	importer model name: 'testPythonModelName'
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
	self assert: importer model name equals: 'testPythonModelName'
]

{ #category : #tests }
MSEPythonImporterTest >> testClasses [

	importer accept: pyDoc.
	self assert: importer classes size equals: 3.
	self assert: (importer classNamed: 'Ball') isNotNil.
	self assert: (importer classNamed: 'Player') isNotNil
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

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImport [

	importer accept: (self parseCode: '
import pygame
import random
').

	self assert: (importer importNamed: 'pygame') isNotNil.
	self assert: (importer importNamed: 'random') isNotNil
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportClassFromModule [

	importer accept: (self parseCode: '
from keras.layers import Input
').

	self assert: (importer importNamed: 'Input') isNotNil.
	self
		assert: (importer importNamed: 'Input') fromName
		equals: 'keras.layers'
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
	
	| ballClass wallClass | 
	importer accept: pyDoc.
	ballClass := importer classNamed: 'Ball'.
	self assert: ballClass class equals: FamixPythonClass.
	self assert: ballClass name equals: 'Ball'.
	self deny: ballClass isStub.
	
	wallClass := importer classNamed: 'Wall'.
	self assert: wallClass name equals: 'Wall'.
	self deny: wallClass isStub.
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixFunction [
	
	| func | 
	importer accept: pyDoc2.
	func := importer functionNamed: 'tryToPlaceWord'.
	self assert: func class equals: FamixPythonFunction.
	self assert: func signature equals: 'grid, word'

]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixFunctionKnowsItsModule [

	| func module |
	importer accept: pyDoc2.
	func := importer functionNamed: 'tryToPlaceWord'.
	module := importer moduleNamed: 'sprite_collect_blocks_2'.
	self assert: func functionOwner equals: module.
	self assert: func functionOwner class equals: FamixPythonModule
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixFunctionWithParameter [

	| param func |
	importer accept: pyDoc2.

	param := importer parameterNamed: 'word' inFunction: 'tryToPlaceWord'.
	func := param parentBehaviouralEntity.

	self assert: func class equals: FamixPythonFunction. 
	self assert: (func signature includesSubstring: 'word') equals: true.

	self assert: param isNotNil
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixMethod [

	| mth |
	importer accept: pyDoc.
	mth := importer methodNamed: '__init__' inClass: 'Player'.
	self assert: mth class equals: FamixPythonMethod.
	self assert: mth name equals: '__init__'.
	self assert: mth signature equals: 'self, x, y, joystick_no'
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixMethodKnowsItsClass [

	| mth cl |
	importer accept: pyDoc.
	mth := importer methodNamed: '__init__' inClass: 'Player'.
	cl := importer classNamed: 'Player'.
	self assert: mth parentType equals: cl.
	self assert: mth parentType class equals: FamixPythonClass
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixMethodWithParameter [

	| param  mth |
	importer accept: pyDoc.

	param := importer
		         parameterNamed: 'y'
		         inMethod: '__init__'
		         inClass: 'Player'.

	mth := param parentBehaviouralEntity.

	self assert: mth class equals: FamixPythonMethod.

	self assert: (mth signature includesSubstring: 'y') equals: true.

	self assert: param isNotNil
]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testImportFamixParameter [

	| param |
	importer accept: pyDoc.
	param := importer parameterNamed: 'joystick_no' inMethod: '__init__' inClass: 'Player'.
	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'joystick_no'.
	
	importer accept: pyDoc2.
	param := importer parameterNamed: 'word' inFunction: 'tryToPlaceWord'.
	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'word'.
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportFunction [

	importer accept: (self parseCode: '
import matplotlib.pyplot
').

	self assert: (importer importNamed: 'matplotlib.pyplot') isNotNil
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportFunctionFromModule [

	importer accept: (self parseCode: '
from random import randint
').

	self assert: (importer importNamed: 'randint') isNotNil.
	self
		assert: (importer importNamed: 'randint') fromName
		equals: 'random'
]

{ #category : #tests }
MSEPythonImporterTest >> testImportFunctions [

	importer accept: pyDoc2.
	self assert: importer functions size equals: 4.

	self assert: (importer functionNamed: 'tryToPlaceWord') isNotNil.
	self assert: (importer functionNamed: 'printGrid') isNotNil
]

{ #category : #tests }
MSEPythonImporterTest >> testImportMethods [

	importer accept: pyDoc.
	self assert: importer methods size equals: 5.
	self assert:
		(importer methodNamed: 'update' inClass: 'Ball') isNotNil.
	self assert:
		(importer methodNamed: '__init__' inClass: 'Wall') isNotNil.
	self assert:
		(importer methodNamed: '__init__' inClass: 'Player') isNotNil

]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportModuleWithAlias [

	importer accept: (self parseCode: '
import math as m
import matplotlib.pyplot as plt
').

	self assert: (importer importNamed: 'math') isNotNil.
	self
		assert: (importer importNamed: 'math') asName
		equals: 'm'.
		
	self assert: (importer importNamed: 'matplotlib.pyplot') isNotNil.
	self
		assert: (importer importNamed: 'matplotlib.pyplot') asName
		equals: 'plt'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportMultiClassesFromModule [

	importer accept: (self parseCode: '
from keras.layers import Flatten, Activation, AveragePooling2D, BatchNormalization
').

	self assert: (importer importNamed: 'Flatten') isNotNil.
	self assert: (importer importNamed: 'AveragePooling2D') isNotNil.
		self
		assert: (importer importNamed: 'Activation') fromName
		equals: 'keras.layers'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testImportMultiFunctionsFromModule [

	importer accept: (self parseCode: '
from maths import add, subtract
').

	self assert: (importer importNamed: 'add') isNotNil.
	self assert: (importer importNamed: 'subtract') isNotNil.
	self
		assert: (importer importNamed: 'add') fromName
		equals: 'maths'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocation [

	| invocations invocation |
	importer accept: (self parseCode: '
grid[row].append(".")
').


	invocations := importer model allWithType: FamixPythonInvocation.
	self assert: invocations size equals: 1.

	invocation := importer invocationCandidate: 'append'.
	self assert: invocation isNotNil.
	self assert: (importer invocationReceiver: 'grid[row]') isNotNil.
	self assert: invocation signature equals: '.'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationInLoop [

	importer accept: (self parseCode: '
append(".")
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationInNestedLoop [

	importer accept: (self parseCode: '
for row in array:
	test()
	for column in array:
		grid[row].append(".")
').
	self assert: importer invocations size equals: 2.
	self assert: importer invocations anyOne class equals: FamixPythonInvocation
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationWithArrayReceiver [

	importer accept: (self parseCode: '
for row in array:
	grid[row].append(".")
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationWithNumericalArguments [

	importer accept: (self parseCode: '
test(4, 25)
').
	self assert: importer invocations size equals: 1.
	self
		assert: importer invocations anyOne class
		equals: FamixPythonInvocation.

	self
		assert: importer invocations anyOne signature
		equals:  '4, 25'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationWithReceiver [

	importer accept: (self parseCode: '
grid.append(test)
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationWithStringReceiver [

	importer accept: (self parseCode: '
"CNN_Model_Rebuilt/logs/{}".format(NAME)
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'format') isNotNil
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testInvocationWithVariableArguments [

	| invocation |
	importer accept: (self parseCode: '
test(x, 25) 
').
	self assert: importer invocations size equals: 1.
	self
		assert: importer invocations anyOne class
		equals: FamixPythonInvocation.
	self assert: importer invocations anyOne signature equals: 'x, 25'.

	invocation := importer invocationCandidate: 'test'.

	self
		assert:
		((invocation cacheAt: 'args' ifAbsent: [ false ]) first at: 'value')
		equals: 'x'.
		
		self
		assert:
		((invocation cacheAt: 'args' ifAbsent: [ false ]) second at: 'value')
		equals: '25'
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testIsModel [
	
	importer accept: pyDoc.
	importer model entityNamed: 'pygame'.
	"Yes mom this is smoke test"
	
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testKnowsItsModule [
	
	| import module | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	module := importer moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module.

]

{ #category : #'tests - classes' }
MSEPythonImporterTest >> testMethodIsInModel [
	importer accept: pyDoc.
	self assert: importer model numberOfMethods equals: 5.
]

{ #category : #'tests - module' }
MSEPythonImporterTest >> testModule [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: self moduleName.
	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: self moduleName.

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
