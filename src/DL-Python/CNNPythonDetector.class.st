Class {
	#name : #CNNPythonDetector,
	#superclass : #Object,
	#instVars : [
		'visitor',
		'allLayers',
		'importerCNN'
	],
	#category : #'DL-Python-Detectors'
}

{ #category : #inspecting }
CNNPythonDetector >> batchNormsInLayer: aLayer [

	^ aLayer regularizations select: [ :regularization |
		  self isBatchNorm:  regularization ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> convolutions: aModel [

	| results |
	results := OrderedCollection new.

	aModel layers do: [ :layer |
		( layer hasConvolution) ifTrue: [
			results add: layer convolution ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainBatchNorm: aLayer [

	^ (self batchNormsInLayer: aLayer) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainConvolution: aLayer [

	^ aLayer convolution isNotNil
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainDropout: aLayer [

	^ (self dropoutsInLayer: aLayer ) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> doesLayerContainPooling: aLayer [

	^ ( aLayer poolings) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> dropoutsInLayer: aLayer [

	^ (aLayer regularizations select: [ :regularization |
		   self isDropout: regularization ])
]

{ #category : #inspecting }
CNNPythonDetector >> hasBiasWithBatchNormalization: aModel [


	^ (self layersWithBiasWithBatchNormalization: aModel layers)
		  isNotEmpty.
	
]

{ #category : #inspecting }
CNNPythonDetector >> hasHeterogeneousBlocks: aModel [

	^ (self homogeneousBlocks: aModel) size < 2
]

{ #category : #inspecting }
CNNPythonDetector >> hasLargeKernelConvolution: aModel [

	^ (self layersWithLargeKernelConvolution: aModel layers)
		  isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasLosingLocalCorrelation: aModel [

	| localsWindowSize |
	localsWindowSize := aModel layers collect: [ :layer |
									
								layer hasConvolution ifTrue:[
							
		                    layer convolution kernelSize asInteger]
		
		 ].


	^ self isDescending: localsWindowSize
]

{ #category : #inspecting }
CNNPythonDetector >> hasNoNexpandingFeatureMap: aModel [

	| nbFeaturesMap |
	nbFeaturesMap := aModel layers collect: [ :layer |
		layer hasConvolution ifTrue: [  
		                 layer convolution filters asInteger ]].


	^ (self isAscending: nbFeaturesMap) not
]

{ #category : #inspecting }
CNNPythonDetector >> hasNonDominatingDownSampling: aModel [

	^ (self layersWithNonDominatingDownSampling: aModel layers) isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasNonRepresentativeStatisticsEstimation: aModel [

	^ (self layersWithNonRepresentativeStatisticsEstimation: aModel layers)
		  isNotEmpty
]

{ #category : #inspecting }
CNNPythonDetector >> hasTooMuchDownSampling: aModel [

	| layersNumber downSamplingNumber |
	layersNumber := aModel layers size.


	downSamplingNumber := aModel layers count: #hasDownSampling.


	^ layersNumber / 3 < downSamplingNumber
]

{ #category : #inspecting }
CNNPythonDetector >> hasUselessDropout: aModel [


	^ (self layersWithUselessDropout: aModel layers)
		  isNotEmpty.
		
		
	
]

{ #category : #'private - accessing' }
CNNPythonDetector >> homogeneousBlocks: aModel [

"homogeneous block is not a design smell. It help to build design smell Heterogeneous blocks"
	| convolutions next |
	convolutions := self convolutions: aModel.

	convolutions doWithIndex: [ :convolution :i |
		next := true.

		convolutions doWithIndex: [ :nextConvolution :j |
			i < j & (convolution isHomogeneousTo: nextConvolution) & next
				ifTrue: [
					convolution addHomogeneous: nextConvolution.
					nextConvolution itsHomogeneous: convolution.

					convolution itsHomogeneous ifNil: [
						convolution isStartOfBlock: true ] ]
				ifFalse: [ i < j ifTrue: [ next := false ] ] ] ].

	^ convolutions select: #isStartOfBlock
]

{ #category : #initialization }
CNNPythonDetector >> initialize [

	super initialize.
	importerCNN := CNNPythonImporter new
]

{ #category : #'private - accessing' }
CNNPythonDetector >> invocations: aModel [

	^ (aModel allWithType: FamixPythonInvocation )asOrderedCollection
]

{ #category : #helper }
CNNPythonDetector >> isAscending: aCollection [

	| counter len next res |
	counter := 2.
	len := aCollection size.
	res := true.

	(self isSame: aCollection) ifTrue: [ ^ res not ].

	aCollection do: [ :current |
		counter < len ifTrue: [
			next := aCollection at: counter.
			current > next ifTrue: [ ^ res not ].
			counter := counter + 1 ] ].

	^ res
]

{ #category : #helper }
CNNPythonDetector >> isAveragePooling: aPooling [

	^ importerCNN isAveragePooling: aPooling invocation
]

{ #category : #helper }
CNNPythonDetector >> isBatchNorm: aRegularization [

	^ importerCNN isBatchnorm:  aRegularization invocation
]

{ #category : #helper }
CNNPythonDetector >> isConvolution: aConvolution [

^ importerCNN isConvolution: aConvolution invocation
]

{ #category : #helper }
CNNPythonDetector >> isDescending: aCollection [

	(self isSame: aCollection) or: [
		(self isAscending: aCollection) ifTrue: [ ^ false ] ].

	^ true
]

{ #category : #helper }
CNNPythonDetector >> isDropout: aRegularization [

	^ importerCNN isDropout: aRegularization invocation
]

{ #category : #helper }
CNNPythonDetector >> isSame: aCollection [




	^ aCollection allSatisfy: [ :each | aCollection first = each ]
]

{ #category : #inspecting }
CNNPythonDetector >> layerWithBiasWithBatchNormalization: aLayer [

	| position results convs batchNorms |
	convs := OrderedCollection new.
	batchNorms := OrderedCollection new.
	position := 1.
	results := OrderedCollection new.


	batchNorms := aLayer regularizations select: [ :regularization |
		              self isBatchNorm: regularization ].


	( aLayer hasConvolution) ifTrue: [
		aLayer convolution useBias & batchNorms isNotEmpty ifTrue: [
			results := batchNorms ] ].

	^ results
]

{ #category : #'private - accessing' }
CNNPythonDetector >> layerWithLargeKernelConvolution: aLayer [

	( aLayer hasConvolution) ifTrue: [
		aLayer convolution kernelSize asInteger > 3 ifTrue: [ ^ aLayer ] ].
	^ nil
]

{ #category : #inspecting }
CNNPythonDetector >> layerWithNonDominatingDownSampling: aLayer [

	^aLayer poolings select: [ :pooling | self isAveragePooling: pooling ].

]

{ #category : #inspecting }
CNNPythonDetector >> layerWithNonRepresentativeStatisticsEstimation: aLayer [

	| results |
	results := OrderedCollection new.

	(self doesLayerContainDropout: aLayer)
	& (self doesLayerContainBatchNorm: aLayer) ifTrue: [
		
		(self batchNormsInLayer: aLayer) do: [ :batchNorm |
			
			(self dropoutsInLayer: aLayer) do: [ :dropout |
				
				batchNorm invocation sourceAnchor startPos
				> dropout invocation sourceAnchor startPos ifTrue: [
					results add: batchNorm ] ] ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> layerWithUselessDropout: aLayer [


	| results |
	results := OrderedCollection new.

	(self doesLayerContainDropout: aLayer)
	& (self doesLayerContainPooling: aLayer) ifTrue: [
		(self dropoutsInLayer: aLayer) do: [ :dropout |
			aLayer poolings do: [ :pooling |
				dropout invocation sourceAnchor startPos
				< pooling invocation sourceAnchor startPos ifTrue: [
					results add: dropout ] ] ] ].

	^ results
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithBiasWithBatchNormalization: layers [

	^ layers select: [ :layer |
		  (self layerWithBiasWithBatchNormalization: layer) isNotEmpty  ]
]

{ #category : #'private - accessing' }
CNNPythonDetector >> layersWithLargeKernelConvolution: layers [

	^ layers select: [ :layer |
		  (self layerWithLargeKernelConvolution: layer) isNotNil ]
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithNonDominatingDownSampling: layers [

	^ layers select: [ :layer |
		  (self layerWithNonDominatingDownSampling: layer) isNotEmpty ]
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithNonRepresentativeStatisticsEstimation: layers [

	^ layers select: [ :layer |
		  (self layerWithNonRepresentativeStatisticsEstimation: layer) isNotEmpty ]
]

{ #category : #inspecting }
CNNPythonDetector >> layersWithUselessDropout: layers [

	^layers select: [ :layer |
		(self layerWithUselessDropout: layer) isNotEmpty ]
]

{ #category : #accessing }
CNNPythonDetector >> visitor [

	^ visitor
]
