Class {
	#name : 'FamixPythonAbstractImporterTest',
	#superclass : 'TestCase',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> classNamed: aName [

	^ self model allClasses detect: [ :class | class name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> functionNamed: aName [

	^ self model allFunctions detect: [ :function | function name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> importNamed: aName [

	^ self model allImports detect: [ :import | import entityName = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> methodNamed: aName [

	^ self model allMethods detect: [ :method | method name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> model [
	self subclassResponsibility
]

{ #category : 'running' }
FamixPythonAbstractImporterTest >> moduleName [
	^ 'sprite_collect_blocks'


]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> moduleNamed: aName [

	^ self model allModules detect: [ :module | module name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> parameterNamed: aName [

	^ self model allParameters detect: [ :parameter | parameter name = aName ]
]

{ #category : 'running' }
FamixPythonAbstractImporterTest >> setUp [

	super setUp.

]
