Class {
	#name : 'FamixTSNodeWrapper',
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
FamixTSNodeWrapper >> accept: aTSVisitor [

	^ aTSVisitor visitNode: self
]

{ #category : 'testing' }
FamixTSNodeWrapper >> assignationNode [

	self type = #assignment ifTrue: [ ^ self ].
	^ self parent ifNotNil: [ self parent assignationNode ]
]

{ #category : 'api' }
FamixTSNodeWrapper >> collectFieldNameOfNamedChild [

	^ children ifNil: [
			  children := tsNode collectFieldNameOfNamedChild.

			  children associationsDo: [ :association |
					  | value |
					  value := association value.
					  association value: (value isCollection
							   ifTrue: [
									   value collect: [ :node |
											   FamixTSNodeWrapper new
												   tsNode: node;
												   parent: self;
												   yourself ] ]
							   ifFalse: [
									   FamixTSNodeWrapper new
										   tsNode: value;
										   parent: self;
										   yourself ]) ].
			  children ]
]

{ #category : 'api' }
FamixTSNodeWrapper >> collectNamedChild [

	^ self collectFieldNameOfNamedChild values flattened
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> completeSource [
	^ self rootNode source
]

{ #category : 'collection' }
FamixTSNodeWrapper >> detectNamedChild: name ifNone: aConstantBlockClosure [

	^ self collectNamedChild
		  detect: [ :node | node type = name ]
		  ifNone: aConstantBlockClosure
]

{ #category : 'reflective operations' }
FamixTSNodeWrapper >> doesNotUnderstand: aMessage [
	"Forward message to decoree except if it's a node by field access"

	aMessage selector first = $_ ifTrue: [ ^ self nodeChildByFieldName: aMessage selector allButFirst ifAbsent: [ nil ] ].

	^ aMessage sendTo: tsNode
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> endPosition [

	^ self source positionFromTSPoint: tsNode endPoint
]

{ #category : 'inspector' }
FamixTSNodeWrapper >> fieldsInspectorExtension: aBuilder [

	<inspectorPresentationOrder: 900.5 title: 'Fields'>
	^ aBuilder newTable
		  addStyle: 'stList';
		  addColumn: (SpStringTableColumn new
				   title: 'Key';
				   evaluated: [ :each | each key ];
				   formatted: [ :key | StObjectPrinter asTruncatedTextFrom: key ];
				   beSortable);
		  addColumn: (SpStringTableColumn new
				   title: 'Value';
				   evaluated: [ :each | each value ];
				   formatted: [ :value | StObjectPrinter asTruncatedTextFrom: value ];
				   beSortable);
		  items: (self collectFieldNameOfNamedChild associations collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		  yourself
]

{ #category : 'inspector' }
FamixTSNodeWrapper >> fullSourceInspectorExtension: aBuilder [

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
FamixTSNodeWrapper >> includesChild: aNode [

	self = aNode ifTrue: [ ^ true ].
	^ self collectNamedChild
		  detect: [ :node | node = aNode or: [ node includesChild: aNode ] ]
		  ifFound: [ :node | true ]
		  ifNone: [ false ]
]

{ #category : 'testing' }
FamixTSNodeWrapper >> isLeftSideOfAssignation [

	self parentsDo: [ :node | node type = #assignment ifTrue: [ ^ node _left includesChild: self ] ].
	^ false
]

{ #category : 'testing' }
FamixTSNodeWrapper >> isTSNode [

	^ true
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> nodeChildByFieldName: aName [

	^ self collectFieldNameOfNamedChild at: aName
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> nodeChildByFieldName: aName ifAbsent: aBlock [

	^ self collectFieldNameOfNamedChild at: aName ifAbsent: aBlock
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> nodeChildByFieldName: aName ifPresent: block ifAbsent: aBlock [

	^ self collectFieldNameOfNamedChild
		  at: aName
		  ifPresent: block
		  ifAbsent: aBlock
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> parent [

	^ parent
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> parent: anObject [

	parent := anObject
]

{ #category : 'enumerating' }
FamixTSNodeWrapper >> parentsDo: aBlock [

	^ self parent ifNotNil: [ :parentNode |
			  aBlock value: parentNode.
			  parentNode parentsDo: aBlock ]
]

{ #category : 'printing' }
FamixTSNodeWrapper >> printOn: aStream [

	aStream nextPutAll: 'Wrapped: '.
	tsNode printOn: aStream
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> relativePath [

	^ self rootNode relativePath
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> rootNode [
	^ self parent rootNode
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> source [
	^ self rootNode source
]

{ #category : 'inspector' }
FamixTSNodeWrapper >> sourceInspectorExtension: builder [

	<inspectorPresentationOrder: 901 title: 'Source'>
	^ builder newCode
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self sourceText;
		  beNotEditable
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> sourceText [

	^ tsNode textFromSourceText: self completeSource
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> startPosition [

	^ (self source positionFromTSPoint: tsNode startPoint) + 1
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> tsNode [

	^ tsNode
]

{ #category : 'accessing' }
FamixTSNodeWrapper >> tsNode: anObject [

	tsNode := anObject
]

{ #category : 'inspector' }
FamixTSNodeWrapper >> tsTreeExtension: builder [

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
