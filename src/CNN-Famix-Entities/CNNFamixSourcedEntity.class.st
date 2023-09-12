Class {
	#name : #CNNFamixSourcedEntity,
	#superclass : #CNNFamixEntity,
	#traits : 'FamixTSourceEntity',
	#classTraits : 'FamixTSourceEntity classTrait',
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixSourcedEntity class >> annotation [

	<FMClass: #SourcedEntity super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
CNNFamixSourcedEntity class >> isAbstract [

	<generated>
	^ self == CNNFamixSourcedEntity
]
