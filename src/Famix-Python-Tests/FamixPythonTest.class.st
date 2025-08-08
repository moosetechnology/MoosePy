Class {
	#name : 'FamixPythonTest',
	#superclass : 'TestCase',
	#category : 'Famix-Python-Tests',
	#package : 'Famix-Python-Tests'
}

{ #category : 'tests' }
FamixPythonTest >> testPythonGeneratorIsUpToDate [

	| changes |
	changes := FamixPythonGenerator new changesToApply.
	self assert: changes isEmpty description: [
			'The generator ' , FamixPythonGenerator asString
			, ' is not in sync with its meta-model. Please, regenerate your MMs with `FamixMetamodelGenerator generateAllMetamodels`. List of changes: '
			, changes printString ]
]
