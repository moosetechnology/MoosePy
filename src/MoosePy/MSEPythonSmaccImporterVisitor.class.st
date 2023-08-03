Class {
	#name : #MSEPythonSmaccImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'functions'
	],
	#category : #MoosePy
}

{ #category : #accessing }
MSEPythonSmaccImporterVisitor >> classes [
	^ classes
]

{ #category : #accessing }
MSEPythonSmaccImporterVisitor >> ensureClass: aClass [

	^ classes at: aClass cname value ifAbsentPut: [ aClass ]
]

{ #category : #accessing }
MSEPythonSmaccImporterVisitor >> ensureFunction: aFunction [
	
	^ functions at: aFunction parent cname value, '.' , aFunction fname value ifAbsentPut: [ aFunction ]
]

{ #category : #accessing }
MSEPythonSmaccImporterVisitor >> functions [
	^ functions
]

{ #category : #initialization }
MSEPythonSmaccImporterVisitor >> initialize [

	super initialize.
	classes := Dictionary new.
	functions := Dictionary new.
]

{ #category : #generated }
MSEPythonSmaccImporterVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	super visitClassdef: aClassDef
]

{ #category : #generated }
MSEPythonSmaccImporterVisitor >> visitFuncdef: aFuncdef [

	self ensureFunction:  aFuncdef.
	super visitClassdef: aFuncdef
]
