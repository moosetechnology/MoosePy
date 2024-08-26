Class {
	#name : 'FamixPythonModel',
	#superclass : 'MooseModel',
	#traits : 'FamixPythonTEntityCreator',
	#classTraits : 'FamixPythonTEntityCreator classTrait',
	#category : 'Famix-Python-Entities-Model',
	#package : 'Famix-Python-Entities',
	#tag : 'Model'
}

{ #category : 'accessing' }
FamixPythonModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits')
]

{ #category : 'meta' }
FamixPythonModel class >> annotation [
	<FMClass: #FamixPythonModel super: #MooseModel>
	<package: #'Famix-Python-Entities'>
	<generated>
]
