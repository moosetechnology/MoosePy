Class {
	#name : 'FamixPythonAbstractTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'model',
		'fileSystem',
		'file',
		'pyDoc'
	],
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonAbstractTestResource >> model [

	^ model
]

{ #category : 'native' }
FamixPythonAbstractTestResource >> moduleName [

	^ 'sprite_collect_blocks'
]

{ #category : 'running' }
FamixPythonAbstractTestResource >> setUp [

	super setUp.
	fileSystem := FileSystem memory.

	"load sourceBug2"
	file := fileSystem workingDirectory / (self moduleName , '.py').
	file writeStreamDo: [ :stream | stream nextPutAll: self sourcesToParse ].
	model := FamixPythonImporter import: fileSystem / (self moduleName , '.py')
]

{ #category : 'accessing' }
FamixPythonAbstractTestResource >> sourcesToParse [

	^ self subclassResponsibility
]

{ #category : 'running' }
FamixPythonAbstractTestResource >> tearDown [

	model := nil.
	super tearDown
]
