Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*Famix-Python-Entities-Extenssions' }
TEntityMetaLevelDependency >> libraryName [

	| module toPrint current |
	module := (self query containers ofAnyType: {
			           FamixPythonPackage.
			           FamixPythonModule.
			           FamixPythonUnknownEntity }) anyOne.

	toPrint := OrderedCollection with: module.

	current := module.
	[ current containers isNotEmpty ] whileTrue: [
			toPrint add: current containers anyOne.
			current := toPrint last ].

	^ $. join: (toPrint reverse collect: #name)
]
