Class {
	#name : 'FamixTSRootNodeWrapper',
	#superclass : 'FamixTSNodeWrapper',
	#instVars : [
		'source',
		'relativePath'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'visiting' }
FamixTSRootNodeWrapper >> accept: aVisitor [

	self
		relativePath: aVisitor relativeFilePath;
		source: aVisitor sourceText.
	super accept: aVisitor
]

{ #category : 'accessing' }
FamixTSRootNodeWrapper >> relativePath [

	^ relativePath
]

{ #category : 'accessing' }
FamixTSRootNodeWrapper >> relativePath: anObject [

	relativePath := anObject
]

{ #category : 'accessing' }
FamixTSRootNodeWrapper >> rootNode [

	^ self
]

{ #category : 'accessing' }
FamixTSRootNodeWrapper >> source [

	^ source
]

{ #category : 'accessing' }
FamixTSRootNodeWrapper >> source: anObject [
	source := anObject
]
