Class {
	#name : #CNNFamixFlatten,
	#superclass : #CNNFamixEntity,
	#instVars : [
		'#layer => FMOne type: #CNNFamixLayer opposite: #flatten'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixFlatten class >> annotation [

	<FMClass: #Flatten super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixFlatten >> invocation [
	"Relation named: #invocation type: #FamixPythonInvocation opposite: #flatten"

	<generated>
	<FMProperty: #invocation type: #FamixPythonInvocation opposite: #flatten>
	^ self attributeAt: #invocation ifAbsent: [ nil ]
]

{ #category : #accessing }
CNNFamixFlatten >> invocation: anObject [

	<generated>
	(self attributeAt: #invocation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self invocation.
		self attributeAt: #invocation put: anObject.
		otherSide flatten: nil ]
	ifNotNil: [ 
		self attributeAt: #invocation put: anObject.
		anObject flatten: self ]
]

{ #category : #accessing }
CNNFamixFlatten >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #flatten"

	<generated>
	<container>
	<derived>
	^ layer
]

{ #category : #accessing }
CNNFamixFlatten >> layer: anObject [

	<generated>
	layer := anObject
]

{ #category : #navigation }
CNNFamixFlatten >> layerGroup [
	<generated>
	<navigation: 'Layer'>
	^ MooseSpecializedGroup with: self layer
]
