Extension { #name : 'PyVarArgListNode' }

{ #category : '*MoosePy' }
PyVarArgListNode >> signatureString [

	^ String streamContents: [ :s | args 
							do: [ :each |  s nextPutAll: each nameToken value ]
							separatedBy: [ s nextPutAll:  ', '] ]
]
