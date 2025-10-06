"
In those test we want some specific behaviors. We want no inference and a very restrictive path resolution.
Only the class instanciation propagate the type.
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
FamixPythonWIPEntitiesExtenssionTest >> testBatchNormalizationInvocationShouldBeResolvable [

	| invocations fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'BatchNormalization'.
	self assert: invocations size equals: 3.
	
	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 3.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'keras.layers'  ]).
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
FamixPythonWIPEntitiesExtenssionTest >> testDropoutInvocationShouldBeResolvable [

	| invocations fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'Dropout'.
	self assert: invocations size equals: 4.
	
	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 4.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'keras.layers'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testFitInvocationShouldBeResolvableAndNotPointToTheLocalFitMethod [

	| invocations fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'fit'.
	self assert: invocations size equals: 2.
	
	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 2.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'keras.models.Sequential'  ]).
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
	self assert: path1 equals: path2.
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

	self assert: (invocations first fullyQualifiedPath: false) equals: 'unknown'.
	self assert: (invocations second fullyQualifiedPath: false) equals: 'unknown'.

]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInvocationOfALocalFuncWithMultipleCandidates [

	| invocation fqPaths |
	invocation := self allInvocationWithFunctionNamed: 'local_func'.
	self assert: invocation size equals: 1.
	
	fqPaths := invocation collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 1.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'test'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInvocationOnAFunctionLocalVarShouldNotBeResolvable [

	| invocation fqPaths |
	invocation := self allInvocationWithFunctionNamed: 'mean'.
	self assert: invocation size equals: 3.
	
	fqPaths := invocation collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 3.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'unknown'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInvocationOnAFunctionParamShouldNotBeResolvable [

	| invocation fqPaths |
	invocation := self allInvocationWithFunctionNamed: 'inParamFunc'.
	self assert: invocation size equals: 3.
	
	fqPaths := invocation collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 3.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'dependOnParameterType'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInvocationOnAnIteratorVarShouldBeUnknown [

	| invocations  fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'startswith'.
	self assert: invocations size equals: 1.

	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 1.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'unknown'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testInvocationWithMultipleCandidatesOfDifferentsEntities [
"
This invocation is on a function having the same name as a method.
Normally we know that the candidate can only be either the method either the function.

inst_class.on_epoch_end() -> will only have the method in candidates.
on_epoch_end() -> will only have the function in candidates.

This does not work if we have static methods @staticmethod
"

	| invocation fqPaths |
	invocation := self allInvocationWithFunctionNamed: 'on_epoch_end'.
	self assert: invocation size equals: 1.
	
	fqPaths := invocation collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 1.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'test'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testLocalsShouldBeABuiltInFunction [

	| invocations  fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'locals'.
	self assert: invocations size equals: 1.


	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 1.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'builtIn'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testNonStubClassInstanciationShouldBeResolvable [

	| invocations  fqPaths |
	invocations := self allInvocationWithFunctionNamed: '__init__'.
	self assert: invocations size equals: 1.

	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 1.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'test.roc_auc_callback'  ]).
]

{ #category : 'asserting' }
FamixPythonWIPEntitiesExtenssionTest >> testPrintShouldBeABuiltInFunction [

	| invocations  fqPaths |
	invocations := self allInvocationWithFunctionNamed: 'print'.
	self assert: invocations size equals: 8.


	fqPaths := invocations collect: [ :i | i fullyQualifiedPath: false ].
   	self assert: fqPaths size equals: 8.
	self deny: (fqPaths anySatisfy: [ :v | v ~=  'builtIn'  ]).
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
