"
An importer for Python projects

You can launch the import of a project like this:

```st
FamixPythonImporter import: '/Users/cyril/testPython/reader' asFileReference
```

It will return a Famix python model generated from the .py files in this folder and if there are errors during the parsing, it'll open an inspector with the list of errors.

In case of absolute imports, we resolve them by starting in the first folder containing .py files. If the user wants to configure another path, the variable `rootPackagePath` can be used. 

```st
FamixPythonImporter import: '/Users/cyril/testPython/reader' asFileReference rootPackagePath: 'project/src/'
```
"
Class {
	#name : 'FamixPythonImporter',
	#superclass : 'Object',
	#instVars : [
		'visitor',
		'errorReport',
		'rootPackagePath'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'api' }
FamixPythonImporter class >> import: aFileName [

	^self new
		import: aFileName
]

{ #category : 'api' }
FamixPythonImporter class >> import: aFileName rootPackagePath: aString [

	^ self new
		  rootPackagePath: aString;
		  import: aFileName
]

{ #category : 'dev-utils' }
FamixPythonImporter class >> importBeerTradingBot [

	<script>
	(self import: '/Users/cyril/testPython/beer-trading-bot-main' asFileReference) inspect
]

{ #category : 'dev-utils' }
FamixPythonImporter class >> importPreferentialSampling [

	<script>
	(self import: '/Users/cyril/testPython/preferential_sampling' asFileReference) inspect
]

{ #category : 'dev-utils' }
FamixPythonImporter class >> importReader [

	<script>
	(self import: '/Users/cyril/testPython/reader' asFileReference) inspect
]

{ #category : 'accessing' }
FamixPythonImporter >> errorReport [

	^ visitor errorReport
]

{ #category : 'api' }
FamixPythonImporter >> import: aFileName [

	| fileReference |
	visitor := FamixPythonImporterVisitor new.
	fileReference := aFileName asFileReference.

	visitor model
		name: fileReference basename;
		rootFolder: (fileReference isFile
				 ifTrue: [ fileReference parent ]
				 ifFalse: [ aFileName ]). "If we parse a folder, it will be the root. If it's just a file, we consider that the root is its parent"

	self importFileReference: fileReference.

	visitor resolveUnresolvedSymbols.

	self flag: #todo. "We should probably handle it another way in production."
	self errorReport ifNotEmpty: [ self errorReport inspect ].

	^ visitor model
]

{ #category : 'api' }
FamixPythonImporter >> importFileReference: aFileReference [
	"We can have multiple cases here. 
	
	The file reference can be a directory or a file. 
	
	## Directory 
		If we have a directory, the may to manage it will depend if we are already in a python package or not. 
		
		## We are not in a python package
			If we are not in a package, we will check if the folder is the root folder of the project. It will be if the user provided a root package path matching the folder. If the user did not set it, then we will check if the folder contains .py files and consider it is the root if yes.
			
		## We are already in a python package
			The folder will be considered as a package if it contains recursively at least one .py file. Since python 3.3 we do not need to have an __init__.py file.
			Else we will ignore it 
		
	## File
		Either it is an __init__.py that will be the content of the current package. 
		Or any other .py files are modules.
	"

	"I'm not sure we should have this escape but venv is a python interpreter and we are not able to parse it currently. This clause should probably be removed in the future."

	aFileReference basename = 'venv' ifTrue: [ ^ self ].

	aFileReference isDirectory ifTrue: [
		visitor hasCurrentEntity
			ifTrue: [
				(aFileReference allFiles anySatisfy: [ :file | file extension = 'py' ]) ifTrue: [
					| package |
					package := visitor model newPackageNamed: aFileReference basename.
					visitor hasCurrentEntity ifTrue: [ package parentPackage: visitor currentEntity ].
					(visitor currentEntity: package) isMainEntity: true.

					"If we have an __init__.py file, this is a package. To have it at the top of the context we need to parse it first so that the sub packages and modules go in it."
					(aFileReference children sorted: [ :fileA :fileB | fileA isPythonPackageDeclaration or: [ fileB isPythonPackageDeclaration not ] ]) ifNotEmpty: [ :files |
						files do: [ :child | self importFileReference: child ] ].
					visitor popScope ] ]
			ifFalse: [
				(aFileReference files anySatisfy: [ :file | file extension = 'py' ])
					ifTrue: [
						| package |
						package := visitor model newPackageNamed: aFileReference basename.
						visitor hasCurrentEntity ifTrue: [ package parentPackage: visitor currentEntity ].
						(visitor currentEntity: package) isMainEntity: true.

						"If we have an __init__.py file, this is a package. To have it at the top of the context we need to parse it first so that the sub packages and modules go in it."
						(aFileReference children sorted: [ :fileA :fileB | fileA isPythonPackageDeclaration or: [ fileB isPythonPackageDeclaration not ] ]) ifNotEmpty: [ :files |
							files do: [ :child | self importFileReference: child ] ].
						visitor popScope ]
					ifFalse: [ aFileReference directories do: [ :directory | self importFileReference: directory ] ] ].


		^ self ].

	aFileReference extension = 'py' ifFalse: [ ^ self ].

	self importPythonFile: aFileReference
]

{ #category : 'api' }
FamixPythonImporter >> importPythonFile: aFileReference [

	('Importing ' , aFileReference pathString) traceCr.
	"(aFileReference basename = #'moduleAtRoot2.py') ifTrue: [ 1halt ]."
	(PythonParser parseFileWithErrors: aFileReference) acceptVisitor: visitor
]

{ #category : 'accessing' }
FamixPythonImporter >> rootPackagePath [

	^ rootPackagePath
]

{ #category : 'accessing' }
FamixPythonImporter >> rootPackagePath: anObject [

	rootPackagePath := anObject
]

{ #category : 'accessing' }
FamixPythonImporter >> visitor [

	^ visitor
]
