Class {
	#name : 'InvocationsCSVExporter',
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
InvocationsCSVExporter class >> exportInvocationFrom: aPythonFilePath to: aCSVFilePath [

	^ self new
		source: aPythonFilePath;
		dest: aCSVFilePath;
		loadModel;
		export
]

{ #category : 'accessing' }
InvocationsCSVExporter >> dest [

	^ dest
]

{ #category : 'accessing' }
InvocationsCSVExporter >> dest: aCSVFilePath [ 

 dest := aCSVFilePath asFileReference 
]

{ #category : 'public' }
InvocationsCSVExporter >> export [

	| invocations csvFile |
	invocations := model allInvocations.

	csvFile := dest.

	csvFile writeStreamDo: [ :stream |
			| csv |
			csv := NeoCSVWriter on: stream.
			csv separator: $;.
			csv fieldWriter: #object.

			"En-têtes"
			csv nextPut: #( 'fonction' 'FQP' 'source' ).

			csv addObjectFields: {
					[ :inv | inv candidates first name asString ].
					[ :inv | inv fullyQualifiedPath: false ].
					[ :inv | inv signature asString ] }.

			csv nextPutAll: invocations ]
]

{ #category : 'as yet unclassified' }
InvocationsCSVExporter >> loadModel [

 model := FamixPythonImporter import: source
]

{ #category : 'accessing' }
InvocationsCSVExporter >> source [

	^ source
]

{ #category : 'accessing' }
InvocationsCSVExporter >> source: aPythonFilePath [

 source := aPythonFilePath asFileReference 
]
