Class {
	#name : #ToyingWithParserTest,
	#superclass : #TestCase,
	#category : #MoosePy
}

{ #category : #tests }
ToyingWithParserTest >> testInterpretIdentity [
	
	| tree intr val |
	
	tree :=	PythonParser parse:

'def identity(a):                           
    return a    

identity(1)'.

	intr := LittleInterp new.
	val  := intr visit: tree.
	self assert: val first equals: 1
]

{ #category : #tests }
ToyingWithParserTest >> testInterpretNumbers [
	
	| tree val intr |
	tree := PythonParser parse: '1'.
	intr := LittleInterp new.
	val  := intr visit: tree.
	self assert: val equals: 1
	
]

{ #category : #tests }
ToyingWithParserTest >> testInterpretSumOfNumbers [
	
	| tree val intr |
	tree := PythonParser parse: '1 + 2'.
	intr := LittleInterp new.
	val  := intr visit: tree.
	self assert: val equals: 3
	
]

{ #category : #tests }
ToyingWithParserTest >> testParseAssignment [
	
	| tree intr val |
	
	tree :=	PythonParser parse:
'a = 1   
a'.

	intr := LittleInterp new.
	val  := intr visit: tree.
	self assert: val equals: 1
]

{ #category : #tests }
ToyingWithParserTest >> testParseAssignment2 [
	
	| tree intr val |
	
	tree :=	PythonParser parse:
'a = 1
b = 2
a + b'.

	intr := LittleInterp new.
	val  := intr visit: tree.
	self assert: val equals: 3
]

{ #category : #tests }
ToyingWithParserTest >> testParseFuncConstant [
	
	| tree intr val |
	
	tree :=	PythonParser parse:

'def one():                           
    return 1    

one()'.

	intr := LittleInterp new.
	val  := intr visit: tree.
	self assert: val first equals: 1
]

{ #category : #tests }
ToyingWithParserTest >> testParseIf [
	
	| tree intr val |
	
	tree :=	PythonParser parse:

'def maxi(a, b):                           # [integer], [integer]
    if a > b:                            # [bool]
        return a                         # [integer]
    return b    

maxi(1,2)'.

	intr := LittleInterp new.
	val  := intr visit: tree.
]
