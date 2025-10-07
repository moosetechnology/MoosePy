Class {
	#name : 'ImportCSVExporter',
	#superclass : 'Object',
	#instVars : [
		'source',
		'dest',
		'model'
	],
	#category : 'Famix-Python-Entities-Extenssions',
	#package : 'Famix-Python-Entities-Extenssions'
}

{ #category : 'as yet unclassified' }
ImportCSVExporter class >> exportImportFrom: aPythonFilePath to: aCSVFilePath [

	^ self new
		source: aPythonFilePath;
		dest: aCSVFilePath;
		loadModel;
		export
]

{ #category : 'accessing' }
ImportCSVExporter >> dest [

	^ dest
]

{ #category : 'accessing' }
ImportCSVExporter >> dest: aCSVFilePath [ 

 dest := aCSVFilePath asFileReference 
]

{ #category : 'public' }
ImportCSVExporter >> export [

	| imports csvFile |
	imports := model allImports.

	csvFile := dest.

	csvFile writeStreamDo: [ :stream |
			| csv |
			csv := NeoCSVWriter on: stream.
			csv separator: $;.
			csv fieldWriter: #object.

			"En-têtes"
			csv nextPut: #( 'imported entity' 'library name' 'source' ).

			csv addObjectFields: {
					[ :inv | inv importedEntity name asString ].
					[ :inv | inv importedEntity libraryName ].
					[ :inv | inv sourceText ] }.

			csv nextPutAll: imports ]
]

{ #category : 'as yet unclassified' }
ImportCSVExporter >> loadModel [
| importer |
importer := FamixPythonImporter new.
 model := importer import: source storeErrorsOn: ('/Users/mignard/Documents/work/invocationStudies/error_nb/errors.csv' asFileReference ).
 
]

{ #category : 'accessing' }
ImportCSVExporter >> source [

	^ source
]

{ #category : 'accessing' }
ImportCSVExporter >> source: aPythonFilePath [

 source := aPythonFilePath asFileReference 
]
