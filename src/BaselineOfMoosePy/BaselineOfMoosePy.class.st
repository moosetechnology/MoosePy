Class {
	#name : #BaselineOfMoosePy,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoosePy
}

{ #category : #accessing }
BaselineOfMoosePy >> baseline: spec [

	<baseline>
	spec baseline: 'PythonParser' with: [
		spec
			repository: 'github://j-brant/SmaCC';
			loads: #( 'SmaCC_Python' 'SmaCC_Python_Tests' ) ].

	spec
		baseline: 'FamixPythonImporter'
		with: [ spec repository: 'github://aurpur/famixPythonImporter' ].

	spec
		package: 'MoosePy'
		with: [ spec requires: #( 'PythonParser' 'FamixPythonImporter' ) ]
]
