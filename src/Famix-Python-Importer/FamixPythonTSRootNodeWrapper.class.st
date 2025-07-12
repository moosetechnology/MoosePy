Class {
	#name : 'FamixPythonTSRootNodeWrapper',
	#superclass : 'FamixPythonTSNodeWrapper',
	#instVars : [
		'source',
		'relativePath'
	],
	#category : 'Famix-Python-Importer-Importer',
	#package : 'Famix-Python-Importer',
	#tag : 'Importer'
}

{ #category : 'accessing' }
FamixPythonTSRootNodeWrapper >> relativePath [

	^ relativePath
]

{ #category : 'accessing' }
FamixPythonTSRootNodeWrapper >> relativePath: anObject [

	relativePath := anObject
]

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
