Extension { #name : 'FamixPythonFunction' }

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonFunction >> isBuiltIn [ 

  ^ false
]

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonFunction >> nonStubOwner [ 

 ^ self functionOwner name
]
