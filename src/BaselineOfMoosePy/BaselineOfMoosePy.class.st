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
			package: 'Famix-Python-Importer' with: [ spec requires: #( 'Famix-Python-Entities' 'PythonParser' ) ];
			package: 'Famix-Python-Importer-Tests' with: [ spec requires: #( 'Famix-Python-Importer' ) ].

		spec
			group: 'Core' with: #( 'Famix-Python-Entities' 'Famix-Python-Importer' 'Famix-Python-Importer-Tests');
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
		"For now the up to date version of Smacc is not compatible with the current MoosePy. We need to migrate it"
		spec
			repository: 'github://j-brant/SmaCC:6c3a65cfba8f3293316f57a4456646910d6197d5/src';
			loads: #( 'SmaCC_Python' 'SmaCC_Python_Tests' ) ]
]
