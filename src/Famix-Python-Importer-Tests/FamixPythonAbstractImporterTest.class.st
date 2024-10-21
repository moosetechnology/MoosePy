Class {
	#name : 'FamixPythonAbstractImporterTest',
	#superclass : 'TestCase',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> attributeNamed: aName [

	^ self model allAttributes detect: [ :attribute | attribute name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> classNamed: aName [

	^ self model allClasses detect: [ :class | class name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> functionNamed: aName [

	^ self model allFunctions detect: [ :function | function name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> globalVariableNamed: aName [

	^ self model allGlobalVariables detect: [ :variable | variable name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> importNamed: aName [

	^ self model allImports detect: [ :import | import importedEntity name = aName ]
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
FamixPythonAbstractImporterTest >> packageNamed: aName [

	^ self model allPackages detect: [ :package | package name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> parameterNamed: aName [

	^ self model allParameters detect: [ :parameter | parameter name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> unknownContainerNamed: aName [

	^ self model entities detect: [ :entity | entity class = FamixPythonUnknownImportedEntity and: [ entity name = aName ] ]
]
