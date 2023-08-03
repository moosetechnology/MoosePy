Extension { #name : #PyFuncdefNode }

{ #category : #'*MoosePy' }
PyFuncdefNode >> isMethod [

	^ self parent class = PyClassdefNode
]
