"
An importer for Python projects

You can launch the import of a project like this:

```st
FamixPythonImporter import: '/Users/cyril/testPython/reader' asFileReference
```

It will return a Famix python model generated from the .py files in this folder and if there are errors during the parsing, it'll open an inspector with the list of errors.
"
Class {
	#name : 'FamixPythonImporter',
	#superclass : 'Object',
	#instVars : [
		'visitor',
		'errorReport'
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

{ #category : 'dev-utils' }
FamixPythonImporter class >> importBeerTradingBot [

	<script>
	(self import: '/Users/cyril/testPython/beer-trading-bot-main' asFileReference) inspect
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

	aFileReference isDirectory ifTrue: [ "I'm not sure we should have this escape but venv is a python interpreter and we are not able to parse it currently. This clause should probably be removed in the future."
		aFileReference basename = 'venv' ifTrue: [ ^ self ].

		"If we have an __init__.py file, this is a package. To have it at the top of the context we need to parse it first so that the sub packages and modules go in it."
		(aFileReference children sorted: [ :fileA :fileB | fileA isPythonPackageDeclaration or: [ fileB isPythonPackageDeclaration not ] ]) ifNotEmpty: [ :files |
			files do: [ :child | self importFileReference: child ].

			"If the directory is a package, we need to remove it from the context after visiting all files of the package."
			files first isPythonPackageDeclaration ifTrue: [ visitor popScope ] ].
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
FamixPythonImporter >> visitor [

	^ visitor
]
