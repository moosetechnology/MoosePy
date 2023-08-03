Class {
	#name : #MSEPythonToFamixImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'functions',
		'methods'
	],
	#category : #MoosePy
}

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> basicCreateMethod: aSelector withSignature: aSignature [
	| method |
	method := FamixPythonMethod new.
	method name: aSelector.
	method isStub: true.
	method signature: aSignature.
	^ method
	
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> classNamed: aName [

	^ classes at: aName ifAbsent: [ nil ]
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> classes [
	^ classes
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> createClass: aClass [
	
	| class name  |
	name := (aClass cname value).
	class := classes at: name put: FamixPythonClass  new.
	class name: (aClass cname value).
	class stub: true.
	^ class
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> createFunction: aMethodNode [

	self halt.
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> createMethod: aMethodNode [

	| method thisClass |
	method := self basicCreateMethod: aMethodNode fname value withSignature: aMethodNode parameters signatureString.
	methods at: aMethodNode parent cname value, '.', aMethodNode fname value put: method.
	thisClass := aMethodNode parent.
	method parentType: (self ensureClass: thisClass).
	
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> ensureClass: aClass [

	^ classes at: aClass cname value ifAbsent: [ self createClass: aClass ]
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> ensureFunction: aFunction [
	
	^ functions 
		at: aFunction parent cname value, '.' , aFunction fname value 
		ifAbsent: [ self createFunction: aFunction ]
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> ensureMethod: aFunction [
	
	^ methods 
		at: aFunction parent cname value, '.' , aFunction fname value 
		ifAbsent: [ self createMethod: aFunction ]
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> functions [
	^ functions
]

{ #category : #initialization }
MSEPythonToFamixImporterVisitor >> initialize [

	super initialize.
	classes := Dictionary new.
	functions := Dictionary new.
	methods := Dictionary new.
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methodNamed: aString [ 
	^ methods at: aString ifAbsent: [ nil ]
]

{ #category : #generated }
MSEPythonToFamixImporterVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	super visitClassdef: aClassDef
]

{ #category : #generated }
MSEPythonToFamixImporterVisitor >> visitFuncdef: aFuncdef [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."
	aFuncdef isMethod
		ifTrue: [ self ensureMethod: aFuncdef ]
		ifFalse: [ self ensureFunction: aFuncdef ].

	super visitClassdef: aFuncdef
]
