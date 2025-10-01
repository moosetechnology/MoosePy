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
						^ 'dependOnParameterType' ].
					accesses := var incomingAccesses asOrderedCollection.
					accesses := accesses sorted: [ :a :b |
						            a sourceAnchor startPos > b sourceAnchor startPos ].

					accesses := accesses select: [ :a |
							            a sourceAnchor startPos
							            < self sourceAnchor startPos
							            &
							            (a sourceAnchor endPos < self sourceAnchor endPos)
								            and: [ a isWrite ] ].
					accesses isEmpty ifTrue: [ "1halt." ^ 'unknown' ].
					classInstanciaton := accesses first
						                     attributeAt: #firstCall
						                     ifAbsent: [ ^ 'unknown' "1 halt" ].
					parentPath := classInstanciaton fullyQualifiedPath: true ] ].
	
	"Si on a une declaration de cette fonction qui ne serait pas en stub"
	self candidates first isStub ifFalse: [ isInstanciation ifFalse: [parentPath := self candidates first nonStubOwner ] ].
	self candidates first isBuiltIn ifTrue: [ parentPath := 'builtIn' ].
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
	"This heuristic is very bad, we will need a better resolver. It doesn't work when a supe().__init__ is called and both the call and super class are not stub"
		"1 haltIf: [ self candidates size > 1 ]."
		
	self candidates size > 1 ifTrue: [ current := (self candidates select: [ :c | c parentType = self sender parentType ]) first ]	
	ifFalse: [current := self candidates first ].

	toPrint := OrderedCollection new.

	[
		(current respondsTo: #parentPackage) and: [
			(parent := current parentPackage) isNotNil ] ] whileTrue: [
			toPrint add: parent.
			current := parent ].

	^ ($. join: (toPrint reverse collect: #name))ifEmpty: [ nil ]
]
