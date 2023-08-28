Class {
	#name : #MSEPythonSmaccToyingVisitor,
	#superclass : #PyRootNodeVisitor,
	#instVars : [
		'classes',
		'functions'
	],
	#category : #'MoosePy-Visitors'
}

{ #category : #accessing }
MSEPythonSmaccToyingVisitor >> classes [
	^ classes
]

{ #category : #accessing }
MSEPythonSmaccToyingVisitor >> ensureClass: aClass [

	^ classes at: aClass cname value ifAbsentPut: [ aClass ]
]

{ #category : #accessing }
MSEPythonSmaccToyingVisitor >> ensureFunction: aFunction [
	
	^ functions at: aFunction parent cname value, '.' , aFunction fname value ifAbsentPut: [ aFunction ]
]

{ #category : #accessing }
MSEPythonSmaccToyingVisitor >> functions [
	^ functions
]

{ #category : #initialization }
MSEPythonSmaccToyingVisitor >> initialize [

	super initialize.
	classes := Dictionary new.
	functions := Dictionary new.
]

{ #category : #generated }
MSEPythonSmaccToyingVisitor >> visitClassdef: aClassDef [

	self ensureClass:  aClassDef.
	super visitClassdef: aClassDef
]

{ #category : #generated }
MSEPythonSmaccToyingVisitor >> visitFuncdef: aFuncdef [

	self ensureFunction:  aFuncdef.
	super visitClassdef: aFuncdef
]
