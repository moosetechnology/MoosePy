"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestMoosePythonImporter',
	#superclass : 'PackageManifest',
	#category : 'Moose-Python-Importer-Manifest',
	#package : 'Moose-Python-Importer',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestMoosePythonImporter class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#FamixPythonImporterVisitor #createClass: #false)) #'2024-05-16T22:52:10.257-04:00') )
]
