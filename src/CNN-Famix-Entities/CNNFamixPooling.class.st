Class {
	#name : #CNNFamixPooling,
	#superclass : #CNNFamixEntity,
	#instVars : [
		'#layer => FMOne type: #CNNFamixLayer opposite: #poolings'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixPooling class >> annotation [

	<FMClass: #Pooling super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixPooling >> invocation [
	"Relation named: #invocation type: #FamixPythonInvocation opposite: #pooling"

	<generated>
	<FMProperty: #invocation type: #FamixPythonInvocation opposite: #pooling>
	^ self attributeAt: #invocation ifAbsent: [ nil ]
]

{ #category : #accessing }
CNNFamixPooling >> invocation: anObject [

	<generated>
	(self attributeAt: #invocation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self invocation.
		self attributeAt: #invocation put: anObject.
		otherSide pooling: nil ]
	ifNotNil: [ 
		self attributeAt: #invocation put: anObject.
		anObject pooling: self ]
]

{ #category : #accessing }
CNNFamixPooling >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #poolings"

	<generated>
	<container>
	^ layer
]

{ #category : #accessing }
CNNFamixPooling >> layer: anObject [

	<generated>
	layer := anObject
]

{ #category : #navigation }
CNNFamixPooling >> layerGroup [
	<generated>
	<navigation: 'Layer'>
	^ MooseSpecializedGroup with: self layer
]
