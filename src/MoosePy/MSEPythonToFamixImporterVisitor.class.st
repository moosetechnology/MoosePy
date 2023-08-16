Class {
	#name : #MSEPythonToFamixImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'functions',
		'methods',
		'model',
		'imports',
		'modules',
		'parameters'
	],
	#category : #MoosePy
}

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> basicCreateMethod: aSelector withSignature: aSignature [
	| method |
	method := model newMethod.
	method name: aSelector.
	method isStub: true.
	method signature: aSignature.
	^ method
	
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> classNamed: aName [

	^ classes at: aName ifAbsent: [ nil ]
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> classes [
	^ classes
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createClass: aClass [
	
	| class name  |
	name := (aClass cname value).
	class := classes at: name put: model newClass.
	class name: (aClass cname value).
	class stub: true.
	^ class
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createFunction: aMethodNode [

	self halt.
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> createImport: anImport [

	| name import module |
	name := anImport names first names first value.
	"this will not work when we have 
		import pygame.foo
		an import node should provide fullname which would return pygame.foo"

	import := FamixPythonImport new entityName: name.
	imports at: name put: import.
	module := self ensureModule: anImport parent parent.
	import manualImportingEntity: module.
	module manualAddImport: import
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createMethod: aMethodNode [

	| method thisClass methodPath |
	method := self
		          basicCreateMethod: aMethodNode fname value
		          withSignature: aMethodNode parameters signatureString.

	self
		ensureParameters: aMethodNode parameters
		inMethodName: aMethodNode.

	"unclear that we want to have a key based on the name."
	methods
		at: aMethodNode parent cname value , '.' , aMethodNode fname value
		put: method.
	thisClass := aMethodNode parent.
	method parentType: (self ensureClass: thisClass)
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createModule: aModuleNode [ 

	| module |
	module := model newModule.
	module name: (self moduleNameStringOf: aModuleNode).
	modules at: module name put: module.	
	
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createParameter: aParameter withMethodName: aMethodNode [

	| parameterName parameter |
	parameterName := aParameter nameToken value.
	parameter := (FamixPythonParameter new name: parameterName).
	
	parameters
		at: (self methodPath: aMethodNode) , '.' , parameterName
		put: parameter.

	"parameter parentBehaviouralEntity: (self ensureMethod: aMethodNode)"
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureClass: aClassNode [

	^ classes at: aClassNode cname value ifAbsent: [ self createClass: aClassNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureFunction: aFunctionNode [
	
	^ functions 
		at: aFunctionNode parent cname value, '.' , aFunctionNode fname value 
		ifAbsent: [ self createFunction: aFunctionNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureMethod: aFunctionNode [
	
	^ methods 
		at: aFunctionNode parent cname value, '.' , aFunctionNode fname value 
		ifAbsent: [ self createMethod: aFunctionNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureModule: aModuleNode [
		
	^ modules 
		at:  (self moduleNameStringOf: aModuleNode)
		ifAbsent: [ self createModule: aModuleNode ]
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> ensureParameters: theParameters inMethodName: aMethodNode [

	
	^ theParameters args collect: [ :parameter |
		  parameters
			  at: (self methodPath: aMethodNode) , '.' , parameter nameToken value 
			  ifAbsent: [
			  self createParameter: parameter withMethodName: aMethodNode ] ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> functions [
	^ functions
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> importNamed: aString [ 
	^ imports at: aString ifAbsent: [ nil ]
]

{ #category : #initialization }
MSEPythonToFamixImporterVisitor >> initialize [

	super initialize.
	classes := Dictionary new.
	functions := Dictionary new.
	methods := Dictionary new.
	imports := Dictionary new.
	modules := Dictionary new.
	parameters := Dictionary new.
	model := FamixPythonModel new name:
		         'PythonModel-' , 100 atRandom asString
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methodNamed: aString [ 
	^ methods at: aString ifAbsent: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methodPath: aMethodNode [
	^ 	aMethodNode parent cname value , '.'
	              , aMethodNode fname value.
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methods [
	^ methods
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> model [
	^ model
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> moduleNameStringOf: aModuleNode [
	"should push that to the PyInputFileNode"
	
	^ aModuleNode filename 
		ifNil: [ 'Main Module'] 
		ifNotNil: [:s | s basenameWithoutExtension ]		
	
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> moduleNamed: aString [ 
	^ modules at: aString ifAbsent: [ nil ]
]

{ #category : #'accessing - classes' }
MSEPythonToFamixImporterVisitor >> parameterNamed: pName [

	^ parameters at: pName ifAbsent: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> parameters [
	^ parameters 
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	^ super visitClassdef: aClassDef
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFileInput: aFileInput [
	self ensureModule: aFileInput. 
	^ super visitFileInput: aFileInput 
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitFuncdef: aFuncdef [
	"the parser does not make a difference between function and method, but a method is defined in a class and its first parameter is self."
	aFuncdef isMethod
		ifTrue: [ self ensureMethod: aFuncdef ]
		ifFalse: [ self ensureFunction: aFuncdef ].

	^ super visitFuncdef: aFuncdef
]

{ #category : #visiting }
MSEPythonToFamixImporterVisitor >> visitImport: anImport [

	
	self createImport: anImport.
	^ super visitImport: anImport
]
