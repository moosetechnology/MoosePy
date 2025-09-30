Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*Famix-Python-Entities-Extenssions' }
TEntityMetaLevelDependency >> libraryName [

	| module toPrint current |
	module := (self query ancestors ofAnyType: {
			           FamixPythonPackage.
			           FamixPythonModule.
			           FamixPythonUnknownEntity }) anyOne.

	toPrint := OrderedCollection with: module.

	current := module.
	[ current parents isNotEmpty ] whileTrue: [
		toPrint add: current parents anyOne.
		current := toPrint last ].

	^ $. join: (toPrint reverse collect: #name)
]
