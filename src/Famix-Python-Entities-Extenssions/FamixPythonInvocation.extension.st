Extension { #name : 'FamixPythonInvocation' }

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonInvocation >> fullyQualifiedPath [

	| parentPath methodName |
	parentPath := self parentsPackagePath.
	parentPath ifNil: [
			| var accesses classInstanciaton invokedFrom |
			invokedFrom := self invokedFrom.
			invokedFrom isEmpty ifFalse: [
					var := self invokedFrom first variable.
					accesses := var incomingAccesses asOrderedCollection.
					accesses := accesses sorted: [ :a :b |
						            a sourceAnchor startPos > b sourceAnchor startPos ].

					accesses := accesses select: [ :a |
							            a sourceAnchor startPos
							            < self sourceAnchor startPos
							            &
							            (a sourceAnchor endPos ~= self sourceAnchor endPos)
								            and: [ a isWrite ] ].

					classInstanciaton := accesses first
						                     attributeAt: #firstCall
						                     ifAbsent: [ 1 halt ].
					parentPath := classInstanciaton fullyQualifiedPath ] ].

	methodName := self candidates first name.
	parentPath ifNil: [ parentPath := 'unknown' ].


	^ parentPath , '.' , methodName
]

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonInvocation >> invokedFrom [

	^ self mooseModel allAccesses select: [ :a |
		  a sourceAnchor startPos = self sourceAnchor startPos ]
]

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonInvocation >> parentsPackagePath [

	| toPrint current parent |
	self flag: #TODO.
	"If we have multiple candidates it will break"
		1 haltIf: [ self candidates size > 1 ].
	
	current := self candidates first.

	toPrint := OrderedCollection new.

	[
		(current respondsTo: #parentPackage) and: [
			(parent := current parentPackage) isNotNil ] ] whileTrue: [
			toPrint add: parent.
			current := parent ].

	^ ($. join: (toPrint reverse collect: #name))ifEmpty: [ nil ]
]
