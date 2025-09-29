Extension { #name : 'FamixPythonInvocation' }

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonInvocation >> fullyQualifiedPath [

	| parentPath |
	"Should handle case when function are not stub""If function are not stub we need to handle the calls inside that uses a parameter""	1halt."

	parentPath := self parentsPackagePath.
	parentPath ifNil: [
			| var accesses classInstanciaton invokedFrom |
			invokedFrom := self invokedFrom.
			invokedFrom isEmpty ifFalse: [
					var := self invokedFrom first variable.
					var class = FamixPythonParameter ifTrue: [
						^ 'cannotResolveParameter' ].
					accesses := var incomingAccesses asOrderedCollection.
					accesses := accesses sorted: [ :a :b |
						            a sourceAnchor startPos > b sourceAnchor startPos ].

					accesses := accesses select: [ :a |
							            a sourceAnchor startPos
							            < self sourceAnchor startPos
							            &
							            (a sourceAnchor endPos < self sourceAnchor endPos)
								            and: [ a isWrite ] ].

					classInstanciaton := accesses first
						                     attributeAt: #firstCall
						                     ifAbsent: [ ^ 'cannotResolve' "1 halt" ].
					parentPath := classInstanciaton fullyQualifiedPath ] ].
	
	"Si on a une declaration de cette fonction qui ne serait pas en stub"
	self candidates first isStub ifFalse: [ parentPath := self candidates first functionOwner name ].
	parentPath ifNil: [ parentPath := 'unknown' ].


	^ parentPath , '.' , self candidates first name
]

{ #category : '*Famix-Python-Entities-Extenssions' }
FamixPythonInvocation >> fullyQualifiedPath: isInstanciation [ 

	| parentPath |
	"Should handle case when function are not stub""If function are not stub we need to handle the calls inside that uses a parameter""	1halt."

	parentPath := self parentsPackagePath.
	parentPath ifNil: [
			| var accesses classInstanciaton invokedFrom |
			invokedFrom := self invokedFrom.
			invokedFrom isEmpty ifFalse: [
					var := self invokedFrom first variable.
					var class = FamixPythonParameter ifTrue: [
						^ 'cannotResolveParameter' ].
					accesses := var incomingAccesses asOrderedCollection.
					accesses := accesses sorted: [ :a :b |
						            a sourceAnchor startPos > b sourceAnchor startPos ].

					accesses := accesses select: [ :a |
							            a sourceAnchor startPos
							            < self sourceAnchor startPos
							            &
							            (a sourceAnchor endPos < self sourceAnchor endPos)
								            and: [ a isWrite ] ].

					classInstanciaton := accesses first
						                     attributeAt: #firstCall
						                     ifAbsent: [ ^ 'cannotResolve' "1 halt" ].
					parentPath := classInstanciaton fullyQualifiedPath: true ] ].
	
	"Si on a une declaration de cette fonction qui ne serait pas en stub"
	self candidates first isStub ifFalse: [ isInstanciation ifFalse: [parentPath := self candidates first functionOwner name] ].
	parentPath ifNil: [ parentPath := 'unknown' ].
	isInstanciation ifTrue: [self candidates first name first isUppercase ifTrue: [parentPath := parentPath , '.' , self candidates first name] ].

	^ parentPath 
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
