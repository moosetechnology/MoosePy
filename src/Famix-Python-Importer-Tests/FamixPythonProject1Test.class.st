Class {
	#name : 'FamixPythonProject1Test',
	#superclass : 'FamixPythonAbstractImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'accessing' }
FamixPythonProject1Test class >> resources [

	^ { FamixPythonProject1TestResource }
]

{ #category : 'accessing' }
FamixPythonProject1Test >> model [

	^ FamixPythonProject1TestResource current model
]
