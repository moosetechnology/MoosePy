Class {
	#name : #PySmaccToFAST,
	#superclass : #Object,
	#category : #'PythonSmaccToFast-Core'
}

{ #category : #internal }
PySmaccToFAST >> basicBuildClassNamed: aClassName superclass: aSuperclass variables: anArrayOfSymbols [
	
	| builder |
	builder := aSuperclass << aClassName.
	builder slots: anArrayOfSymbols.
	builder tag: 'Generated'.
	builder package: 'PythonSmaccToFAST'.
	builder install.
	^ builder
]

{ #category : #building }
PySmaccToFAST >> buildClassFrom: aClass [

	^ self basicBuildClassNamed: (self nameFor: aClass)  
				superclass: (self class environment at: (self nameFor: aClass superclass) asSymbol) 
				variables: (self variablesFrom: aClass) 
]

{ #category : #building }
PySmaccToFAST >> buildHierarchyFrom: aClass [
	"Precondition: the transformed superclass of aClass does exist"
	
	self buildClassFrom: aClass.
	aClass subclassesDo: [ :asub |
		self buildHierarchyFrom: asub
		]
]

{ #category : #building }
PySmaccToFAST >> buildRootClassFrom: aClass [
	
	self installRoot.
	^ self basicBuildClassNamed: (self nameFor: aClass)  
				superclass:  self rootSuperclass
				variables: (self variablesFrom: aClass) 
]

{ #category : #building }
PySmaccToFAST >> buildWithSubclassesFrom: aClass [
	"Precondition: the transformed superclass of aClass does exist"
	
	self buildClassFrom: aClass.
	aClass subclassesDo: [ :asub |
		self buildClassFrom: asub
		]
]

{ #category : #initialization }
PySmaccToFAST >> initialize [ 
	super initialize.
	self installRoot
]

{ #category : #internal }
PySmaccToFAST >> installRoot [

	self class environment 
			at: 'PysfRootNode'
			ifAbsent: [ self basicBuildClassNamed: #PysfRootNode superclass: Object variables: #(). ]
]

{ #category : #utilities }
PySmaccToFAST >> nameFor: aClass [

	^ aClass name copyReplaceAll:  'Py' with: 'Pysf' 
]

{ #category : #utilities }
PySmaccToFAST >> rootSuperclass [

	^ self class environment at: #'PysfRootNode'
		
]

{ #category : #utilities }
PySmaccToFAST >> variablesFrom: aClass [

	^ aClass instVarNames reject: [ :s | s endsWith: 'Token' ]
]
