Class {
	#name : #CNNFamixActivation,
	#superclass : #CNNFamixEntity,
	#instVars : [
		'#layer => FMOne type: #CNNFamixLayer opposite: #activations'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixActivation class >> annotation [

	<FMClass: #Activation super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixActivation >> invocation [
	"Relation named: #invocation type: #FamixPythonInvocation opposite: #activation"

	<generated>
	<FMProperty: #invocation type: #FamixPythonInvocation opposite: #activation>
	^ self attributeAt: #invocation ifAbsent: [ nil ]
]

{ #category : #accessing }
CNNFamixActivation >> invocation: anObject [

	<generated>
	(self attributeAt: #invocation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self invocation.
		self attributeAt: #invocation put: anObject.
		otherSide activation: nil ]
	ifNotNil: [ 
		self attributeAt: #invocation put: anObject.
		anObject activation: self ]
]

{ #category : #accessing }
CNNFamixActivation >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #activations"

	<generated>
	<container>
	^ layer
]

{ #category : #accessing }
CNNFamixActivation >> layer: anObject [

	<generated>
	layer := anObject
]

{ #category : #navigation }
CNNFamixActivation >> layerGroup [
	<generated>
	<navigation: 'Layer'>
	^ MooseSpecializedGroup with: self layer
]
