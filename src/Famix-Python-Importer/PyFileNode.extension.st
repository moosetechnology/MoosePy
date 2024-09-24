Extension { #name : 'PyFileNode' }

{ #category : '*Famix-Python-Importer' }
PyFileNode >> packageName [
	"If we have a __init__.py file, the package name should be the name of the parent folder"

	^ self fileReference parent basename
]
