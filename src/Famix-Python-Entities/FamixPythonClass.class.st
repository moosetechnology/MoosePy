Class {
	#name : #FamixPythonClass,
	#superclass : #FamixPythonType,
	#traits : 'FamixTClass + FamixTImportable + FamixTWithAnnotationInstances + FamixTWithImports',
	#classTraits : 'FamixTClass classTrait + FamixTImportable classTrait + FamixTWithAnnotationInstances classTrait + FamixTWithImports classTrait',
	#category : #'Famix-Python-Entities-Entities'
}

{ #category : #meta }
FamixPythonClass class >> annotation [

	<FMClass: #Class super: #FamixPythonType>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]
