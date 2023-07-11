Class {
	#name : #MSEPythonSmaccImporterVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'methods'
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

{ #category : #initialization }
MSEPythonSmaccImporterVisitor >> initialize [

	super initialize.
	classes := Dictionary new.
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
