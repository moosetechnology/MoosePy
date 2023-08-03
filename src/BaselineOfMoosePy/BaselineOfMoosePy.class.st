Class {
	#name : #BaselineOfMoosePy,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoosePy
}

{ #category : #accessing }
BaselineOfMoosePy >> baseline: spec [
	<baseline>
	
	spec baseline: 'SmaccPy' with: [ 
		spec repository: 'github://j-brant/SmaCC';
		loads: #('SmaCC_Python_Tests') ].
	
	spec package: 'MoosePy' with: [ spec requires: 'SmaccPy' ]
]
