Class {
	#name : 'FamixPythonLocalMethodInvocationResolvable',
	#superclass : 'FamixPythonAbstractInvocationOrInstantiationResolvable',
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'resolution' }
FamixPythonLocalMethodInvocationResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"We just need to check the methods of the class."

	aScope entity isClass ifFalse: [ NotFound signal ].

	(aScope reachableEntitiesNamed: identifier ofKinds: { FamixPythonMethod }) ifNotEmpty: [ :entities | "I don't think we can have multiple results here."
			self assert: entities size = 1.
			^ self result: entities anyOne ].

	SRNoResolutionPossible signal
]
