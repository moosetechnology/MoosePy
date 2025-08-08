"
I'm a presenter used to import a python projets or file.

I can set manually the root package if needed and set a block to exclude some files from the analysis.
"
Class {
	#name : 'MiImportPythonModelDialog',
	#superclass : 'MiImportModelDialog',
	#instVars : [
		'pathInput',
		'pathButton',
		'rootPackagePathInput',
		'filesToIgnoreInput',
		'modelFile',
		'modelNameInput'
	],
	#category : 'Famix-Python-IDE',
	#package : 'Famix-Python-IDE'
}

{ #category : 'opening' }
MiImportPythonModelDialog class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiImportPythonModelDialog class >> title [

	^ 'Parse and import a python project'
]

{ #category : 'accessing' }
MiImportPythonModelDialog class >> windowExtent [

	^ 700 @ 400
]

{ #category : 'layout' }
MiImportPythonModelDialog >> defaultLayout [

	^ SpGridLayout new
		  beColumnNotHomogeneous;
		  column: 2 expand: true;
		  build: [ :builder |
				  builder
					  add: 'Folder: ';
					  add: pathInput;
					  add: pathButton;
					  nextRow;
					  add: 'Model name: ';
					  add: modelNameInput;
					  nextRow;
					  add: 'Root package path: ';
					  add: rootPackagePathInput;
					  nextRow;
					  add: 'Files to ignore: ';
					  add: filesToIgnoreInput;
					  nextRow ]
]

{ #category : 'private' }
MiImportPythonModelDialog >> getModelFile [

	(StOpenFileOrDirectoryPresenter new
		 defaultFolder: (modelFile
				  ifNil: [ FileLocator home ]
				  ifNotNil: [
						  modelFile isFile
							  ifTrue: [ modelFile parent ]
							  ifFalse: [ modelFile ] ]);
		 title: 'Select your model source folder';
		 extensions: #( 'py' );
		 openModal;
		 selectedEntry) ifNotNil: [ :file | self updateForModelFolder: file ]
]

{ #category : 'initialization' }
MiImportPythonModelDialog >> initializePresenters [

	super initializePresenters.
	pathInput := self newTextInput.
	pathButton := self newButton.
	modelNameInput := self newTextInput.
	rootPackagePathInput := self newTextInput.
	filesToIgnoreInput := self newTextInput.

	pathInput placeholder: FileLocator home asFileReference pathString.
	modelNameInput placeholder: 'MooseModel'.
	rootPackagePathInput placeholder: 'Relative path of the root package in the folder provided. Can by empty.'.
	filesToIgnoreInput text: 'file basename = ''venv'' or: [ file basename = ''setup.py'' ]'.

	pathButton
		icon: (self iconNamed: #open);
		action: [ self getModelFile ]
]

{ #category : 'action' }
MiImportPythonModelDialog >> privateImportModel [

	| importer |
	importer := FamixPythonImporter new.

	rootPackagePathInput text ifNotEmpty: [ :path | importer rootPackagePath: path ].
	filesToIgnoreInput text ifNotEmpty: [ :code | importer filesToIgnoreBlock: (self class compiler evaluate: '[ :file | ' , code , ' ]') ].

	importer import: pathInput text asFileReference.

	importer model name: modelNameInput text.

	^ importer model
]

{ #category : 'private' }
MiImportPythonModelDialog >> updateForModelFolder: aFile [
	"updates all fileds in the presenter according to new modelFile"

	modelFile := aFile.

	pathInput text: modelFile asFileReference pathString.
	modelNameInput text: modelFile basenameWithoutExtension
]

{ #category : 'action' }
MiImportPythonModelDialog >> validateImportForm [
	"checks that required fields are properly filled in"

	pathInput text ifEmpty: [ Error signal: 'Please choose an input file' ].
	pathInput text asFileReference exists ifFalse: [ Error signal: 'File path not found' ].
	modelNameInput text ifEmpty: [ Error signal: 'Please name the model' ]
]
