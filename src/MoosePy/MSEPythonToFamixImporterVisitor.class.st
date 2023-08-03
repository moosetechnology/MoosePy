Class {
	#name : #MSEPythonToFamixImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'functions'
	],
	#category : #MoosePy
}

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
MSEPythonToFamixImporterVisitor >> ensureClass: aClass [

	^ classes at: aClass cname value ifAbsent: [ self createClass: aClass ]
]

{ #category : #accessing }
MSEPythonToFamixImporterVisitor >> ensureFunction: aFunction [
	
	^ functions at: aFunction parent cname value, '.' , aFunction fname value ifAbsentPut: [ aFunction ]
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
]

{ #category : #generated }
MSEPythonToFamixImporterVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	super visitClassdef: aClassDef
]

{ #category : #generated }
MSEPythonToFamixImporterVisitor >> visitFuncdef: aFuncdef [

	self ensureFunction:  aFuncdef.
	super visitClassdef: aFuncdef
]
