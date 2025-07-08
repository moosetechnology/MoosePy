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
	#name : 'FamixPythonTSCommentsImporter',
	#superclass : 'Object',
	#instVars : [
		'visitor',
		'commentIntervals',
		'stringCommentIntervals',
		'entitiesInFile'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'instance creation' }
FamixPythonTSCommentsImporter class >> visitor: aPythonImporterVisitor [

	^ self new
		  visitor: aPythonImporterVisitor;
		  yourself
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> addCommentNode: aNode [

	commentIntervals add: (self intervalOf: aNode)
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> addStringNode: aNode [

	stringCommentIntervals add: (self intervalOf: aNode)
]

{ #category : 'actions' }
FamixPythonTSCommentsImporter >> createCommentFor: anEntity from: start to: stop [

	| comment |
	comment := self model newComment.
	comment commentedEntity: anEntity.
	visitor
		setSourceAnchorTo: comment
		fileName: visitor relativeFilePath
		start: start
		end: stop.
	^ comment
]

{ #category : 'actions' }
FamixPythonTSCommentsImporter >> createMultilineCommentFromInterval: commentInterval [ 

	"Before checking if the comment is inside an entity, we check that it is not right before the declaration of an entity."
	(self entityFollowingComment: commentInterval) ifNotNil: [ :entity | ^ self createCommentFor: entity from: commentInterval first to: commentInterval second ].

	^ self entitiesInFile
		  detect: [ :entity | entity sourceAnchor includesInterval: commentInterval ]
		  ifFound: [ :entity | self createCommentFor: entity from: commentInterval first to: commentInterval second ]
		  ifNone: [ self error: 'All comments should be at least in the top module/package.' ]
]

{ #category : 'actions' }
FamixPythonTSCommentsImporter >> createSingleLineCommentFromInterval: commentInterval [

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
FamixPythonTSCommentsImporter >> entitiesInFile [
	"Sorting by the number of characters allows us to have the most atomic entities first. Imagine we have an inner function in a function. If a comment is an the inner function, it is also in the function containing it. So we want to check the inner function first because it's the most inner entity that should have the comment attached."

	^ entitiesInFile ifNil: [ entitiesInFile := visitor currentEntity withAllChildren sorted: [ :entity | entity sourceAnchor numberOfCharacters ] ascending ]
]

{ #category : 'actions' }
FamixPythonTSCommentsImporter >> entityFollowingComment: commentInterval [
	"Return an entity declared right after the comment. For example:
	
	```
	# Function doing things
	def function():
	  pass
	```
	"
	"Take the entity right after the comment"
	((self entitiesInFile select: [ :entity | entity sourceAnchor startPos > commentInterval second ]) detectMin: [ :entity | entity sourceAnchor startPos ])
		ifNotNil: [ :entity | (self source hasOnlySpacesAndTabsBetween: commentInterval second + 1 and: entity sourceAnchor startPos - 1) ifTrue: [ ^ entity ] ].
	^ nil
]

{ #category : 'actions' }
FamixPythonTSCommentsImporter >> entityOnLineOfComment: commentInterval [
	"We check if the comment is on the same line than a variable declaration such as:
	
	`var = 31 # Number of bytes`
	"

	"Take the entity right before the comment"

	((self entitiesInFile select: [ :entity | entity isStructuralEntity and: [ entity sourceAnchor endPos < commentInterval first ] ]) detectMax: [ :entity | "We take the start because comments are not considered part of the entites so we might have multiple entities with the same end pos if they are imbricated."
		 entity sourceAnchor startPos ]) ifNotNil: [ :entity |
		(self source hasNoLineReturnBetween: entity sourceAnchor endPos + 1 and: commentInterval first - 1) ifTrue: [ ^ entity ] ].

	^ nil
]

{ #category : 'actions' }
FamixPythonTSCommentsImporter >> import [
	"Comments are not represented by nodes in SmaCC. A FileNode can return the intervals of the comments so we need to find to whose entity those comments are attached to.
	I also save strings that are comments into the #multilineComments property."

	commentIntervals ifNotEmpty: [
			| intervals |
			"If we have two single line comments following each other, we can merge them."
			intervals := OrderedCollection new.
			commentIntervals do: [ :interval |
					intervals ifEmpty: [ intervals add: interval ] ifNotEmpty: [ "We can merge if we have only spaces and tabs between the comments."
							(self source hasOnlySpacesAndTabsBetween: intervals last second + 1 and: interval first - 1)
								ifTrue: [ intervals last at: 2 put: interval second ]
								ifFalse: [ intervals add: interval ] ] ].

			intervals do: [ :commentInterval | visitor errorReport catch: Exception during: [ self createSingleLineCommentFromInterval: commentInterval ] ] ].

	stringCommentIntervals do: [ :interval | visitor errorReport catch: Exception during: [ self createMultilineCommentFromInterval: interval ] ]
]

{ #category : 'initialization' }
FamixPythonTSCommentsImporter >> initialize [

	super initialize.
	commentIntervals := OrderedCollection new.
	stringCommentIntervals := OrderedCollection new
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> intervalOf: aNode [

	^ {
		  aNode startPosition.
		  (aNode rootNode endPosition min: aNode endPosition + 1) "Take the line return. This might not work on files from windows since it's CRLF also we can have spaces before the line return. We should maybe do something more robust. Also, do not take it of we are at the end of the file." }
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> model [

	^ self visitor model
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> source [
	^ visitor sourceText
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> visitor [

	^ visitor
]

{ #category : 'accessing' }
FamixPythonTSCommentsImporter >> visitor: anObject [

	visitor := anObject
]
