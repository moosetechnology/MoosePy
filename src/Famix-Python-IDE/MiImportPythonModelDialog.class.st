Class {
	#name : 'MiImportPythonModelDialog',
	#superclass : 'MiImportModelDialog',
	#instVars : [
		'pathInput',
		'pathButton',
		'rootPackagePathInput',
		'rootPackagePathButton',
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
					  add: rootPackagePathButton;
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
	rootPackagePathButton := self newButton.
	filesToIgnoreInput := self newTextInput.

	pathInput placeholder: FileLocator home asFileReference pathString.
	modelNameInput placeholder: 'MooseModel'.
	rootPackagePathInput placeholder: FileLocator home asFileReference pathString.
	filesToIgnoreInput text: 'file basename = ''venv'' or: [ file basename = ''setup.py'' ]'.

	pathButton
		icon: (self iconNamed: #open);
		action: [ self getModelFile ].
	rootPackagePathButton icon: (self iconNamed: #open)
]

{ #category : 'private' }
MiImportPythonModelDialog >> updateForModelFolder: aFile [
	"updates all fileds in the presenter according to new modelFile"

	modelFile := aFile.

	pathInput text: modelFile asFileReference pathString.
	modelNameInput text: modelFile basenameWithoutExtension.
	rootPackagePathInput text: modelFile asFileReference pathString
]
