Class {
	#name : #MSEPythonSmaccImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'methods',
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

	^ functions at: aFunction cname value ifAbsentPut: [ aFunction ]
]

{ #category : #initialization }
MSEPythonSmaccImporterVisitor >> initialize [

	super initialize.
	classes := Dictionary new.
	functions := Dictionary new.
]

{ #category : #accessing }
MSEPythonSmaccImporterVisitor >> methods [
	^ methods
]

{ #category : #generated }
MSEPythonSmaccImporterVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	super visitClassdef: aClassDef
]
