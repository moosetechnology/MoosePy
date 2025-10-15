Extension { #name : 'SRSymbolsSolver' }

{ #category : '*Famix-Python-Importer' }
SRSymbolsSolver >> resolveUnresolvedPythonSymbols [
	"We start by reordering the list of resolvable to put those with the higher priority first."

	| resolvedSymbols |
	self toResolve sort: [ :resolvableWithContext | resolvableWithContext resolvable priority ] descending.
	resolvedSymbols := 0.
	self toResolve do: [ :resolvable |
			self errorReport catch: Exception during: [
					self
						execute: [
								resolvedSymbols := resolvedSymbols + 1.
								resolvable resolve ]
						recordedAs: ('[{1}/{2}] Importing {3}' format: {
									 resolvedSymbols asString.
									 toResolve size asString.
									 resolvable asString }) ] ]
]
