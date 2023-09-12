Class {
	#name : #CNNPythonDetectorFromFileTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'designSmellDetector'
	],
	#category : #'DL-Python-Tests'
}

{ #category : #tests }
CNNPythonDetectorFromFileTest >> createCNNModel: aFamixModel [

	| cnnImporter |
	cnnImporter := CNNPythonImporter new.
	^ cnnImporter createCNNModel: aFamixModel
]

{ #category : #tests }
CNNPythonDetectorFromFileTest >> createFamixModelFromFile: aPath [

	| pyFamixVisior |
	pyFamixVisior := MSEPythonToFamixImporterVisitor new.
	(PythonParser parseWithErrors: (pyFamixVisior getFileContent: aPath))
		acceptVisitor: pyFamixVisior.
	^ pyFamixVisior model
]

{ #category : #tests }
CNNPythonDetectorFromFileTest >> setUp [

	designSmellDetector := CNNPythonDetector new
]

{ #category : #tests }
CNNPythonDetectorFromFileTest >> testParseThenModelingFromFile [

	| famixModel cnnModel |
	famixModel := self createFamixModelFromFile:
		              '/Users/aurelikama/Documents/Projet/These/parserPythonToJson/sample_design_smell/layers_formation/gh_non_dominating_dow_sampling.py'.

	cnnModel := self createCNNModel: famixModel.

	self
		assert:
		(designSmellDetector hasBiasWithBatchNormalization: cnnModel)
		equals: true
]
