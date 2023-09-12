Class {
	#name : #CNNFamixNamedEntity,
	#superclass : #CNNFamixEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixNamedEntity class >> annotation [

	<FMClass: #NamedEntity super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
CNNFamixNamedEntity class >> isAbstract [

	<generated>
	^ self == CNNFamixNamedEntity
]
