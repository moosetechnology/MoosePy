Class {
	#name : 'FamixPythonImporterTest',
	#superclass : 'FamixPythonAbstractImporterTest',
	#instVars : [
		'importer'
	],
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonImporterTest >> model [

	^ importer model
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

	super setUp.

	importer := FamixPythonImporterVisitor new.
	importer model name: 'testPythonModelName'
]

{ #category : 'tests' }
FamixPythonImporterTest >> testAnnotatedClass [

	| class anno |
	self skip: 'Do we want the decorators in the model?'.
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
	self skip: 'Do we want the decorators in the model?'.
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
FamixPythonImporterTest >> testClassAttributes [

	| classA classB |
	importer accept: (self parseCode: '
class A:
	a = 1
	b = 2
class B:
	a = 2
').

	self assert: (self model allWithType: FamixPythonClass) size equals: 3.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA attributes size equals: 2.
	self assert: classA attributes first name equals: 'a'.
	self assert: classA attributes second name equals: 'b'.

	classB := self classNamed: 'B'.
	self assert: classB isNotNil.
	self assert: classB attributes size equals: 1.
	self assert: classB attributes first name equals: 'a'
]

{ #category : 'tests - decorators' }
FamixPythonImporterTest >> testDecoratorsFunctionSingleDecorator [
	"https://realpython.com/primer-on-python-decorators/"

	| famix |
	self skip: 'Do we want the decorators in the model?'.
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
	self assert: famix annotatedEntity name equals: 'say_whee'
]

{ #category : 'tests - decorators' }
FamixPythonImporterTest >> testDecoratorsMethodSingleDecorator [

	| famix |
	self skip: 'Do we want the decorators in the model?'.
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

	self skip: 'Do we want the decorators in the model?'.
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

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testFunctionNoLambda [

	| famix |
	importer accept: (self parseCode: '
def identity():
    print("identify")
').

	self assert: (self model allWithType: FamixPythonFunction) size equals: 1.

	famix := self functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assertEmpty: famix functions
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testFunctionSingleLambda [

	| famix |
	self skip: 'See if we want to manage lambdas? If yes, we should probably not represent them as functions.'.
	importer accept: (self parseCode: '
def identity():
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

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImport [

	importer accept: (self parseCode: '
import pygame
import random
').

	self assert: (self importNamed: 'pygame') isNotNil.
	self assert: (self importNamed: 'random') isNotNil
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportClassFromModule [

	importer accept: (self parseCode: '
from keras.layers import Input
').

	self assert: (self importNamed: 'Input') isNotNil.
	self assert: (self importNamed: 'Input') fromName equals: 'keras.layers'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportFunction [

	importer accept: (self parseCode: '
import matplotlib.pyplot
').

	self assert: (self importNamed: 'matplotlib.pyplot') isNotNil
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportFunctionFromModule [

	importer accept: (self parseCode: '
from random import randint
').

	self assert: (self importNamed: 'randint') isNotNil.
	self assert: (self importNamed: 'randint') fromName equals: 'random'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportModuleWithAlias [

	importer accept: (self parseCode: '
import math as m
import matplotlib.pyplot as plt
').

	self assert: (self importNamed: 'math') isNotNil.
	self assert: (self importNamed: 'math') asName equals: 'm'.

	self assert: (self importNamed: 'matplotlib.pyplot') isNotNil.
	self assert: (self importNamed: 'matplotlib.pyplot') asName equals: 'plt'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportModulesWithAliases [

	importer accept: (self parseCode: '
import math as m, matplotlib.pyplot as plt
').

	self assert: (self importNamed: 'math') isNotNil.
	self assert: (self importNamed: 'math') asName equals: 'm'.

	self assert: (self importNamed: 'matplotlib.pyplot') isNotNil.
	self assert: (self importNamed: 'matplotlib.pyplot') asName equals: 'plt'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportMultiClassesFromModule [

	importer accept: (self parseCode: '
from keras.layers import Flatten, Activation, AveragePooling2D, BatchNormalization
').

	self assert: (self importNamed: 'Flatten') isNotNil.
	self assert: (self importNamed: 'AveragePooling2D') isNotNil.
	self assert: (self importNamed: 'Activation') fromName equals: 'keras.layers'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportMultiFunctionsFromModule [

	importer accept: (self parseCode: '
from maths import add, subtract
').

	self assert: (self importNamed: 'add') isNotNil.
	self assert: (self importNamed: 'subtract') isNotNil.
	self assert: (self importNamed: 'add') fromName equals: 'maths'
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

	self assert: (self model allWithType: FamixPythonClass) size equals: 3.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA attributes size equals: 0.
	self assert: classA methods first localVariables size equals: 2.

	localVariableA := classA methods first localVariables first.
	self assert: localVariableA isNotNil.
	self assert: localVariableA name equals: 'a'.

	localVariableB := classA methods first localVariables second.
	self assert: localVariableB isNotNil.
	self assert: localVariableB name equals: 'b'.

	classB := self classNamed: 'B'.
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


	invocations := self model allWithType: FamixPythonInvocation.
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

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testMultiFunctionsMultiLambdas [

	| famix |
	self skip: 'See if we want to manage lambdas? If yes, we should probably not represent them as functions.'.
	importer accept: (self parseCode: '
def identity():
    lambda x : x
def identity2():
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

{ #category : 'tests' }
FamixPythonImporterTest >> testSameAnnotationType [

	self skip: 'Do we want the decorators in the model?'.
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

	self assert: (self model allWithType: FamixPythonClass) size equals: 5.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA superInheritances first target name equals: 'object'.

	classMeta := self classNamed: 'Meta'.
	self assert: classMeta isNotNil.
	self assert: classMeta superInheritances first target name equals: 'type'.

	classAMeta := classA metaclass.
	self assert: classAMeta isNotNil.
	self assert: classAMeta name equals: 'Sprite'
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

	self assert: (self model allWithType: FamixPythonClass) size equals: 3.

	classS := self classNamed: 'S'.
	self assert: classS isNotNil.
	self assert: classS superInheritances size equals: 1.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA superInheritances size equals: 1
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClassFQNSuperclass [

	| classA |
	importer accept: (self parseCode: '
class A(pygame.sprite.Sprite):
	def foo:
		pass
').

	self assert: (self model allWithType: FamixPythonClass) size equals: 2.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA superInheritances first target name equals: 'Sprite'
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

	self assert: (self model allWithType: FamixPythonClass) size equals: 4.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA superInheritances first target name equals: 'object'.

	classMeta := self classNamed: 'Meta'.
	self assert: classMeta isNotNil.
	self assert: classMeta superInheritances first target name equals: 'type'.

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

	self assert: (self model allWithType: FamixPythonClass) size equals: 3
]
