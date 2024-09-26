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

	^ importer visitor model
]

{ #category : 'running' }
FamixPythonImporterTest >> moduleName2 [
	^ 'sprite_collect_blocks_2'


]

{ #category : 'running' }
FamixPythonImporterTest >> parseCode: aString [

	| file |
	file := FileSystem memory / 'testPythonModelName.py'.
	file writeStreamDo: [ :s | s nextPutAll: aString ].
	^ importer import: file
]

{ #category : 'running' }
FamixPythonImporterTest >> setUp [

	super setUp.

	importer := FamixPythonImporter new
]

{ #category : 'tests' }
FamixPythonImporterTest >> testAnnotatedClass [

	| class anno |
	self skip: 'Do we want the decorators in the model?'.
	self parseCode: '
@dataclass
class ValueRange:
    lo: int
    hi: int
'.

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
	self parseCode: '
@classmethod
def greet(name):
    print ''Hello'', name
'.

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
	self parseCode: '
class A:
	a = 1
	b = 2
class B:
	a = 2
'.

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
	self parseCode: '
@decorator
def say_whee():
    print("Whee!")
'.

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
	self parseCode: '
class A:
	@classmethod
	def foo:
		pass
'.

	famix := importer classNamed: 'A'.
	self assert: famix isNotNil.
	famix := famix methods first.
	self assert: famix name equals: 'foo'.
	famix := famix annotationInstances.
	self assert: famix size equals: 1.
	famix := famix first.
	self assert: famix annotatedEntity name equals: 'foo'
]

{ #category : 'tests - decorators' }
FamixPythonImporterTest >> testDecoratorsSanityCheck [

	self skip: 'Do we want the decorators in the model?'.
	self parseCode: '
class A:
	@classmethod
	def foo:
		pass
'.

	self assert: (importer model allWithType: FamixPythonMethod) size equals: 1
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testFunctionNoLambda [

	| famix |
	self parseCode: '
def identity():
    print("identify")
'.

	self assert: (self model allWithType: FamixPythonFunction) size equals: 1.

	famix := self functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assertEmpty: famix functions
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testFunctionSingleLambda [

	| famix |
	self skip: 'See if we want to manage lambdas? If yes, we should probably not represent them as functions.'.
	self parseCode: '
def identity():
    lambda x : x
'.

	self assert: (importer model allWithType: FamixPythonFunction) size equals: 2.

	famix := importer functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assert: famix functions size equals: 1.

	famix := famix functions anyOne.
	self assert: famix name equals: ''.
	self assert: famix functionOwner name equals: 'identity'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportModuleWithAlias [

	self skip. "Should be managed in FamixPythonProject1Test"
	self parseCode: '
import math as m
import matplotlib.pyplot as plt
'.

	self assert: (self importNamed: 'math') isNotNil.
	self assert: (self importNamed: 'math') asName equals: 'm'.

	self assert: (self importNamed: 'matplotlib.pyplot') isNotNil.
	self assert: (self importNamed: 'matplotlib.pyplot') asName equals: 'plt'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportModulesWithAliases [

	self skip. "Should be managed in FamixPythonProject1Test"
	self parseCode: '
import math as m, matplotlib.pyplot as plt
'.

	self assert: (self importNamed: 'math') isNotNil.
	self assert: (self importNamed: 'math') asName equals: 'm'.

	self assert: (self importNamed: 'matplotlib.pyplot') isNotNil.
	self assert: (self importNamed: 'matplotlib.pyplot') asName equals: 'plt'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportMultiClassesFromModule [

	self skip. "Should be managed in FamixPythonProject1Test"
	self parseCode: '
from keras.layers import Flatten, Activation, AveragePooling2D, BatchNormalization
'.

	self assert: (self importNamed: 'Flatten') isNotNil.
	self assert: (self importNamed: 'AveragePooling2D') isNotNil.
	self assert: (self importNamed: 'Activation') fromName equals: 'keras.layers'
]

{ #category : 'tests - import' }
FamixPythonImporterTest >> testImportMultiFunctionsFromModule [

	self skip. "Should be managed in FamixPythonProject1Test"
	self parseCode: '
from maths import add, subtract
'.

	self assert: (self importNamed: 'add') isNotNil.
	self assert: (self importNamed: 'subtract') isNotNil.
	self assert: (self importNamed: 'add') fromName equals: 'maths'
]

{ #category : 'tests - functions' }
FamixPythonImporterTest >> testInnerFunctions [

	| outer inner |
	self parseCode: 'def outer_func():
	def inner_func():
		print("Hello, World!")
	inner_func()'.

	self assert: self model allFunctions size equals: 2.
	outer := self functionNamed: 'outer_func'.
	inner := self functionNamed: 'inner_func'.

	self assert: inner functionOwner equals: outer.
	self assert: outer functionOwner isModule
]

{ #category : 'tests - attributes' }
FamixPythonImporterTest >> testInstanceAttributes [

	| classA classB localVariableA localVariableB |
	self parseCode: '
class A:
	def foo(self):
		a = 1
		b = 2
class B:
	a = 2
'.

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

	self parseCode: '
grid[row].append(".")
'.

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

	self parseCode: '
append(".")
'.
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationInNestedLoop [

	self skip: 'Invocations not treated in importer'.

	self parseCode: '
for row in array:
	test()
	for column in array:
		grid[row].append(".")
'.
	self assert: importer invocations size equals: 2.
	self assert: importer invocations anyOne class equals: FamixPythonInvocation
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithArrayReceiver [

	self skip: 'Invocations not treated in importer'.

	self parseCode: '
for row in array:
	grid[row].append(".")
'.
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithNumericalArguments [

	self skip: 'Invocations not treated in importer'.

	self parseCode: '
test(4, 25)
'.
	self assert: importer invocations size equals: 1.
	self assert: importer invocations anyOne class equals: FamixPythonInvocation.

	self assert: importer invocations anyOne signature equals: '4, 25'
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithReceiver [

	self skip: 'Invocations not treated in importer'.

	self parseCode: '
grid.append(test)
'.
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'append') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithStringReceiver [

	self skip: 'Invocations not treated in importer'.

	self parseCode: '
"CNN_Model_Rebuilt/logs/{}".format(NAME)
'.
	self assert: importer invocations size equals: 1.
	self assert: (importer invocationCandidate: 'format') isNotNil
]

{ #category : 'tests - invocations' }
FamixPythonImporterTest >> testInvocationWithVariableArguments [

	| invocation |
	self skip: 'Invocations not treated in importer'.

	self parseCode: '
test(x, 25) 
'.
	self assert: importer invocations size equals: 1.
	self assert: importer invocations anyOne class equals: FamixPythonInvocation.
	self assert: importer invocations anyOne signature equals: 'x, 25'.

	invocation := importer invocationCandidate: 'test'.

	self assert: ((invocation cacheAt: 'args' ifAbsent: [ false ]) first at: 'value') equals: 'x'.

	self assert: ((invocation cacheAt: 'args' ifAbsent: [ false ]) second at: 'value') equals: '25'
]

{ #category : 'tests - local variables' }
FamixPythonImporterTest >> testLocalVariablesKnowTheirFunction [

	| temporary1 temporary2 |
	self parseCode: 'def myFirstFunction():
	temporary = []

def mySecondFunction():
	temporary = 3'.

	self assert: (self model allLocalVariables size) equals: 2.
	temporary1 := self model allLocalVariables first.
	temporary2 := self model allLocalVariables second.
	
	self assert: temporary1 parentBehaviouralEntity name equals: 'myFirstFunction'.
	self assert: temporary2 parentBehaviouralEntity name equals: 'mySecondFunction'.
]

{ #category : 'tests - local variables' }
FamixPythonImporterTest >> testLocalVariablesWithSameName [

	| function1 function2 |
	self parseCode: 'def myFirstFunction():
	temporary = []

def mySecondFunction():
	temporary = 3'.

	self assert: self model allFunctions size equals: 2.
	self assert: self model allLocalVariables size equals: 2.
	function1 := self functionNamed: 'myFirstFunction'.
	function2 := self functionNamed: 'mySecondFunction'.

	self assert: function1 localVariables size equals: 1.
	self assert: function1 localVariables anyOne name equals: 'temporary'.
	self assert: function2 localVariables size equals: 1.
	self assert: function2 localVariables anyOne name equals: 'temporary'
]

{ #category : 'tests - lambdas' }
FamixPythonImporterTest >> testMultiFunctionsMultiLambdas [

	| famix |
	self skip: 'See if we want to manage lambdas? If yes, we should probably not represent them as functions.'.
	self parseCode: '
def identity():
    lambda x : x
def identity2():
    lambda x : x
    lambda x : x
'.

	self assert: (importer model allWithType: FamixPythonFunction) size equals: 5.

	famix := importer functionNamed: 'identity'.
	self assert: famix isNotNil.
	self assert: famix functions size equals: 1.

	famix := famix functions anyOne.
	self assert: famix name equals: ''.
	self assert: famix functionOwner name equals: 'identity'
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClasSingleFQNMetaclass [

	| classA classMeta classAMeta |
	self parseCode: '
class Meta(type):
	pass
class A(metaclass=pygame.sprite.Sprite):
	def foo:
		pass
'.

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
	self parseCode: '
class S:
	pass
class A(S):
	def foo:
		pass
'.

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
	self parseCode: '
class A(pygame.sprite.Sprite):
	def foo:
		pass
'.

	self assert: (self model allWithType: FamixPythonClass) size equals: 2.

	classA := self classNamed: 'A'.
	self assert: classA isNotNil.
	self assert: classA superInheritances first target name equals: 'Sprite'
]

{ #category : 'tests - metaclasses' }
FamixPythonImporterTest >> testSingleClassingleMetaclass [

	| classA classMeta classAMeta |
	self parseCode: '
class Meta(type):
	pass
class A(metaclass=Meta):
	def foo:
		pass
'.

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

	self parseCode: '
class A:
	pass
class B:
		pass
'.

	self assert: (self model allWithType: FamixPythonClass) size equals: 3
]
