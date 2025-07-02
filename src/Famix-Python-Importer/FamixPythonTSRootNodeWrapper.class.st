Class {
	#name : 'FamixPythonTSRootNodeWrapper',
	#superclass : 'FamixPythonTSNodeWrapper',
	#instVars : [
		'source'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'accessing' }
FamixPythonTSRootNodeWrapper >> rootNode [

	^ self
]

{ #category : 'accessing' }
FamixPythonTSRootNodeWrapper >> source [

	^ source
]

{ #category : 'accessing' }
FamixPythonTSRootNodeWrapper >> source: anObject [
	source := anObject
]
