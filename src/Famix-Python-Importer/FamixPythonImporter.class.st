"
An importer for Python projects

API:
```St
MSEPythonProjectImporter import: 'python/project/root/directory'
```

will return a `FamixPythonModel`
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

{ #category : 'accessing' }
FamixPythonImporter >> errorReport [

	^ visitor errorReport
]

{ #category : 'api' }
FamixPythonImporter >> import: aFileName [

	| fileReference |
	visitor := FamixPythonImporterVisitor new.
	visitor rootFilePath: aFileName.

	fileReference := aFileName asFileReference.
	visitor model
		name: fileReference basename;
		rootFolder: aFileName asFileReference.

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
	"(aFileReference basename = #'moduleAtRoot.py') ifTrue: [ 1halt ]."
	(PythonParser parseFileWithErrors: aFileReference) acceptVisitor: visitor
]

{ #category : 'accessing' }
FamixPythonImporter >> visitor [

	^ visitor
]
