Class {
	#name : 'BaselineOfMoosePy',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMoosePy',
	#package : 'BaselineOfMoosePy'
}

{ #category : 'baselines' }
BaselineOfMoosePy >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self pythonParser: spec.

		spec
			package: 'Famix-Python-Entities';
			package: 'Famix-Python-Generator';
			package: 'MoosePy' with: [ spec requires: #( 'Famix-Python-Entities' 'PythonParser' ) ].

		spec
			group: 'Core' with: #( 'Famix-Python-Entities' 'MoosePy' );
			group: 'Generator' with: #( 'Core' 'Famix-Python-Generator' ) ].

	spec for: #NeedsFamix do: [
		spec baseline: 'Famix' with: [ spec repository: 'github://moosetechnology/Famix:development/src' ].
		spec
			package: 'Famix-Python-Entities' with: [ spec requires: #( Famix ) ];
			package: 'Famix-Python-Generator' with: [ spec requires: #( Famix ) ] ]
]

{ #category : 'accessing' }
BaselineOfMoosePy >> customProjectAttributes [

	'BaselineOfFamix' asPackageIfAbsent: [ ^ #( #NeedsFamix ) ].
	^ #(  )
]

{ #category : 'baselines' }
BaselineOfMoosePy >> pythonParser: spec [

	spec baseline: 'PythonParser' with: [
		spec
			repository: 'github://j-brant/SmaCC:master/src';
			loads: #( 'SmaCC_Python' 'SmaCC_Python_Tests' ) ]
]
