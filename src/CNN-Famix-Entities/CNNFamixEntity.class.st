Class {
	#name : #CNNFamixEntity,
	#superclass : #MooseEntity,
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
CNNFamixEntity class >> isAbstract [

	<generated>
	^ self == CNNFamixEntity
]

{ #category : #meta }
CNNFamixEntity class >> metamodel [

	<generated>
	^ CNNFamixModel metamodel
]
