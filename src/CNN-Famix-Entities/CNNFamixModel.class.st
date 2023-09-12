Class {
	#name : #CNNFamixModel,
	#superclass : #MooseModel,
	#traits : 'CNNFamixTEntityCreator + FamixPythonTEntityCreator',
	#classTraits : 'CNNFamixTEntityCreator classTrait + FamixPythonTEntityCreator classTrait',
	#category : #'CNN-Famix-Entities-Model'
}

{ #category : #accessing }
CNNFamixModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits' #'Famix-Python-Entities')
]

{ #category : #meta }
CNNFamixModel class >> annotation [
	<FMClass: #CNNFamixModel super: #MooseModel>
	<package: #'CNN-Famix-Entities'>
	<generated>
]
