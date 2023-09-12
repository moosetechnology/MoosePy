Class {
	#name : #CNNFamixDense,
	#superclass : #CNNFamixEntity,
	#instVars : [
		'#layer => FMOne type: #CNNFamixLayer opposite: #dense'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixDense class >> annotation [

	<FMClass: #Dense super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixDense >> invocation [
	"Relation named: #invocation type: #FamixPythonInvocation opposite: #dense"

	<generated>
	<FMProperty: #invocation type: #FamixPythonInvocation opposite: #dense>
	^ self attributeAt: #invocation ifAbsent: [ nil ]
]

{ #category : #accessing }
CNNFamixDense >> invocation: anObject [

	<generated>
	(self attributeAt: #invocation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self invocation.
		self attributeAt: #invocation put: anObject.
		otherSide dense: nil ]
	ifNotNil: [ 
		self attributeAt: #invocation put: anObject.
		anObject dense: self ]
]

{ #category : #accessing }
CNNFamixDense >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #dense"

	<generated>
	<container>
	<derived>
	^ layer
]

{ #category : #accessing }
CNNFamixDense >> layer: anObject [

	<generated>
	layer := anObject
]

{ #category : #navigation }
CNNFamixDense >> layerGroup [
	<generated>
	<navigation: 'Layer'>
	^ MooseSpecializedGroup with: self layer
]
