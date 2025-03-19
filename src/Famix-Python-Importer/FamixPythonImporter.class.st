"
An importer for Python projects.

## Use the importer

You can launch the import of a project like this:

```st
FamixPythonImporter import: '/Users/cyril/testPython/reader' asFileReference
```

It will return a Famix python model generated from the .py files in this folder and if there are errors during the parsing, it'll open an inspector with the list of errors.

## Root package determination

The root package path variable allows one to specify from which directory in the sources start the parsing.
	
Let's take this example:

```	
	/project
		/src
			/package
				__initi__.py
			module.py
		/resources
			/example
				example.py
```			

If no root package path is specify, `project` will be considered the root directory and will be the start point for the absolute import resolution. But it's highly possible that the real working directory here is /src. 
	
It is possible to do:

```st	
	FamixPythonImporter import: 'path/to/project' asFileReference rootPackagePath: 'src' 
```

## Ignore files

It as also possible to indicate that we want to ignore files or folder. In order to do that, the variable #filesToIgnoreBlock should be used. It should be a valuable (like a block) taking file references as parameter and returning true if we should ignore those files/folders.
By default I'm excluding folders named `venv` because it is common to have a python interpreter of this name in projects if we develop them on the computer and files setup.py.

For the example above we could do:

```st
	FamixPythonImporter new
		filesToIgnoreBlock: [ :file | #('venv' 'setup.py' 'resources') includes: file basename ] ];
		import: 'path/to/project'
```
"
Class {
	#name : 'FamixPythonImporter',
	#superclass : 'Object',
	#instVars : [
		'visitor',
		'errorReport',
		'rootPackagePath',
		'filesToIgnoreBlock'
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
	"The root package path variable allows one to specify from which directory in the sources start the parsing.
	
	Let's take this example:
	
	/project
		/src
			/package
				__initi__.py
			module.py
		/resources
			/example
				example.py
				
	If no root package path is specify, `project` will be considered the root directory and will be the start point for the absolute import resolution. But it's highly possible that the real working directory here is /src. 
	
	It is possible to do:
	
	FamixPythonImporter import: 'path/to/project' asFileReference rootPackagePath: 'src' "

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

{ #category : 'api' }
FamixPythonImporter >> determineSourceRootFolderFrom: fileReference [
	"We decided in the parser to define a folder as the root of the project to be used as the base of relative imports. This folder will be the first package of the project. 
	To find it we have two solutions:
		- The user specified the rootPackagePath and we use this (see class comment)
		- The variable is nil and in the case we take the first comment parent folder to all .py files."

	^ self rootPackagePath
		  ifNil: [
			  | filesToParse foldersToVisit |
			  "We will collect all .py to parse and find their common parents."
			  filesToParse := OrderedCollection new.
			  foldersToVisit := { fileReference }.

			  [
			  foldersToVisit do: [ :folder |
				  folder files do: [ :file | (file isPythonFile and: [ (self filesToIgnoreBlock value: file) not ]) ifTrue: [ filesToParse add: file ] ] ].
			  foldersToVisit := foldersToVisit flatCollect: [ :folder | folder directories reject: [ :subFolder | filesToIgnoreBlock value: subFolder ] ].
			  foldersToVisit isNotEmpty ] whileTrue.

			  "Now that we have all files to parse, we need to find the common parent.
			To do that, I'l taking all parents of all files and I check the ones present everywhere. Then I'm using the one with the longest path."
			  (((filesToParse collect: #allParents) reduce: [ :a :b | a intersection: b ]) sort: [ :file | file pathString size ] descending) first ]
		  ifNotNil: [ :path | fileReference / path ]
]

{ #category : 'accessing' }
FamixPythonImporter >> errorReport [

	^ visitor errorReport
]

{ #category : 'accessing' }
FamixPythonImporter >> filesToIgnoreBlock [

	^ filesToIgnoreBlock
]

{ #category : 'accessing' }
FamixPythonImporter >> filesToIgnoreBlock: anObject [

	filesToIgnoreBlock := anObject
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

	"If we parse a unique file, we do nothing. If we have a folder, we check what is the source root to start creating our packages."
	fileReference isPythonFile ifFalse: [ fileReference := self determineSourceRootFolderFrom: fileReference ].
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
	
	If it is a directory, we check if it contains .py files to know if it is a folder or a package. If it is a package, we create the entity and visit its content.
	If it is a file, we parse it if it is a python file.
	"

	aFileReference isDirectory ifTrue: [
		(aFileReference allFiles anySatisfy: [ :file | file isPythonFile ]) ifTrue: [
			| package |
			package := visitor model newPackageNamed: aFileReference basename.
			visitor hasCurrentEntity ifTrue: [ package parentPackage: visitor currentEntity ].
			(visitor currentEntity: package) isMainEntity: true.

			"If we have an __init__.py file, this is a package. To have it at the top of the context we need to parse it first so that the sub packages and modules go in it."
			(aFileReference children sorted: [ :fileA :fileB | fileA isPythonPackageDeclaration or: [ fileB isPythonPackageDeclaration not ] ]) ifNotEmpty: [ :files |
				files do: [ :child | self importFileReference: child ] ].
			visitor popScope ].

		^ self ].

	aFileReference isPythonFile ifFalse: [ ^ self ].

	self importPythonFile: aFileReference
]

{ #category : 'api' }
FamixPythonImporter >> importPythonFile: aFileReference [

	('Importing ' , aFileReference pathString) traceCr.
	"(aFileReference basename = #'moduleAtRoot2.py') ifTrue: [ 1halt ]."
	(PythonParser parseFileWithErrors: aFileReference) acceptVisitor: visitor
]

{ #category : 'initialization' }
FamixPythonImporter >> initialize [

	super initialize.
	filesToIgnoreBlock := [ :file | file basename = 'venv' or: [ file basename = 'setup.py' ] ]
]

{ #category : 'accessing' }
FamixPythonImporter >> rootPackagePath [
	"See comment of FamixPythonImporter class>>#import:rootPackagePath:"

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
