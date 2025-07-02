Class {
	#name : 'FamixPythonTSNodeWrapper',
	#superclass : 'Object',
	#instVars : [
		'tsNode',
		'parent',
		'children'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'visiting' }
FamixPythonTSNodeWrapper >> accept: aTSVisitor [

	^ aTSVisitor visitNode: self
]

{ #category : 'api' }
FamixPythonTSNodeWrapper >> collectFieldNameOfNamedChild [

	^ children ifNil: [
			  children := tsNode collectFieldNameOfNamedChild.

			  children associationsDo: [ :association |
					  | value |
					  value := association value.
					  association value: (value isCollection
							   ifTrue: [
									   value collect: [ :node |
											   FamixPythonTSNodeWrapper new
												   tsNode: node;
												   parent: self;
												   yourself ] ]
							   ifFalse: [
									   FamixPythonTSNodeWrapper new
										   tsNode: value;
										   parent: self;
										   yourself ]) ].
			  children ]
]

{ #category : 'api' }
FamixPythonTSNodeWrapper >> collectNamedChild [

	^ self collectFieldNameOfNamedChild values flattened
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> completeSource [
	^ self rootNode source
]

{ #category : 'collection' }
FamixPythonTSNodeWrapper >> detectNamedChild: name ifNone: aConstantBlockClosure [

	^ self collectNamedChild
		  detect: [ :node | node type = name ]
		  ifNone: aConstantBlockClosure
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

{ #category : 'inspector' }
FamixPythonTSNodeWrapper >> fullSourceInspectorExtension: aBuilder [

	<inspectorPresentationOrder: 902 title: 'Full source'>
	^ aBuilder newCode
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self source asString;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (self startPosition to: self endPosition + 1);
				   yourself);
		  beNotEditable
]

{ #category : 'testing' }
FamixPythonTSNodeWrapper >> isTSNode [

	^ true
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> nodeChildByFieldName: aName [

	^ self collectFieldNameOfNamedChild at: aName
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> nodeChildByFieldName: aName ifAbsent: aBlock [

	^ self collectFieldNameOfNamedChild at: aName ifAbsent: aBlock
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> nodeChildByFieldName: aName ifPresent: block ifAbsent: aBlock [

	^ self collectFieldNameOfNamedChild
		  at: aName
		  ifPresent: block
		  ifAbsent: aBlock
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> parent [

	^ parent
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> parent: anObject [

	parent := anObject
]

{ #category : 'printing' }
FamixPythonTSNodeWrapper >> printOn: aStream [

	aStream nextPutAll: 'Wrapped '.
	tsNode printOn: aStream
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> rootNode [
	^ self parent rootNode
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> source [
	^ self rootNode source
]

{ #category : 'inspector' }
FamixPythonTSNodeWrapper >> sourceInspectorExtension: builder [

	<inspectorPresentationOrder: 901 title: 'Source'>
	^ builder newCode
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self sourceText;
		  beNotEditable
]

{ #category : 'accessing' }
FamixPythonTSNodeWrapper >> sourceText [

	^ tsNode textFromSourceText: self completeSource
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

{ #category : 'inspector' }
FamixPythonTSNodeWrapper >> tsTreeExtension: builder [

	<inspectorPresentationOrder: 15 title: 'TS Tree'>
	^ (builder instantiate: SpTreeTablePresenter)
		  addColumn: (SpCompositeTableColumn new
				   addColumn: (SpStringTableColumn evaluated: #type);
				   yourself);
		  children: [ :aTSNode | aTSNode collectNamedChild ];
		  roots: { self };
		  beResizable;
		expandAll
]
