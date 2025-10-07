Extension { #name : 'FamixPythonImporter' }

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonImporter >> import: aFileReference storeErrorsOn: aErrorFileReference [

	| fileReference |
	fileReference := aFileReference asFileReference. "In case the user provided a file name instead of a file reference."

	self initializeVisitorAndModelUsing: fileReference.

	"If we parse a unique file, we do nothing. If we have a folder, we check what is the source root to start creating our packages."
	fileReference isPythonFile ifFalse: [ fileReference := self determineSourceRootFolderFrom: fileReference ].

	self importFileReference: fileReference.

	visitor resolveUnresolvedSymbols.

	self flag: #todo. "We should probably handle it another way in production."

	self errorReport ifNotEmpty: [ self storeErrorOn: ('/tmp/error/',(( self model name substrings: '.') first), '.csv') asFileReference ].
	
	"I'm adding some properties to help with the import. Cleaning up afterward."
	self model entities do: #flush.

	^ self model
]

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonImporter >> storeErrorOn: aFileReference [
	| errors |
	errors := self errorReport errors.
	aFileReference writeStreamDo: [ :stream |
			| csv |
			csv := NeoCSVWriter on: stream.
			csv separator: $;.
			csv fieldWriter: #object.

			"En-têtes"
			csv nextPut: #( 'Exception' 'Message' ).

			csv addObjectFields: {
					[ :inv | inv class asString ].
					[ :inv | inv messageText ].
					 }.

			csv nextPutAll: errors ]
]
