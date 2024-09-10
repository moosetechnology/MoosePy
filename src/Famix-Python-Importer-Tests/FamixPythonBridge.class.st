Class {
	#name : 'FamixPythonBridge',
	#superclass : 'GitBridge',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'class initialization' }
FamixPythonBridge class >> initialize [
	SessionManager default registerSystemClassNamed: self name
]

{ #category : 'accessing' }
FamixPythonBridge class >> parsingExamples [
	^ self resources / 'examples' 
]

{ #category : 'accessing' }
FamixPythonBridge class >> resources [
	^ self root / 'resources'
]
