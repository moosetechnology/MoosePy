Class {
	#name : 'FamixPythonImporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'pyDoc',
		'importer',
		'fileSystem',
		'file',
		'pyDoc2',
		'file2'
	],
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonImporterTest >> codeBig1 [
	
	^ PythonParser parseFileWithErrors: (fileSystem / (self moduleName2 , '.py')) 
]

{ #category : 'accessing' }
FamixPythonImporterTest >> importer [

	^ FamixPythonImporterVisitor new
]

{ #category : 'running' }
FamixPythonImporterTest >> moduleName [
	^ 'sprite_collect_blocks'


]

{ #category : 'running' }
FamixPythonImporterTest >> moduleName2 [
	^ 'sprite_collect_blocks_2'


]

{ #category : 'running' }
FamixPythonImporterTest >> parseCode: aString [
	
	^ (PythonParser parseWithErrors: aString)
		ifNotNil: [ :each | 
			(each isKindOf: SmaCCParseNode)
				ifTrue: [ each completeSource: aString.
					each filename: 'fileForTest.py' asFileReference  ].
			each ]

]

{ #category : 'running' }
FamixPythonImporterTest >> setUp [

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

{ #category : 'accessing' }
FamixPythonImporterTest >> sourceBig2 [
	
	^ PythonParser parseFileWithErrors: (fileSystem / (self moduleName, '.py')) 
]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testAddEqualIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
x += 12
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests' }
FamixPythonImporterTest >> testAnnotatedClass [

	| class anno |
	importer accept: (self parseCode: '
@dataclass
class ValueRange:
    lo: int
    hi: int
').

	class := importer classNamed: 'ValueRange'.

	self assert: class isNotNil.
	self assert: class annotationInstances size equals: 1.

	anno := class annotationInstances anyOne.
	self assert: anno annotatedEntity equals: class.
	self assert: anno annotationType name equals: 'dataclass'
]

{ #category : 'tests' }
FamixPythonImporterTest >> testAnnotatedFunction [

	| fct anno |
	importer accept: (self parseCode: '
@classmethod
def greet(name):
    print ''Hello'', name
').

	fct := importer functionNamed: 'greet'.

	self assert: fct isNotNil.
	self assert: fct annotationInstances size equals: 1.

	anno := fct annotationInstances anyOne.
	self assert: anno annotatedEntity equals: fct.
	self assert: anno annotationType name equals: 'classmethod'
]

{ #category : 'tests - attributes' }
FamixPythonImporterTest >> testAttribute [

	| class |
	importer accept: pyDoc.
	class := importer classNamed: 'Player'.
	self assert: class attributes size equals: 3.
	class attributes do: [ :attributes | self assert: (#( width height my_joystick ) anySatisfy: [ :name | name = attributes name ]) ]
]

{ #category : 'tests - classes' }
FamixPythonImporterTest >> testClass [
	
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

{ #category : 'tests - attributes' }
FamixPythonImporterTest >> testClassAttributes [

	| classA classB |
	importer accept: (self parseCode: '
class A:
	a = 1
	b = 2
class B:
	a = 2
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 3.

	classA := importer classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA attributes size equals: 2.
	self assert: classA attributes first name equals: 'a'.
	self assert: classA attributes second name equals: 'b'.

	classB := importer classNamed: 'B'.
	self assert: classB isNotNil.
	self assert: classB attributes size equals: 1.
	self assert: classB attributes first name equals: 'a'
]

{ #category : 'tests - classes' }
FamixPythonImporterTest >> testClassIsInModel [

	importer accept: pyDoc.
	self assert: importer model numberOfClasses equals: 4.
	self assert: importer model name equals: 'testPythonModelName'
]

{ #category : 'tests - classes' }
FamixPythonImporterTest >> testClassKnowsItsMethods [
	
	| cl | 
	importer accept: pyDoc.
	cl := importer classNamed: 'Player'.
	self assert: cl methods first name equals: '__init__'.
	self assert: cl methods first signature equals: 'self, x, y, joystick_no'.
	
]

{ #category : 'tests - classes' }
FamixPythonImporterTest >> testClasses [

	importer accept: pyDoc.
	self assert: importer classes size equals: 4.
	self assert: (importer classNamed: 'Ball') isNotNil.
	self assert: (importer classNamed: 'Player') isNotNil
]

{ #category : 'tests - classes' }
FamixPythonImporterTest >> testClassesImportedTwiceAreOnlyImportedOnce [

	importer accept: pyDoc.
	self assert: importer classes size equals: 4.

	importer accept: pyDoc.

	self assert: importer classes size equals: 4
]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testComentIsNotAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
"""This is a comment"""
'.

	self deny: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests - decorators' }
FamixPythonImporterTest >> testDecoratorsFunctionSingleDecorator [
	"https://realpython.com/primer-on-python-decorators/"

	| famix |
	importer accept: (self parseCode: '
@decorator
def say_whee():
    print("Whee!")
').

	famix := (importer model allWithType: FamixPythonFunction) first.
	self assert: famix isNotNil.
	famix := famix annotationInstances.
	self assert: famix size equals: 1.
	famix := famix first.
	self assert: famix annotatedEntity name equals: 'say_whee'.
]

{ #category : 'tests - decorators' }
FamixPythonImporterTest >> testDecoratorsMethodSingleDecorator [

	| famix |
	importer accept: (self parseCode: '
class A:
	@classmethod
	def foo:
		pass
').

	famix := importer classNamed: 'A'.
	self assert: famix isNotNil.
	famix := (famix methods first).
	self assert: famix name equals: 'foo'.
	famix := famix annotationInstances.
	self assert: famix size equals: 1.
	famix := famix first.
	self assert: famix annotatedEntity name equals: 'foo'.
]

{ #category : 'tests - decorators' }
FamixPythonImporterTest >> testDecoratorsSanityCheck [

	importer accept: (self parseCode: '
class A:
	@classmethod
	def foo:
		pass
').

	self
		assert: (importer model allWithType: FamixPythonMethod) size
		equals: 1
]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testDottedNamedAssignmentIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
x.a = 12
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testEqualEqualIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
a = b =3
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests - files' }
FamixPythonImporterTest >> testFileIsOk [
	self assert: (fileSystem / (self moduleName, '.py')) contents size equals: 7586.
	self assert: (fileSystem / (self moduleName2, '.py')) contents size equals: 3259
	
]

{ #category : 'tests - functions' }
FamixPythonImporterTest >> testFunction [
	
	| func | 
	importer accept: pyDoc2.
	func := importer functionNamed: 'tryToPlaceWord'.
	self assert: func class equals: FamixPythonFunction.
	self assert: func signature equals: 'grid,word'

]

{ #category : 'tests - functions' }
FamixPythonImporterTest >> testFunctionKnowsItsModule [

	| func module |
	importer accept: pyDoc2.
	func := importer functionNamed: 'tryToPlaceWord'.
	module := importer moduleNamed: 'sprite_collect_blocks_2'.
	self assert: func functionOwner equals: module.
	self assert: func functionOwner class equals: FamixPythonModule
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testFunctionNoLambda [

	| famix |
	importer accept: (self parseCode: '
def identity:
    print("identify")
').

	self assert: (importer model allWithType: FamixPythonFunction) size equals: 1.
	
	famix := importer functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assert: famix functions size equals: 0.
	
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testFunctionSingleLambda [

	| famix |
	importer accept: (self parseCode: '
def identity:
    lambda x : x
').

	self assert: (importer model allWithType: FamixPythonFunction) size equals: 2.
	
	famix := importer functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assert: famix functions size equals: 1.

	famix := famix functions anyOne.
	self assert: famix name equals: ''.
	self assert: famix functionOwner name equals: 'identity'.
	
]

{ #category : 'tests - functions' }
FamixPythonImporterTest >> testFunctionWithParameter [

	| param func |
	importer accept: pyDoc2.

	param := importer
		parameterNamed: 'word'
		inBehavioural: (importer functionNamed: 'tryToPlaceWord').
	func := param parentBehaviouralEntity.

	self assert: func class equals: FamixPythonFunction. 
	self assert: (func signature includesSubstring: 'word') equals: true.

	self assert: param isNotNil
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImport [

	importer accept: (self parseCode: '
import pygame
import random
').

	self assert: (importer importNamed: 'pygame') isNotNil.
	self assert: (importer importNamed: 'random') isNotNil
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportClassFromModule [

	importer accept: (self parseCode: '
from keras.layers import Input
').

	self assert: (importer importNamed: 'Input') isNotNil.
	self
		assert: (importer importNamed: 'Input') fromName
		equals: 'keras.layers'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportFunction [

	importer accept: (self parseCode: '
import matplotlib.pyplot
').

	self assert: (importer importNamed: 'matplotlib.pyplot') isNotNil
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportFunctionFromModule [

	importer accept: (self parseCode: '
from random import randint
').

	self assert: (importer importNamed: 'randint') isNotNil.
	self
		assert: (importer importNamed: 'randint') fromName
		equals: 'random'
]

{ #category : 'tests' }
FamixPythonImporterTest >> testImportFunctions [

	importer accept: pyDoc2.
	self assert: importer functions size equals: 4.

	self assert: (importer functionNamed: 'tryToPlaceWord') isNotNil.
	self assert: (importer functionNamed: 'printGrid') isNotNil
]

{ #category : 'tests' }
FamixPythonImporterTest >> testImportMethods [

	importer accept: pyDoc.
	self assert: importer methods size equals: 5.
	self assert:
		(importer methodNamed: 'update' inClassNamed: 'Ball') isNotNil.
	self assert:
		(importer methodNamed: '__init__' inClassNamed: 'Wall') isNotNil.
	self assert:
		(importer methodNamed: '__init__' inClassNamed: 'Player') isNotNil

]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportModuleWithAlias [

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

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportModulesWithAliases [

	importer accept: (self parseCode: '
import math as m, matplotlib.pyplot as plt
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

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportMultiClassesFromModule [

	importer accept: (self parseCode: '
from keras.layers import Flatten, Activation, AveragePooling2D, BatchNormalization
').

	self assert: (importer importNamed: 'Flatten') isNotNil.
	self assert: (importer importNamed: 'AveragePooling2D') isNotNil.
		self
		assert: (importer importNamed: 'Activation') fromName
		equals: 'keras.layers'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportMultiFunctionsFromModule [

	importer accept: (self parseCode: '
from maths import add, subtract
').

	self assert: (importer importNamed: 'add') isNotNil.
	self assert: (importer importNamed: 'subtract') isNotNil.
	self
		assert: (importer importNamed: 'add') fromName
		equals: 'maths'
]

{ #category : 'tests - attributes' }
FamixPythonImporterTest >> testInstanceAttributes [

	| classA classB localVariableA localVariableB |
	importer accept: (self parseCode: '
class A:
	def foo(self):
		a = 1
		b = 2
class B:
	a = 2
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 3.

	classA := importer classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA attributes size equals: 0.
	self assert: classA methods first localVariables size equals: 2.

	localVariableA := classA methods first localVariables first.
	self assert: localVariableA isNotNil.
	self assert: localVariableA name equals: 'a'.

	localVariableB := classA methods first localVariables second.
	self assert: localVariableB isNotNil.
	self assert: localVariableB name equals: 'b'.

	classB := importer classNamed: 'B'.
	self assert: classB isNotNil.
	self assert: classB attributes size equals: 1.
	self assert: classB attributes first name equals: 'a'
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocation [

	| invocations invocation |

	self skip: 'Invocations not treated in importer'.

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

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationInLoop [

	self skip: 'Invocations not treated in importer'.

	importer accept: (self parseCode: '
append(".")
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationInNestedLoop [

	self skip: 'Invocations not treated in importer'.

	importer accept: (self parseCode: '
for row in array:
	test()
	for column in array:
		grid[row].append(".")
').
	self assert: importer invocations size equals: 2.
	self assert: importer invocations anyOne class equals: FamixPythonInvocation
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithArrayReceiver [

	self skip: 'Invocations not treated in importer'.

	importer accept: (self parseCode: '
for row in array:
	grid[row].append(".")
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithNumericalArguments [

	self skip: 'Invocations not treated in importer'.

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

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithReceiver [

	self skip: 'Invocations not treated in importer'.

	importer accept: (self parseCode: '
grid.append(test)
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithStringReceiver [

	self skip: 'Invocations not treated in importer'.

	importer accept: (self parseCode: '
"CNN_Model_Rebuilt/logs/{}".format(NAME)
').
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'format') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithVariableArguments [

	| invocation |

	self skip: 'Invocations not treated in importer'.

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

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
x = 12
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests' }
FamixPythonImporterTest >> testIsModel [
	
	importer accept: pyDoc.
	importer model entityNamed: 'pygame'.
	"Yes mom this is smoke test"
	
]

{ #category : 'tests - module' }
FamixPythonImporterTest >> testKnowsItsModule [
	
	| import module | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	module := importer moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module.

]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testListEqualIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
a,b = 1,3
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests - methods' }
FamixPythonImporterTest >> testMethod [

	| mth |
	importer accept: pyDoc.
	mth := importer methodNamed: '__init__' inClassNamed: 'Player'.
	self assert: mth class equals: FamixPythonMethod.
	self assert: mth name equals: '__init__'.
	self assert: mth signature equals: 'self, x, y, joystick_no'
]

{ #category : 'tests - methods' }
FamixPythonImporterTest >> testMethodIsInModel [
	importer accept: pyDoc.
	self assert: importer model numberOfMethods equals: 5.
]

{ #category : 'tests - methods' }
FamixPythonImporterTest >> testMethodKnowsItsClass [

	| mth cl |
	importer accept: pyDoc.
	mth := importer methodNamed: '__init__' inClassNamed: 'Player'.
	cl := importer classNamed: 'Player'.
	self assert: mth parentType equals: cl.
	self assert: mth parentType class equals: FamixPythonClass
]

{ #category : 'tests - methods' }
FamixPythonImporterTest >> testMethodWithParameter [

	| param  mth |
	importer accept: pyDoc.

	param := importer
		parameterNamed: 'y'
		inBehavioural: (importer methodNamed: '__init__' inClassNamed: 'Player').

	mth := param parentBehaviouralEntity.

	self assert: mth class equals: FamixPythonMethod.

	self assert: (mth signature includesSubstring: 'y') equals: true.

	self assert: param isNotNil
]

{ #category : 'tests - module' }
FamixPythonImporterTest >> testModule [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: self moduleName.

	self assert: module isNotNil.
	self assert: module class equals: FamixPythonModule.
	self assert: module name equals: self moduleName.

]

{ #category : 'tests - module' }
FamixPythonImporterTest >> testModuleKnowsItsImport [
	
	| module | 
	importer accept: pyDoc.
	module := importer moduleNamed: self moduleName.
	self assert: module manualIncomingImports size equals: 2.
	"does not work probably because of the bidirectional slots 
		self assert: module incomingImports size equals: 2."

]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testModuloEqualIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
x //= 12
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testMultiFunctionsMultiLambdas [

	| famix |
	importer accept: (self parseCode: '
def identity:
    lambda x : x
def identity2:
    lambda x : x
    lambda x : x
').

	self assert: (importer model allWithType: FamixPythonFunction) size equals: 5.
	
	famix := importer functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assert: famix functions size equals: 1.

	famix := famix functions anyOne.
	self assert: famix name equals: ''.
	self assert: famix functionOwner name equals: 'identity'.
	
]

{ #category : 'tests - classes' }
FamixPythonImporterTest >> testParameter [

	| param |
	importer accept: pyDoc.
	param := importer
		parameterNamed: 'joystick_no'
		inBehavioural: (importer methodNamed: '__init__' inClassNamed: 'Player').

	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'joystick_no'.
	
	importer accept: pyDoc2.
	param := importer
		parameterNamed: 'word'
		inBehavioural: (importer functionNamed: 'tryToPlaceWord').
	self assert: param class equals: FamixPythonParameter.
	self assert: param name equals: 'word'.
]

{ #category : 'tests - files' }
FamixPythonImporterTest >> testParseWithFile [


	| doc |
	doc := PythonParser parseFileWithErrors: (fileSystem / 'sprite_collect_blocks.py').
	self assert: doc filename basename equals: 'sprite_collect_blocks.py'
]

{ #category : 'tests' }
FamixPythonImporterTest >> testSameAnnotationType [

	importer accept: (self parseCode: '
@classmethod
def greet(name):
    print ''Hello'', name
@classmethod
def goodbye(name):
    print ''Bye-bye'', name
').

	self assert: (importer model allWithType: FamixPythonAnnotationType) size equals: 1.
	self
		assert: (importer functionNamed: 'greet')   annotationInstances anyOne annotationType
		equals: (importer functionNamed: 'goodbye') annotationInstances anyOne annotationType
]

{ #category : 'tests - extensions' }
FamixPythonImporterTest >> testShiftEqualIsAssignment [

	| smaccAST |
	smaccAST := self parseCode: '
x >>= 12
'.

	self assert: smaccAST statements anyOne stmts anyOne isAssignment
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClasSingleFQNMetaclass [

	| classA classMeta classAMeta |
	importer accept: (self parseCode: '
class Meta(type):
	pass
class A(metaclass=pygame.sprite.Sprite):
	def foo:
		pass
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 5.

	classA := importer classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: (classA superInheritances first target name) equals: 'object'.

	classMeta := importer classNamed: 'Meta'.
	self assert: classMeta isNotNil.
	self assert: (classMeta superInheritances first target name) equals: 'type'.

	classAMeta := classA metaclass.
	self assert: classAMeta isNotNil.
	self assert: classAMeta name equals: 'pygame.sprite.Sprite'
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClassExplicitSuperclass [

	| classS classA |
	importer accept: (self parseCode: '
class S:
	pass
class A(S):
	def foo:
		pass
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 3.

	classS := importer classNamed: 'S'.
	self assert: classS isNotNil.
	self assert: classS superInheritances size equals: 1.

	classA := importer classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA superInheritances size equals: 1
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClassFQNSuperclass [

	| classA classMeta classAMeta |
	importer accept: (self parseCode: '
class A(pygame.sprite.Sprite):
	def foo:
		pass
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 2.

	classA := importer classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: (classA superInheritances first target name) equals: 'pygame.sprite.Sprite'.
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClassingleMetaclass [

	| classA classMeta classAMeta |
	importer accept: (self parseCode: '
class Meta(type):
	pass
class A(metaclass=Meta):
	def foo:
		pass
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 4.

	classA := importer classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: (classA superInheritances first target name) equals: 'object'.

	classMeta := importer classNamed: 'Meta'.
	self assert: classMeta isNotNil.
	self assert: (classMeta superInheritances first target name) equals: 'type'.

	classAMeta := classA metaclass.
	self assert: classAMeta isNotNil.
	self assert: classAMeta name equals: 'Meta'
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testTwoClassesObjectShouldNotBeDuplicated [

	importer accept: (self parseCode: '
class A:
	pass
class B:
		pass
').

	self
		assert: (importer model allWithType: FamixPythonClass) size
		equals: 3
]

{ #category : 'tests - module' }
FamixPythonImporterTest >> testTwoSiblingImportsHaveTheSameModule [
	
	| import module import2 | 
	importer accept: pyDoc.
	import := importer importNamed: 'pygame'.
	import2 := importer importNamed: 'random'.
	module := importer moduleNamed: self moduleName.
	self assert: import manualImportingEntity equals: module.
	self assert: import2 manualImportingEntity equals: module.
	self assert: import manualImportingEntity equals: import2 manualImportingEntity  

]
