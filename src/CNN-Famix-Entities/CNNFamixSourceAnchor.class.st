Class {
	#name : #CNNFamixSourceAnchor,
	#superclass : #CNNFamixEntity,
	#traits : 'FamixTSourceAnchor',
	#classTraits : 'FamixTSourceAnchor classTrait',
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixSourceAnchor class >> annotation [

	<FMClass: #SourceAnchor super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
CNNFamixSourceAnchor class >> isAbstract [

	<generated>
	^ self == CNNFamixSourceAnchor
]
