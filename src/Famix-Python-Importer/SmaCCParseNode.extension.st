Extension { #name : 'SmaCCParseNode' }

{ #category : '*Famix-Python-Importer' }
SmaCCParseNode >> fullSourceInspectorExtension [

	<inspectorPresentationOrder: 902 title: 'Full source'>
	^ SpCodePresenter new
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self completeSource asString;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (self startPosition to: self stopPosition + 1);
				   yourself);
		  beNotEditable
]

{ #category : '*Famix-Python-Importer' }
SmaCCParseNode >> multilineComments [

	^ self attributeNamed: #multilineComments ifAbsentPut: [ OrderedCollection new ]
]

{ #category : '*Famix-Python-Importer' }
SmaCCParseNode >> multilineComments: anObject [
	self attributeNamed: #multilineComments put: anObject
]

{ #category : '*Famix-Python-Importer' }
SmaCCParseNode >> sourceInspectorExtension [

	<inspectorPresentationOrder: 901 title: 'Source'>
	^ SpCodePresenter new
		  withoutSyntaxHighlight;
		  withLineNumbers;
		  text: self source;
		  beNotEditable
]

{ #category : '*Famix-Python-Importer' }
SmaCCParseNode >> startPosition: aNumber [

	^ self attributeNamed: #startPosition put: aNumber
]
