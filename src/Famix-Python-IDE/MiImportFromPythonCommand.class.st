"
I'm a command to open a dialog allowing to import a file or a project in python.
"
Class {
	#name : 'MiImportFromPythonCommand',
	#superclass : 'MiImportCommand',
	#category : 'Famix-Python-IDE',
	#package : 'Famix-Python-IDE'
}

{ #category : 'default' }
MiImportFromPythonCommand class >> defaultDescription [

	^ 'Import a python project'
]

{ #category : 'default' }
MiImportFromPythonCommand class >> defaultIconName [
	
	^ #down
]

{ #category : 'default' }
MiImportFromPythonCommand class >> defaultName [

	^ 'Import python project'
]

{ #category : 'accessing' }
MiImportFromPythonCommand class >> importForm [

	^ MiImportPythonModelDialog
]
