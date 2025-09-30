Extension { #name : 'FamixPythonUnknownEntity' }

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonUnknownEntity >> isBuiltIn [ 

	(self parentPackage isNil & self isStub) ifTrue: [ 
		|builtInString|
	builtInString := 	#(
    abs aiter all anext any ascii
    bin bool breakpoint bytearray bytes
    callable chr classmethod compile complex
    delattr dict dir divmod
    enumerate eval exec
    filter float format frozenset
    getattr globals
    hasattr hash help hex
    id input int isinstance issubclass iter
    len list locals
    map max memoryview min
    next
    object oct open ord
    pow print property
    range repr reversed round
    set setattr slice sorted staticmethod str sum super
    tuple type
    vars
    zip
    __import__
).
		(builtInString anySatisfy: [:s | s = self name] ) ifTrue: [ ^ true ].
	 ].
 ^ false.
]
