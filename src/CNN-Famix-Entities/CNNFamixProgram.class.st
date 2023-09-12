Class {
	#name : #CNNFamixProgram,
	#superclass : #CNNFamixNamedEntity,
	#instVars : [
		'#type => FMProperty',
		'#layers => FMMany type: #CNNFamixLayer opposite: #program'
	],
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixProgram class >> annotation [

	<FMClass: #Program super: #CNNFamixNamedEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #adding }
CNNFamixProgram >> addLayer: anObject [
	<generated>
	^ self layers add: anObject
]

{ #category : #accessing }
CNNFamixProgram >> layers [
	"Relation named: #layers type: #CNNFamixLayer opposite: #program"

	<generated>
	<derived>
	^ layers
]

{ #category : #accessing }
CNNFamixProgram >> layers: anObject [

	<generated>
	layers value: anObject
]

{ #category : #navigation }
CNNFamixProgram >> layersGroup [
	<generated>
	<navigation: 'Layers'>
	^ MooseSpecializedGroup withAll: self layers asSet
]

{ #category : #accessing }
CNNFamixProgram >> type [

	<FMProperty: #type type: #String>
	<generated>
	<FMComment: 'Sequential or Fonctional model'>
	^ type
]

{ #category : #accessing }
CNNFamixProgram >> type: anObject [
	<generated>
	type := anObject
]
