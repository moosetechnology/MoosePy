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
		self
			gitBridge: spec;
			pythonParser: spec;
			symbolResolver: spec.

		spec
			package: 'Famix-Python-Entities';
			package: 'Famix-Python-Generator';
			package: 'Famix-Python-Importer' with: [ spec requires: #( 'Famix-Python-Entities' 'PythonParser' 'SymbolResolver') ];
			package: 'Famix-Python-Importer-Tests' with: [ spec requires: #( 'Famix-Python-Importer' 'GitBridge' ) ].

		spec
			group: 'Core' with: #( 'Famix-Python-Entities' 'Famix-Python-Importer' 'Famix-Python-Importer-Tests' );
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
BaselineOfMoosePy >> gitBridge: spec [

	spec baseline: 'GitBridge' with: [ spec repository: 'github://jecisc/GitBridge:v1.x.x/src' ]
]

{ #category : 'baselines' }
BaselineOfMoosePy >> pythonParser: spec [

	spec baseline: 'PythonParser' with: [
		spec
			repository: 'github://j-brant/SmaCC:master/src';
			loads: #( 'SmaCC_Python' 'SmaCC_Python_Tests' ) ]
]

{ #category : 'baselines' }
BaselineOfMoosePy >> symbolResolver: spec [

	spec baseline: 'SymbolResolver' with: [ spec repository: 'github://jecisc/SymbolResolver:main/src' ]
]
