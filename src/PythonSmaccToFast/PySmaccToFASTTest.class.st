Class {
	#name : #PySmaccToFASTTest,
	#superclass : #TestCase,
	#category : #'PythonSmaccToFast-Core'
}

{ #category : #tests }
PySmaccToFASTTest >> removeAllGeneratedClasses [

	self class environment at: #PysfDummyRoot ifPresent: [ :c | c withAllSubclasses do: [:each | each removeFromSystem ]]
]

{ #category : #tests }
PySmaccToFASTTest >> setUp [

	super setUp.
	self removeAllGeneratedClasses 
]

{ #category : #tests }
PySmaccToFASTTest >> tearDown [

	self removeAllGeneratedClasses.
	super tearDown
]

{ #category : #tests }
PySmaccToFASTTest >> testBuildAHierarchy [

	| conv |
	conv := PySmaccToFAST new.
	conv installRoot.
	conv buildHierarchyFrom: PyDummyRoot.
	
	{ #PysfDummyRoot . #PysfDummySubclass1 . #PysfDummySubclass11 . #PysfDummySubclass2 }
		do:  [ :s | 
					| c |
					c := self class environment at: s.
					self assert: c isClass. ].
	
]

{ #category : #tests }
PySmaccToFASTTest >> testBuildARootOfTheHierarchy [

	| builder sub1 |	
	builder := PySmaccToFAST new 
							installRoot;
							buildRootClassFrom: PyDummyRoot.
	self assert: builder superclassToBuild equals: PysfRootNode.
	self assert: builder nameToBuild equals: 'PysfDummyRoot'.
	
	sub1 :=  (self class environment at: #PysfDummyRoot).
	self assert: sub1 isClass.
	self assert: sub1 superclass equals: PysfRootNode.
	self assert: sub1 instVarNames equals: #(#one)
]

{ #category : #tests }
PySmaccToFASTTest >> testBuildASubclassUnderItsSuperclass [

	| conv sub1 |	
	conv := PySmaccToFAST new.
	conv 
		installRoot;
		buildRootClassFrom: PyDummyRoot;
		buildClassFrom: PyDummySubclass1. 
	sub1 :=  (self class environment at: #PysfDummySubclass1).
	self assert: sub1 isClass.
	self assert: sub1 superclass name equals: 'PysfDummyRoot'.
	self assert: sub1 instVarNames equals: #(#two)
]

{ #category : #tests }
PySmaccToFASTTest >> testBuildRootFromPyRootNode [

	| conv |
	conv := PySmaccToFAST new.
	conv installRoot.
	self assert: conv rootSuperclass equals: (self class environment at: #PysfRootNode)
]

{ #category : #tests }
PySmaccToFASTTest >> testBuildSubclasses [

	| conv |
	conv := PySmaccToFAST new.
	conv installRoot.
	conv buildWithSubclassesFrom: PyDummyRoot.
	
	{ #PysfDummyRoot . #PysfDummySubclass1 . #PysfDummySubclass2 }
		do:  [ :s | 
					| c |
					c := self class environment at: s.
					self assert: c isClass. ].
	
]
