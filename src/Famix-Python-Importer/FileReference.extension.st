Extension { #name : 'FileReference' }

{ #category : '*Famix-Python-Importer' }
FileReference >> isPythonPackageDeclaration [

	^ self basename = '__init__.py'
]
