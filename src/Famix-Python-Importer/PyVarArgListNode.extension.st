Extension { #name : 'PyVarArgListNode' }

{ #category : '*Famix-Python-Importer' }
PyVarArgListNode >> signatureString [

	^ String streamContents: [ :s | args 
							do: [ :each |  s nextPutAll: each nameToken value ]
							separatedBy: [ s nextPutAll:  ', '] ]
]
