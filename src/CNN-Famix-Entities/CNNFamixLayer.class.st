Class {
	#name : #CNNFamixLayer,
	#superclass : #CNNFamixEntity,
	#traits : 'FamixTSourceEntity',
	#classTraits : 'FamixTSourceEntity classTrait',
	#instVars : [
		'#name => FMProperty',
		'#convolution => FMOne type: #CNNFamixConvolution opposite: #layer',
		'#dense => FMOne type: #CNNFamixDense opposite: #layer',
		'#flatten => FMOne type: #CNNFamixFlatten opposite: #layer',
		'#activations => FMMany type: #CNNFamixActivation opposite: #layer',
		'#poolings => FMMany type: #CNNFamixPooling opposite: #layer',
		'#regularizations => FMMany type: #CNNFamixRegularization opposite: #layer',
		'#program => FMOne type: #CNNFamixProgram opposite: #layers'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixLayer class >> annotation [

	<FMClass: #Layer super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #accessing }
CNNFamixLayer >> activations [
	"Relation named: #activations type: #CNNFamixActivation opposite: #layer"

	<generated>
	<derived>
	^ activations
]

{ #category : #accessing }
CNNFamixLayer >> activations: anObject [

	<generated>
	activations value: anObject
]

{ #category : #navigation }
CNNFamixLayer >> activationsGroup [
	<generated>
	<navigation: 'Activations'>
	^ MooseSpecializedGroup withAll: self activations asSet
]

{ #category : #adding }
CNNFamixLayer >> addActivation: anObject [
	<generated>
	^ self activations add: anObject
]

{ #category : #adding }
CNNFamixLayer >> addInvocation: anObject [
	<generated>
	^ self invocations add: anObject
]

{ #category : #adding }
CNNFamixLayer >> addPooling: anObject [
	<generated>
	^ self poolings add: anObject
]

{ #category : #adding }
CNNFamixLayer >> addRegularization: anObject [
	<generated>
	^ self regularizations add: anObject
]

{ #category : #accessing }
CNNFamixLayer >> convolution [
	"Relation named: #convolution type: #CNNFamixConvolution opposite: #layer"

	<generated>
	^ convolution
]

{ #category : #accessing }
CNNFamixLayer >> convolution: anObject [

	<generated>
	convolution := anObject
]

{ #category : #navigation }
CNNFamixLayer >> convolutionGroup [
	<generated>
	<navigation: 'Convolution'>
	^ MooseSpecializedGroup with: self convolution
]

{ #category : #accessing }
CNNFamixLayer >> dense [
	"Relation named: #dense type: #CNNFamixDense opposite: #layer"

	<generated>
	^ dense
]

{ #category : #accessing }
CNNFamixLayer >> dense: anObject [

	<generated>
	dense := anObject
]

{ #category : #navigation }
CNNFamixLayer >> denseGroup [
	<generated>
	<navigation: 'Dense'>
	^ MooseSpecializedGroup with: self dense
]

{ #category : #accessing }
CNNFamixLayer >> flatten [
	"Relation named: #flatten type: #CNNFamixFlatten opposite: #layer"

	<generated>
	^ flatten
]

{ #category : #accessing }
CNNFamixLayer >> flatten: anObject [

	<generated>
	flatten := anObject
]

{ #category : #navigation }
CNNFamixLayer >> flattenGroup [
	<generated>
	<navigation: 'Flatten'>
	^ MooseSpecializedGroup with: self flatten
]

{ #category : #accessing }
CNNFamixLayer >> invocations [
	"Relation named: #invocations type: #FamixPythonInvocation opposite: #layer"

	<generated>
	<derived>
	<FMProperty: #invocations type: #FamixPythonInvocation opposite: #layer>
	^ self attributeAt: #invocations ifAbsentPut: [ FMMultivalueLink on: self opposite: #layer: ]
]

{ #category : #accessing }
CNNFamixLayer >> invocations: anObject [

	<generated>
	self invocations value: anObject
]

{ #category : #navigation }
CNNFamixLayer >> invocationsGroup [
	<generated>
	<navigation: 'Invocations'>
	^ MooseSpecializedGroup withAll: self invocations asSet
]

{ #category : #accessing }
CNNFamixLayer >> name [

	<FMProperty: #name type: #String>
	<generated>
	<FMComment: 'layer name >> L1'>
	^ name
]

{ #category : #accessing }
CNNFamixLayer >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
CNNFamixLayer >> poolings [
	"Relation named: #poolings type: #CNNFamixPooling opposite: #layer"

	<generated>
	<derived>
	^ poolings
]

{ #category : #accessing }
CNNFamixLayer >> poolings: anObject [

	<generated>
	poolings value: anObject
]

{ #category : #navigation }
CNNFamixLayer >> poolingsGroup [
	<generated>
	<navigation: 'Poolings'>
	^ MooseSpecializedGroup withAll: self poolings asSet
]

{ #category : #accessing }
CNNFamixLayer >> program [
	"Relation named: #program type: #CNNFamixProgram opposite: #layers"

	<generated>
	<container>
	^ program
]

{ #category : #accessing }
CNNFamixLayer >> program: anObject [

	<generated>
	program := anObject
]

{ #category : #navigation }
CNNFamixLayer >> programGroup [
	<generated>
	<navigation: 'Program'>
	^ MooseSpecializedGroup with: self program
]

{ #category : #accessing }
CNNFamixLayer >> regularizations [
	"Relation named: #regularizations type: #CNNFamixRegularization opposite: #layer"

	<generated>
	<derived>
	^ regularizations
]

{ #category : #accessing }
CNNFamixLayer >> regularizations: anObject [

	<generated>
	regularizations value: anObject
]

{ #category : #navigation }
CNNFamixLayer >> regularizationsGroup [
	<generated>
	<navigation: 'Regularizations'>
	^ MooseSpecializedGroup withAll: self regularizations asSet
]
