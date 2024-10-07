Extension { #name : 'PyNameNode' }

{ #category : '*Famix-Python-Importer' }
PyNameNode >> alias [
	"There is no alias if we end up on this node. This is to be polymorphic with the #asName node"

	^ nil
]

{ #category : '*Famix-Python-Importer' }
PyNameNode >> name [

	^ self nameToken value
]
