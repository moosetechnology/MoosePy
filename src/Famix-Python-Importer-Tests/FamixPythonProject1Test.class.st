Class {
	#name : 'FamixPythonProject1Test',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonProject1Test class >> resources [

	^ { FamixPythonProject1TestResource }
]

{ #category : 'accessing' }
FamixPythonProject1Test >> model [

	^ FamixPythonProject1TestResource current model
]

{ #category : 'tests - modules' }
FamixPythonProject1Test >> testRootModule [

	| rootModule |
	self denyEmpty: self model allModules.

	rootModule := self moduleNamed: 'moduleAtRoot'.

	self assert: rootModule class equals: FamixPythonModule.
	self assert: rootModule name equals: 'moduleAtRoot'.
	self assert: rootModule isRoot.
	self assert: rootModule parentPackage isNil
]

{ #category : 'tests - packages' }
FamixPythonProject1Test >> testRootPackage [
	| rootPackage |
	self denyEmpty: self model allPackages.
	
	rootPackage := self packageNamed: 'root'.
	
	self assert: rootPackage class equals: FamixPythonPackage.
	self assert: rootPackage name equals: 'root'.
	self assert: rootPackage isRoot
]
