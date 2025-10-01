Extension { #name : 'FamixPythonMethod' }

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonMethod >> isBuiltIn [ 

 ^ false
]

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonMethod >> nonStubOwner [ 

 ^ self parentType mooseName asString
]
