"
SmaCC does not manages comments via nodes but just give the positions for a file.

I am class whose role is to trnasform this positions into comment entities attached to the right entity in the file.

I'll check multiple things:
- If single line comments follow each other I'll merge them
- If a comment is one line before the declaration of an entity, I'll attach it to this entity
- If a comment is on the smae line than the declaration of a variable I'll attach it to this entity
- If a comment is just inside an entity, I'll attach it to it
"
Class {
	#name : 'FamixPythonCommentsImporter',
	#superclass : 'Object',
	#instVars : [
		'visitor',
		'fileNode',
		'entitiesInFile'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'instance creation' }
FamixPythonCommentsImporter class >> importCommentsOf: aFileNode visitor: aPythonImporterVisitor [

	^ self new
		  visitor: aPythonImporterVisitor;
		  fileNode: aFileNode;
		  import
]

{ #category : 'instance creation' }
FamixPythonCommentsImporter class >> visitor: aPythonImporterVisitor fileNode: aFileNode [

	^ self new
		  visitor: aPythonImporterVisitor;
		  fileNode: aFileNode;
		  yourself
]

{ #category : 'actions' }
FamixPythonCommentsImporter >> createCommentFor: anEntity from: start to: stop [

	| comment |
	comment := self model newComment.
	comment commentedEntity: anEntity.
	visitor
		setSourceAnchorTo: comment
		fileName: (visitor relativeFilePath: fileNode)
		start: start
		end: stop.
	^ comment
]

{ #category : 'actions' }
FamixPythonCommentsImporter >> createMultilineCommentFromInterval: commentInterval [

	"Before checking if the comment is inside an entity, we check that it is not right before the declaration of an entity."
	(self entityFollowingComment: commentInterval) ifNotNil: [ :entity | ^ self createCommentFor: entity from: commentInterval first to: commentInterval second ].

	^ self entitiesInFile
		  detect: [ :entity | entity sourceAnchor includesInterval: commentInterval ]
		  ifFound: [ :entity | self createCommentFor: entity from: commentInterval first to: commentInterval second ]
		  ifNone: [ self error: 'All comments should be at least in the top module/package.' ]
]

{ #category : 'actions' }
FamixPythonCommentsImporter >> createSingleLineCommentFromInterval: commentInterval [

	"First we look for comments that are right after the declaration of an entity on the same line."
	(self entityOnLineOfComment: commentInterval) ifNotNil: [ :entity | ^ self createCommentFor: entity from: commentInterval first to: commentInterval second ].

	"Before checking if the comment is inside an entity, we check that it is not right before the declaration of an entity."
	(self entityFollowingComment: commentInterval) ifNotNil: [ :entity | ^ self createCommentFor: entity from: commentInterval first to: commentInterval second ].

	^ self entitiesInFile
		  detect: [ :entity | entity sourceAnchor includesInterval: commentInterval ]
		  ifFound: [ :entity | self createCommentFor: entity from: commentInterval first to: commentInterval second ]
		  ifNone: [ self error: 'All comments should be at least in the top module/package.' ]
]

{ #category : 'accessing' }
FamixPythonCommentsImporter >> entitiesInFile [
	"Sorting by the number of characters allows us to have the most atomic entities first. Imagine we have an inner function in a function. If a comment is an the inner function, it is also in the function containing it. So we want to check the inner function first because it's the most inner entity that should have the comment attached."

	^ entitiesInFile ifNil: [ entitiesInFile := visitor currentEntity withAllChildren sorted: [ :entity | entity sourceAnchor numberOfCharacters ] ascending ]
]

{ #category : 'actions' }
FamixPythonCommentsImporter >> entityFollowingComment: commentInterval [
	"Return an entity declared right after the comment. For example:
	
	```
	# Function doing things
	def function():
	  pass
	```
	"
	"Take the entity right after the comment"
	((self entitiesInFile select: [ :entity | entity sourceAnchor startPos > commentInterval second ]) detectMin: [ :entity | entity sourceAnchor startPos ])
		ifNotNil: [ :entity | (fileNode hasOnlySpacesAndTabsBetween: commentInterval second + 1 and: entity sourceAnchor startPos - 1) ifTrue: [ ^ entity ] ].
	^ nil
]

{ #category : 'actions' }
FamixPythonCommentsImporter >> entityOnLineOfComment: commentInterval [
	"We check if the comment is on the same line than a variable declaration such as:
	
	`var = 31 # Number of bytes`
	"
	
	"Take the entity right before the comment"
	((self entitiesInFile select: [ :entity | entity isStructuralEntity and: [ entity sourceAnchor endPos < commentInterval first ] ])
		detectMax: [ :entity |
			"We take the start because comments are not considered part of the entites so we might have multiple entities with the same end pos if they are imbricated."
		 	entity sourceAnchor startPos ]) ifNotNil: [ :entity |
		(fileNode hasNoLineReturnBetween: entity sourceAnchor endPos + 1 and: commentInterval first - 1) ifTrue: [ ^ entity ] ].

	^ nil
]

{ #category : 'accessing' }
FamixPythonCommentsImporter >> fileNode [

	^ fileNode
]

{ #category : 'accessing' }
FamixPythonCommentsImporter >> fileNode: anObject [

	fileNode := anObject
]

{ #category : 'actions' }
FamixPythonCommentsImporter >> import [
	"Comments are not represented by nodes in SmaCC. A FileNode can return the intervals of the comments so we need to find to whose entity those comments are attached to.
	I also save strings that are comments into the #multilineComments property."

	fileNode comments ifNotEmpty: [ :commentIntervals |
		| intervals |
		"If we have two single line comments following each other, we can merge them."
		intervals := OrderedCollection new.
		commentIntervals do: [ :interval |
			intervals ifEmpty: [ intervals add: interval ] ifNotEmpty: [ "We can merge if we have only spaces and tabs between the comments."
				(fileNode hasOnlySpacesAndTabsBetween: intervals last second + 1 and: interval first - 1)
					ifTrue: [ intervals last at: 2 put: interval second ]
					ifFalse: [ intervals add: interval ] ] ].

		intervals do: [ :commentInterval | self createSingleLineCommentFromInterval: commentInterval ] ].

	fileNode multilineComments do: [ :interval | self createMultilineCommentFromInterval: interval ]
]

{ #category : 'accessing' }
FamixPythonCommentsImporter >> model [

	^ self visitor model
]

{ #category : 'accessing' }
FamixPythonCommentsImporter >> visitor [

	^ visitor
]

{ #category : 'accessing' }
FamixPythonCommentsImporter >> visitor: anObject [

	visitor := anObject
]
