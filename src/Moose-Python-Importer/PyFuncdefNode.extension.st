Extension { #name : 'PyFuncdefNode' }

{ #category : '*Moose-Python-Importer' }
PyFuncdefNode >> isMethod [

	^ self parent class = PyClassdefNode
]
