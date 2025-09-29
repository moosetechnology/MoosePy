Class {
	#name : 'FamixPythonBasicsEntitiesExtenssionTest',
	#superclass : 'FamixPythonAbstractEntitiesExtenssionTest',
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'accessing' }
FamixPythonBasicsEntitiesExtenssionTest class >> resources [

	^ { FamixPythonBasicsTestResource }
]

{ #category : 'accessing' }
FamixPythonBasicsEntitiesExtenssionTest >> model [

	^ FamixPythonBasicsTestResource current model
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testFilterwarningInvocationParentsPackageShouldBeWarning [

	| invocation path |
	invocation := self allInvocationWithFunctionNamed: 'filterwarnings'. 
	self assert: invocation size equals: 1.
	
	path := invocation first parentsPackagePath .
	self assert: path equals: 'warnings'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testFilterwarningInvocationPathShouldBeWarning [

	| invocation path |
	invocation := self allInvocationWithFunctionNamed: 'filterwarnings'. 
	self assert: invocation size equals: 1.
	
	path := invocation first fullyQualifiedPath .
	self assert: path equals: 'warnings'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testFilterwarningShouldNotBeInvokedFromVariable [

	| invocation var |
	invocation := self allInvocationWithFunctionNamed: 'filterwarnings'. 
	self assert: invocation size equals: 1.
	
	var := invocation first invokedFrom .
	self assert: var isEmpty 
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testHeadInvocationParentsPackageShouldBeNil [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'head'.
	self assert: invocation size equals: 2.

	path1 := invocation first parentsPackagePath .
	path2 := invocation second parentsPackagePath .
	self assert: path1 equals: path2.
	self assert: path1 isNil 
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testHeadInvocationPathShouldBePandas [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'head'.
	self assert: invocation size equals: 2.

	path1 := invocation first fullyQualifiedPath.
	path2 := invocation second fullyQualifiedPath.
	self assert: path1 equals: path2.
	self assert: path1 equals: 'pandas'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testHeadShouldBeInvokedFromVariable [

	| invocation access1 var1 access2 var2 |
	invocation := self allInvocationWithFunctionNamed: 'head'.
	self assert: invocation size equals: 2.

	access1 := invocation first invokedFrom .
	self assert: access1 size equals: 1.
	var1 := access1 first variable.
	self assert: var1 equals: (self globalVariableNamed: 'train_orj'). 

	access2 := invocation second invokedFrom .
	self assert: access2 size equals: 1.
	var2 := access2 first variable.
	self assert: var2 equals: (self globalVariableNamed: 'test_orj'). 
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testInfoInvocationParentsPackageShouldBeNil [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'info'.
	self assert: invocation size equals: 2.

	path1 := invocation first parentsPackagePath .
	path2 := invocation second parentsPackagePath .
	self assert: path1 equals: path2.
	self assert: path1 isNil 
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testInfoInvocationPathShouldBePandas [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'info'.
	self assert: invocation size equals: 2.

	path1 := invocation first fullyQualifiedPath.
	path2 := invocation second fullyQualifiedPath.
	self assert: path1 equals: path2.
	self assert: path1 equals: 'pandas'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testModelShouldHave8Invocations [

	self assert: (self model allInvocations size) equals: 8
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testPrintShouldBeABuiltInFunction [

	| invocation path |
	invocation := self allInvocationWithFunctionNamed: 'print'.
	self assert: invocation size equals: 1.


	self assert: invocation first invokedFrom isEmpty.
	path := invocation first parentsPackagePath.
	self assert: path equals: 'built-in'.
	self assert: invocation first fullyQualifiedPath equals: 'built-in'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testReadCsvInvocationParentPackageShouldBePandas [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'read_csv'.
	self assert: invocation size equals: 2.

	path1 := invocation first parentsPackagePath.
	path2 := invocation second parentsPackagePath.
	self assert: path1 equals: path2.
	self assert: path1 equals: 'pandas'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testReadCsvInvocationPathShouldBePandas [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'read_csv'.
	self assert: invocation size equals: 2.

	path1 := invocation first fullyQualifiedPath.
	path2 := invocation second fullyQualifiedPath.
	self assert: path1 equals: path2.
	self assert: path1 equals: 'pandas'
]

{ #category : 'asserting' }
FamixPythonBasicsEntitiesExtenssionTest >> testReadCsvShouldNotBeInvokedFromVariable [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'read_csv'.
	self assert: invocation size equals: 2.

	path1 := invocation first invokedFrom.
	path2 := invocation second invokedFrom .
	self assert: path1 size equals: path2 size.
	self assert: path1 isEmpty 
]
