Class {
	#name : 'FamixPythonTSNodeWrapper',
	#superclass : 'Object',
	#instVars : [
		'tsNode'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'visiting' }
FamixPythonTSNodeWrapper >> accept: aTSVisitor [

	^ aTSVisitor visitNode: self
]

{ #category : 'reflective operations' }
FamixPythonTSNodeWrapper >> doesNotUnderstand: aMessage [
	"Forward message to decoree"

	^ aMessage sendTo: tsNode
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> endPosition [

	^ self source positionFromTSPoint: tsNode endPoint
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> rootNode [
	^ self parent rootNode
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> source [
	^ self rootNode source
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> startPosition [

	^ (self source positionFromTSPoint: tsNode startPoint) + 1
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> tsNode [

	^ tsNode
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> tsNode: anObject [

	tsNode := anObject
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> tsTreeExtension: builder [

	<inspectorPresentationOrder: 15 title: 'TS Tree'>
	^ (builder instantiate: SpTreeTablePresenter)
		  addColumn: (SpCompositeTableColumn new
				   addColumn: (SpStringTableColumn evaluated: #type);
				   yourself);
		  children: [ :aTSNode | (1 to: aTSNode namedChildCount) collect: [ :idx | aTSNode namedChildAt: idx ] ];
		  roots: { self };
		  beResizable
]
