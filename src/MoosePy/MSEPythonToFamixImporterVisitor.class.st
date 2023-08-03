Class {
	#name : #MSEPythonToFamixImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'functions',
		'methods',
		'model',
		'imports',
		'modules'
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
	module manualAddImport: import.

]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createMethod: aMethodNode [

	| method thisClass |
	method := self basicCreateMethod: aMethodNode fname value withSignature: aMethodNode parameters signatureString.
	"unclear that we want to have a key based on the name."
	methods at: aMethodNode parent cname value, '.', aMethodNode fname value put: method.
	thisClass := aMethodNode parent.
	method parentType: (self ensureClass: thisClass).
	
]

{ #category : #'private-entity-creation' }
MSEPythonToFamixImporterVisitor >> createModule: aModuleNode [ 

	| module |
	module := model newModule.
	module name: 'Main Module'. "The parser does not handle the file so we will have to do it. 
	For this we should create a memory file system."
	modules at: module name put: module.	
	
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
		at: 'Main Module' "yes we need to manage module name!!!"
		ifAbsent: [ self createModule: aModuleNode ]
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
	model := FamixPythonModel new name: 'PythonModel-', 100 atRandom asString.
	
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methodNamed: aString [ 
	^ methods at: aString ifAbsent: [ nil ]
]

{ #category : #'accessing - methods' }
MSEPythonToFamixImporterVisitor >> methods [
	^ methods
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> model [
	^ model
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> moduleNamed: aString [ 
	^ modules at: aString ifAbsent: [ nil ]
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
