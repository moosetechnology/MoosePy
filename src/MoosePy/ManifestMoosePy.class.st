"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestMoosePy',
	#superclass : 'PackageManifest',
	#category : 'MoosePy-Manifest',
	#package : 'MoosePy',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestMoosePy class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#MSEPythonToFamixImporterVisitor #createClass: #false)) #'2024-05-16T22:52:10.257-04:00') )
]
