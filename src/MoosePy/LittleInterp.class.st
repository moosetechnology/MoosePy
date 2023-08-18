Class {
	#name : #LittleInterp,
	#superclass : #Object,
	#instVars : [
		'functions',
		'function',
		'environment'
	],
	#category : #MoosePy
}

{ #category : #initialization }
LittleInterp >> initialize [

	super initialize.
	"we should use a chained dictionary to represent scope."
	environment := Dictionary new
]

{ #category : #'as yet unclassified' }
LittleInterp >> interpretFunction: aPyFuncdefNode withBindings: aCollection [ 
	
	aPyFuncdefNode parameters isNil
		ifTrue: [ ^ aPyFuncdefNode statements collect: [ :each |  each acceptVisitor: self ] ].
	
	aPyFuncdefNode parameters args with: aCollection do: 
		[ :s :v |
			"this is horrible we should invoke recursively to get the value"
			
			environment at: s nameToken value 
				put: "(v acceptVisitor: self)" (Number readFrom: v arguments first test atom value numberToken value) ].

	^ aPyFuncdefNode statements collect: [ :each |  each acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
LittleInterp >> interpretFunctionCall: aPyPowerNode [ 
	"we have one one function so this is that one :)"
	
	^ self interpretFunction: function withBindings: aPyPowerNode trailers
]

{ #category : #visiting }
LittleInterp >> visit: aNode [ 
	^ aNode acceptVisitor: self
]

{ #category : #visiting }
LittleInterp >> visitFileInput: aPyFileInputNode [ 
		^ (aPyFileInputNode children collect: [ :each | each acceptVisitor: self ]) last
]

{ #category : #visiting }
LittleInterp >> visitFuncdef: aPyExprStmtNode [
		
 	^ aPyExprStmtNode assigns 
		ifNotEmpty: [ 
			environment 
			at: aPyExprStmtNode testlist atom nameToken value 
			put: (aPyExprStmtNode tos first acceptVisitor: self) ]
		ifEmpty: [ aPyExprStmtNode testlist acceptVisitor: self ]
]

{ #category : #generated }
LittleInterp >> visitNumber: aNode [ 

	^ Number readFrom: aNode numberToken value 
]

{ #category : #visiting }
LittleInterp >> visitPlusExpr: aPyPlusExprNode [ 
	| one two | 
	one := aPyPlusExprNode one acceptVisitor: self. 
	two := aPyPlusExprNode two acceptVisitor: self.
	^ one + two
]

{ #category : #visiting }
LittleInterp >> visitPower: aPyPowerNode [ 
	
	^ aPyPowerNode trailers 
		ifEmpty: [
			(aPyPowerNode parent isKindOf: PyReturnNode)
				ifTrue: [ 
					aPyPowerNode atom acceptVisitor: self ]
				ifFalse: [ 
			"this is a number or constant" 
			aPyPowerNode atom acceptVisitor: self ]
			]
		ifNotEmpty: [
			"this is call probably wrong"
			self interpretFunctionCall: aPyPowerNode ]
]

{ #category : #visiting }
LittleInterp >> visitReturn: aPyReturnNode [ 
		^ aPyReturnNode testlist acceptVisitor: self
]

{ #category : #visiting }
LittleInterp >> visitSimpleStmt: aPySimpleStmtNode [ 
		^ (aPySimpleStmtNode children collect: [ :each | each acceptVisitor: self ]) last
]

{ #category : #visiting }
LittleInterp >> visitSymbol: aPySymbolNode [ 
	^ environment at: aPySymbolNode nameToken value 
]
