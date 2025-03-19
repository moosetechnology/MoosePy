Extension { #name : 'AbstractFileReference' }

{ #category : '*Famix-Python-Importer' }
AbstractFileReference >> allParents [

	| parents |
	parents := OrderedCollection new.
	parents add: self parent.
	[
	parents last parent isRoot
		ifTrue: [ false ]
		ifFalse: [
			parents add: parents last parent.
			true ] ] whileTrue.
	^ parents
]

{ #category : '*Famix-Python-Importer' }
AbstractFileReference >> isPythonFile [

	^ self extension = 'py'
]

{ #category : '*Famix-Python-Importer' }
AbstractFileReference >> isPythonPackageDeclaration [

	^ self basename = '__init__.py'
]
