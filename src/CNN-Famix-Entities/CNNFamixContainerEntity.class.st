Class {
	#name : #CNNFamixContainerEntity,
	#superclass : #CNNFamixEntity,
	#category : #'CNN-Famix-Entities-Entities'
}

{ #category : #meta }
CNNFamixContainerEntity class >> annotation [

	<FMClass: #ContainerEntity super: #CNNFamixEntity>
	<package: #'CNN-Famix-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
CNNFamixContainerEntity class >> isAbstract [

	<generated>
	^ self == CNNFamixContainerEntity
]
