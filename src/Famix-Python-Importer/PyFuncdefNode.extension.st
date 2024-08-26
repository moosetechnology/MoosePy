Extension { #name : 'PyFuncdefNode' }

{ #category : '*Famix-Python-Importer' }
PyFuncdefNode >> isMethod [

	^ self parent class = PyClassdefNode
]
