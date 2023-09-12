Class {
	#name : #CNNFamixRegularization,
	#superclass : #CNNFamixEntity,
	#instVars : [
		'#layer => FMOne type: #CNNFamixLayer opposite: #regularizations'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixRegularization class >> annotation [

	<FMClass: #Regularization super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixRegularization >> invocation [
	"Relation named: #invocation type: #FamixPythonInvocation opposite: #regularization"

	<generated>
	<FMProperty: #invocation type: #FamixPythonInvocation opposite: #regularization>
	^ self attributeAt: #invocation ifAbsent: [ nil ]
]

{ #category : #accessing }
CNNFamixRegularization >> invocation: anObject [

	<generated>
	(self attributeAt: #invocation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self invocation.
		self attributeAt: #invocation put: anObject.
		otherSide regularization: nil ]
	ifNotNil: [ 
		self attributeAt: #invocation put: anObject.
		anObject regularization: self ]
]

{ #category : #accessing }
CNNFamixRegularization >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #regularizations"

	<generated>
	<container>
	^ layer
]

{ #category : #accessing }
CNNFamixRegularization >> layer: anObject [

	<generated>
	layer := anObject
]

{ #category : #navigation }
CNNFamixRegularization >> layerGroup [
	<generated>
	<navigation: 'Layer'>
	^ MooseSpecializedGroup with: self layer
]
