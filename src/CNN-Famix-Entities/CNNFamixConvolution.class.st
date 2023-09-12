Class {
	#name : #CNNFamixConvolution,
	#superclass : #CNNFamixEntity,
	#instVars : [
		'#filters => FMProperty',
		'#kernelSize => FMProperty',
		'#layer => FMOne type: #CNNFamixLayer opposite: #convolution',
		'#useBias => FMProperty',
		'#homogeneous',
		'#itsHomogeneous',
		'#isStartOfBlock'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixConvolution class >> annotation [

	<FMClass: #Convolution super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixConvolution >> filters [

	<FMProperty: #filters type: #String defaultValue: true>
	<generated>
	<FMComment: 'layer convolution  filters >> 32'>
	^ filters ifNil: [ filters := true ]
]

{ #category : #accessing }
CNNFamixConvolution >> filters: anObject [
	<generated>
	filters := anObject
]

{ #category : #accessing }
CNNFamixConvolution >> invocation [
	"Relation named: #invocation type: #FamixPythonInvocation opposite: #convolution"

	<generated>
	<FMProperty: #invocation type: #FamixPythonInvocation opposite: #convolution>
	^ self attributeAt: #invocation ifAbsent: [ nil ]
]

{ #category : #accessing }
CNNFamixConvolution >> invocation: anObject [

	<generated>
	(self attributeAt: #invocation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self invocation.
		self attributeAt: #invocation put: anObject.
		otherSide convolution: nil ]
	ifNotNil: [ 
		self attributeAt: #invocation put: anObject.
		anObject convolution: self ]
]

{ #category : #accessing }
CNNFamixConvolution >> kernelSize [

	<FMProperty: #kernelSize type: #String>
	<generated>
	<FMComment: 'layer convolution  kernelSize >> 3'>
	^ kernelSize
]

{ #category : #accessing }
CNNFamixConvolution >> kernelSize: anObject [
	<generated>
	kernelSize := anObject
]

{ #category : #accessing }
CNNFamixConvolution >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #convolution"

	<generated>
	<container>
	<derived>
	^ layer
]

{ #category : #accessing }
CNNFamixConvolution >> layer: anObject [

	<generated>
	layer := anObject
]

{ #category : #navigation }
CNNFamixConvolution >> layerGroup [
	<generated>
	<navigation: 'Layer'>
	^ MooseSpecializedGroup with: self layer
]

{ #category : #accessing }
CNNFamixConvolution >> useBias [

	<FMProperty: #useBias type: #Boolean>
	<generated>
	<FMComment: 'layer convolution  useBias >> [true|false]'>
	^ useBias
]

{ #category : #accessing }
CNNFamixConvolution >> useBias: anObject [
	<generated>
	useBias := anObject
]
