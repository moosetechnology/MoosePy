Class {
	#name : 'FamixPythonTreeSitterVisitor',
	#superclass : 'TSVisitor',
	#traits : 'SRTSolverUserVisitor',
	#classTraits : 'SRTSolverUserVisitor classTrait',
	#instVars : [
		'model',
		'fileReference'
	],
	#category : 'Famix-Python-Importer-Visitors',
	#package : 'Famix-Python-Importer',
	#tag : 'Visitors'
}

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> fileReference [
	^ fileReference
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> fileReference: anObject [
	fileReference := anObject
]

{ #category : 'initialization' }
FamixPythonTreeSitterVisitor >> initialize [

	super initialize.
	model := FamixPythonModel new name: 'default Python Model'.
	model sourceLanguage: model newSourceLanguage.
	self initialiseSolver
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> model [
	^ model
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> relativeFilePath [

	self model rootFolder ifNil: [ ^ self fileReference fullName removePrefix: '/' ].

	^ (self fileReference relativeTo: self model rootFolder asPath) pathString
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> setSourceAnchor: aFamixEntity from: aTSNode [

	^ self
		  setSourceAnchorTo: aFamixEntity
		  fileName: self relativeFilePath
		  start: aTSNode startPosition
		  end: aTSNode endPosition
]

{ #category : 'private' }
FamixPythonTreeSitterVisitor >> setSourceAnchorTo: aFamixEntity fileName: aString start: aNumber end: anotherNumber [

	aFamixEntity sourceAnchor: (FamixPythonIndexedFileAnchor new
			 fileName: aString;
			 startPos: aNumber;
			 endPos: anotherNumber;
			 mooseModel: self model;
			 yourself).

	(aFamixEntity class includesTrait: FamixTCanBeStub) ifTrue: [ aFamixEntity isStub: false ].

	^ aFamixEntity
]

{ #category : 'accessing' }
FamixPythonTreeSitterVisitor >> sourceText [

	self flag: #todo. "Manage encorders."
	^ self fileReference contents
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitDottedName: aDottedNameNode [

	^ aDottedNameNode sourceText
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitIdentifier: anIdentifierNode [
	^ anIdentifierNode sourceText
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitImportFromStatement: anImportFromStatement [

	| moduleName identifier |
	moduleName := (anImportFromStatement nodeChildByFieldName: 'module_name') accept: self
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitModule: aModuleNode [

	| isPackageDeclaration entity |
	"If the file is name __init__.py this means that we have the declaration of a package. Else we have a module that can be in a package."
	isPackageDeclaration := self fileReference basename = '__init__.py'.
	entity := isPackageDeclaration
		          ifTrue: [ self currentEntity ]
		          ifFalse: [ model newModuleNamed: self fileReference basenameWithoutExtension ].

	self setSourceAnchor: entity from: aModuleNode.

	isPackageDeclaration ifFalse: [
			self solver scopeIsEmpty ifFalse: [
					self assert: self currentEntity isPackage.
					entity parentPackage: self currentEntity ].

			(self currentEntity: entity) isMainEntity: true ].

	aModuleNode collectNamedChild do: [ :child | child accept: self ].

	"FamixPythonCommentsImporter importCommentsOf: aModuleNode visitor: self."

	"If we are in a package declaration we need to keep the package in the context for the modules in the package. The package will be pop later by the importer."
	^ isPackageDeclaration
		  ifTrue: [ self currentEntity ]
		  ifFalse: [ self popScope ]
]

{ #category : 'visiting' }
FamixPythonTreeSitterVisitor >> visitNode: aTSNode [

	| visitMethod |
	visitMethod := (String streamContents: [ :aStream |
			                aStream nextPutAll: 'visit'.
			                ($_ split: aTSNode type) do: [ :word | aStream nextPutAll: word capitalized ].
			                aStream nextPut: $: ]) asSymbol.

	^ (self respondsTo: visitMethod)
		  ifTrue: [ self perform: visitMethod with: aTSNode ]
		  ifFalse: [
				  visitMethod traceCr.
				  super visitNode: aTSNode ]
]
