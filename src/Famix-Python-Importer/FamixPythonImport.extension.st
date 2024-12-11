Extension { #name : 'FamixPythonImport' }

{ #category : '*Famix-Python-Importer' }
FamixPythonImport >> importPath [
	| path |
	path := self sourceText withoutPrefix: 'import '.
	path := path copyUpToSubString: 'as'.
	path := path copyWithout: ' '.
	^ path
]
