Class {
	#name : 'FamixPythonLocalFunctionEntitiesExtenssionTest',
	#superclass : 'FamixPythonAbstractEntitiesExtenssionTest',
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'accessing' }
FamixPythonLocalFunctionEntitiesExtenssionTest class >> resources [

	^ { FamixPythonLocalFunctionTestResource }
]

{ #category : 'accessing' }
FamixPythonLocalFunctionEntitiesExtenssionTest >> model [

	^ FamixPythonLocalFunctionTestResource current model
]

{ #category : 'tests' }
FamixPythonLocalFunctionEntitiesExtenssionTest >> testInvocationFromTheReturnOfALocalFunction [

	| invocations invocOfCopy invocOfDrop invocOfDrop2 invocOfHead |
	
	"
	train = train_orj.copy().drop([""PassengerId""],axis=1) #train is always a pandas object
	train=preprocess(train)  
	train=group_titles(train)  
	train = train.drop([""Name""],axis=1)
	train.head()
	"
	
	invocations := self allInvocationBetweenStart: 2885 andEnd: 3042. 
	
	invocOfCopy := invocations first.
	self assert: invocOfCopy candidates first name equals: 'copy'.
	self assert: invocOfCopy parentsPackagePath isNil.	
	self assert: invocOfCopy fullyQualifiedPath equals: 'pandas'.	
	self assert: invocOfCopy invokedFrom first variable equals: (self globalVariableNamed: 'train_orj'). 
	
	invocOfDrop := invocations second.
	self assert: invocOfDrop candidates first name equals: 'drop'.
	self assert: invocOfDrop parentsPackagePath isNil.	
	self assert: invocOfDrop fullyQualifiedPath equals: 'pandas'.	
	self assert: invocOfDrop invokedFrom first variable equals: (self globalVariableNamed: 'train_orj'). 
	
	invocOfDrop2 := invocations fifth.
	self assert: invocOfDrop2 candidates first name equals: 'drop'.
	self assert: invocOfDrop2 parentsPackagePath isNil.	
	self assert: invocOfDrop2 fullyQualifiedPath equals: 'pandas'.	
	self assert: invocOfDrop2 invokedFrom first variable equals: (self globalVariableNamed: 'train'). 
	
	invocOfHead := invocations sixth.
	self assert: invocOfHead candidates first name equals: 'head'.
	self assert: invocOfHead parentsPackagePath isNil.	
	self assert: invocOfHead fullyQualifiedPath equals: 'pandas'.	
	self assert: invocOfHead invokedFrom first variable equals: (self globalVariableNamed: 'train').
]

{ #category : 'tests' }
FamixPythonLocalFunctionEntitiesExtenssionTest >> testPreprocessInvocationPathShouldBeFileName [

	| invocation path1 path2 |
	invocation := self allInvocationWithFunctionNamed: 'preprocess'.
	self assert: invocation size equals: 2.

	path1 := invocation first fullyQualifiedPath .
	path2 := invocation second fullyQualifiedPath .
	self assert: path1 size equals: path2 size.
	self assert: path1 equals: 'local_func' 
]

{ #category : 'tests' }
FamixPythonLocalFunctionEntitiesExtenssionTest >> testPreprocessInvocations [

	| invocation invokedFrom1 invokedFrom2 parents1 parents2 |
	invocation := self allInvocationWithFunctionNamed: 'preprocess'.
	self assert: invocation size equals: 2.

	invokedFrom1 := invocation first invokedFrom.
	self assert: invokedFrom1 isEmpty.
	invokedFrom2 := invocation second invokedFrom.
	self assert: invokedFrom2 isEmpty.


	parents1 := invocation first parentsPackagePath.
	self assert: parents1 isNil.
	parents2 := invocation second parentsPackagePath .
	self assert: parents2 isNil
]
