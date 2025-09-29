"
In those test we want some specific behaviors. We want no inference and a very restrive path resolution
"
Class {
	#name : 'FamixPythonWIPEntitiesExtenssionTest',
	#superclass : 'FamixPythonAbstractEntitiesExtenssionTest',
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'accessing' }
FamixPythonWIPEntitiesExtenssionTest class >> resources [

	^ { FamixPythonWIPTestResource }
]

{ #category : 'accessing' }
FamixPythonWIPEntitiesExtenssionTest >> model [

	^ FamixPythonWIPTestResource current model
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testAddInvocationShouldBeResolvable [

	| invocations invokedFromAccesses vars fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'add'.
	self assert: invocations size equals: 12.
"Since model is not reasigned we can resolve the FQP"
	invokedFromAccesses := invocations collect: [ :i | i invokedFrom ]. 
	self assert: invokedFromAccesses size equals: 12.
	vars := invokedFromAccesses collect: [ :a | a first variable ].
	
	self assert: vars size equals: 12.
	self deny: (vars anySatisfy: [ :v | v ~= (self globalVariableNamed: 'model')  ]).
	
	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 12.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'keras.models.Sequential'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testCompileInvocationShouldBeResolvable [

	| invocations fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'compile'.
	self assert: invocations size equals: 1.
	
	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 1.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'keras.models.Sequential'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testDenseInvocationShouldBeResolvable [

	| invocations fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'Dense'.
	self assert: invocations size equals: 5.
	
	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 5.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'keras.layers'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testHeadInvocationParentsPackageShouldBeNil [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'head'.
	self assert: invocation size equals: 2.

	path1 := invocation first parentsPackagePath .
	path2 := invocation second parentsPackagePath .
	self assert: path1 equals: path2.
	self assert: path1 isNil 
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testHeadInvocationPathShouldNotBeSimilar [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'head'.
	self assert: invocation size equals: 2.

	path1 := invocation first fullyQualifiedPath: false .
	path2 := invocation second fullyQualifiedPath: false .
	self assert: path1 ~= path2.
	self assert: path2 equals: 'unknown' 
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInfoInvocationParentsPackageShouldBeNil [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'info'.
	self assert: invocation size equals: 2.

	path1 := invocation first parentsPackagePath .
	path2 := invocation second parentsPackagePath .
	self assert: path1 equals: path2.
	self assert: path1 isNil 
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInfoInvocationPathShouldNotBeSimilar [

	| invocations |
	invocations := self allInvocationWithFunctionNamed: 'info'.
	self assert: invocations size equals: 2.

	self assert: invocations first invokedFrom first variable equals: (self globalVariableNamed: 'train_orj'). 
	self assert: invocations second invokedFrom first variable equals: (self globalVariableNamed: 'train'). 

	self assert: (invocations first fullyQualifiedPath: false) equals: 'pandas'.
	self assert: (invocations second fullyQualifiedPath: false) equals: 'unknown'.

]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testPrintShouldBeABuiltInFunction [

	| invocation path |
	invocation := self allInvocationWithFunctionNamed: 'print'.
	self assert: invocation size equals: 4.


	self assert: invocation first invokedFrom isEmpty.
	path := invocation first parentsPackagePath.
	self assert: path equals: 'built-in'.
	self assert: invocation first fullyQualifiedPath equals: 'built-in'
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testReadCsvInvocationParentPackageShouldBePandas [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'read_csv'.
	self assert: invocation size equals: 2.

	path1 := invocation first parentsPackagePath.
	path2 := invocation second parentsPackagePath.
	self assert: path1 equals: path2.
	self assert: path1 equals: 'pandas'
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testReadCsvInvocationPathShouldBePandas [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'read_csv'.
	self assert: invocation size equals: 2.

	path1 := invocation first fullyQualifiedPath: false.
	path2 := invocation second fullyQualifiedPath: false.
	self assert: path1 equals: path2.
	self assert: path1 equals: 'pandas'
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testReadCsvShouldNotBeInvokedFromVariable [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'read_csv'.
	self assert: invocation size equals: 2.

	path1 := invocation first invokedFrom.
	path2 := invocation second invokedFrom .
	self assert: path1 size equals: path2 size.
	self assert: path1 isEmpty 
]
