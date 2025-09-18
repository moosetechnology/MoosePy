Class {
	#name : 'FamixPythonAbstractEntitiesExtenssionTest',
	#superclass : 'TestCase',
	#category : 'Famix-Python-Entities-Extenssion-Tests',
	#package : 'Famix-Python-Entities-Extenssion-Tests'
}

{ #category : 'as yet unclassified' }
FamixPythonAbstractEntitiesExtenssionTest >> allInvocationBetweenStart: aStartPos andEnd: anEndPos [

	^ self model allInvocations select: [ :i | (i sourceAnchor startPos >= aStartPos) & (i sourceAnchor endPos <= anEndPos) ].
]

{ #category : 'as yet unclassified' }
FamixPythonAbstractEntitiesExtenssionTest >> allInvocationWithFunctionNamed: aName [

	^ self model allInvocations select: [ :i |
		              i candidates anySatisfy: [ :c | c name = aName ] ].
]

{ #category : 'as yet unclassified' }
FamixPythonAbstractEntitiesExtenssionTest >> globalVariableNamed: aName [

	| globalVar |
	globalVar := self model allGlobalVariables select: [ :v |
		             v name = aName ].
	globalVar size > 1 ifTrue: [
		self error: 'Multiple global variable with the same name found' ].

	^ globalVar first
]

{ #category : 'accessing' }
FamixPythonAbstractEntitiesExtenssionTest >> model [ 

	self subclassResponsibility 
]
