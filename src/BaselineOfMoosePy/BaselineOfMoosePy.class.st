Class {
	#name : #BaselineOfMoosePy,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoosePy
}

{ #category : #baselines }
BaselineOfMoosePy >> baseline: spec [

	<baseline>

	spec for: #common do: [
		spec description: 'MoosePy'.
		self dependencies: spec.
		self packages: spec.
		self groups: spec
	]
]

{ #category : #baselines }
BaselineOfMoosePy >> dependencies: spec [

	spec baseline: 'SmaCC-Python' with: [
		spec
			repository: 'github://j-brant/SmaCC';
			loads: #( 'SmaCC_Python' 'SmaCC_Python_Tests' ) ].

	spec
		baseline: 'Famix'
		with: [ spec repository: 'github://moosetechnology/Famix:development/src' ]
]

{ #category : #baselines }
BaselineOfMoosePy >> groups: spec [

	^ spec
		  group: 'Core' with: #( 'Famix-Python-Entities' 'MoosePy' ) ;
		  group: 'Generator' with: #( 'Core' 'Famix-Python-Generator' )
]

{ #category : #baselines }
BaselineOfMoosePy >> packages: spec [

	spec

		package: 'Famix-Python-Entities' with: [ spec requires: #( Famix ) ] ;
		package: 'Famix-Python-Generator' with: [ spec requires: #( Famix ) ] ;
		package: 'MoosePy' with: [ spec requires: #( 'Famix-Python-Entities' 'SmaCC-Python') ]
]
