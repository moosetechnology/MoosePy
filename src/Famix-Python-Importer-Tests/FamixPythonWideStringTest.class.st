Class {
	#name : 'FamixPythonWideStringTest',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'tests - comments' }
FamixPythonWideStringTest >> testCommentWithWideString [

	| comment |
	comment := self model allComments detect: [ :aComment | aComment sourceText beginsWith: '# Comment with wide string ぁ' ].

	self assert: comment class equals: FamixPythonComment.
	self assert: comment commentedEntity equals: (self moduleNamed: 'comments')
]
