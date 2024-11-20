Class {
	#name : 'FamixPythonAbstractImporterTest',
	#superclass : 'TestCase',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> attributeNamed: aName [

	^ self entityNamed: aName in: self model allAttributes
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> classNamed: aName [

	^ self entityNamed: aName in: self model allClasses
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> entityNamed: aName in: aCollection [

	| entities |
	entities := aCollection select: [ :entity | entity name = aName ].
	entities size ~= 1 ifTrue: [ self error: 'Only 1 entity should be named ' , aName , ' but got ' , entities size asString ].
	^ entities anyOne
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> functionNamed: aName [

	^ self entityNamed: aName in: self model allFunctions
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> globalVariableNamed: aName [

	^ self entityNamed: aName in: self model allGlobalVariables
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> importNamed: aName [

	^ self model allImports detect: [ :import | import importedEntity name = aName ]
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> localVariableNamed: aName [

	^ self entityNamed: aName in: self model allLocalVariables
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> methodNamed: aName [

	^ self entityNamed: aName in: self model allMethods
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

	^ self entityNamed: aName in: self model allModules
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> packageNamed: aName [

	^ self entityNamed: aName in: self model allPackages
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> parameterNamed: aName [

	^ self entityNamed: aName in: self model allParameters
]

{ #category : 'accessing' }
FamixPythonAbstractImporterTest >> unknownContainerNamed: aName [

	^ self model entities detect: [ :entity | entity class = FamixPythonUnknownImportedEntity and: [ entity name = aName ] ]
]
