Class {
	#name : #CNNPythonImporter,
	#superclass : #MSEPythonToFamixImporterVisitor,
	#instVars : [
		'invocations',
		'homogenous',
		'allLayers',
		'visitor',
		'famixModel',
		'program',
		'layerNum'
	],
	#category : #'DL-Python-Importers'
}

{ #category : #helper }
CNNPythonImporter >> addSourceAnchor: aLayer [

	| sortedLayerInvocations |
	sortedLayerInvocations := self sortedBySourceAnchor:
		                          aLayer invocations.


	aLayer sourceAnchor: (CNNFamixIndexedFileAnchor new
			 startPos: sortedLayerInvocations first sourceAnchor startPos;
			 endPos: sortedLayerInvocations last sourceAnchor endPos;
			 yourself).

]

{ #category : #model }
CNNPythonImporter >> createCNNModel: aFamixModel [

	program name: (self moduleName: aFamixModel).

	 self createLayers: (self invocations: aFamixModel)
]

{ #category : #'entity creation' }
CNNPythonImporter >> createLayer: invocation [

	| aLayer conv args ks |
	aLayer := model newLayer.

	(self isConvolution: invocation)
		ifTrue: [
			conv := model newConvolution.
			args := self getArguments: invocation.
			aLayer convolution: (conv invocation: invocation).
			conv useBias: (self getInvocationArgumentUseBias: invocation).

			args ifNotNil: [
				conv filters: (self getArgumentValue: args first).

				ks := self getArgumentValue: args second.

				ks isString
					ifFalse: [ conv kernelSize: ks first ]
					ifTrue: [ conv kernelSize: ks ] ] ]
		ifFalse: [
			(self isDense: invocation)
				ifTrue: [ aLayer dense: (model newDense invocation: invocation) ]
				ifFalse: [
					(self isFlatten: invocation)
						ifTrue: [
						aLayer flatten: (model newFlatten invocation: invocation) ]
						ifFalse: [ ^ nil ] ] ].
	aLayer name: 'L' , layerNum asString.
	layerNum := layerNum + 1.
	aLayer addInvocation: invocation.
	^ aLayer
]

{ #category : #'entity creation' }
CNNPythonImporter >> createLayers: invocationCollection [

	| currentLayer type |
	currentLayer := nil.
	type := 'functional'.


	invocationCollection do: [ :invoc |
		(self isNewLayer: invoc)
			ifTrue: [
				currentLayer := self createLayer: invoc.
				program addLayer: currentLayer ]
			ifFalse: [
			self extractSpecificFunctionFrom: invoc to: currentLayer ].

		(self isSequential: invoc) ifTrue: [ type := 'Sequential' ].
		program type: type ].


	self layers do: [ :aLayer | self addSourceAnchor: aLayer ]
]

{ #category : #'entity creation' }
CNNPythonImporter >> extractSpecificFunctionFrom: anInvocation to: aCurrentLayer [

	aCurrentLayer ifNotNil: [
		(self isActivation: anInvocation)
			ifTrue: [
				aCurrentLayer addActivation:
					(model newActivation invocation: anInvocation).
					aCurrentLayer addInvocation: anInvocation ]
			ifFalse: [
				(self isPooling: anInvocation)
					ifTrue: [
						aCurrentLayer addPooling:
							(model newPooling invocation: anInvocation).
						aCurrentLayer addInvocation: anInvocation ]
					ifFalse: [
						(self isRegularization: anInvocation) ifTrue: [
							aCurrentLayer addRegularization:
								(model newRegularization invocation: anInvocation).
							aCurrentLayer addInvocation: anInvocation ] ] ] ]
]

{ #category : #helper }
CNNPythonImporter >> getArgument: arguments byLabel: aLabel [

	^ arguments
		detect: [ :argument | (self getArgumentLabel: argument) = aLabel ]
		ifFound: [ :argument | argument ]
		ifNone: [ nil ]
]

{ #category : #'entity creation' }
CNNPythonImporter >> getArgumentBooleanValue: anInvocation byLabel: aLabel withDefaultValue: aDefaultValue [



	(self getArgument: (self getArguments: anInvocation) byLabel: aLabel)
		ifNotNil: [ :arg |
		^ self stringToBoolean: (self getArgumentValue: arg) ].
	^ aDefaultValue
]

{ #category : #helper }
CNNPythonImporter >> getArgumentLabel: anArgument [

	^anArgument at: 'label' ifAbsent: [ '' ]
]

{ #category : #helper }
CNNPythonImporter >> getArgumentValue: anArgument [

	^ anArgument at: 'value' ifAbsent: [ '' ]
]

{ #category : #helper }
CNNPythonImporter >> getArguments: anInvocation [

	^ anInvocation cacheAt: 'args' ifAbsent: [ nil ]
]

{ #category : #helper }
CNNPythonImporter >> getCandidateName: anInvocation [

	^ anInvocation cacheAt: 'canditate' ifAbsent: [ nil ]
]

{ #category : #'entity creation' }
CNNPythonImporter >> getInvocationArgumentUseBias: anInvocation [


	^ self
		getArgumentBooleanValue: anInvocation
		byLabel: 'use_bias'
		withDefaultValue: true.
]

{ #category : #initialization }
CNNPythonImporter >> initialize [

	super initialize.

	model := CNNFamixModel new name: 'default cnn model'.
	program := model newProgram.
	layerNum := 1
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> invocations: aModel [

	^ self sortedBySourceAnchor:(aModel allWithType: FamixPythonInvocation) asOrderedCollection
]

{ #category : #checking }
CNNPythonImporter >> isActivation: anInvocation [

	^ ('*activation' match: (self getCandidateName: anInvocation)) or: [
		  ('*relu' match: (self getCandidateName: anInvocation)) or: [
			  ('*sigmoid' match: (self getCandidateName: anInvocation)) or: [
				  ('*tanh' match: (self getCandidateName: anInvocation)) or: [
					  ('*leakyrelU' match: (self getCandidateName: anInvocation))
						  or: [
							  ('*exponential' match: (self getCandidateName: anInvocation))
								  or: [
									  ('*elu' match: (self getCandidateName: anInvocation))
										  or: [
										  '*soft*' match: (self getCandidateName: anInvocation) ] ] ] ] ] ] ]
]

{ #category : #checking }
CNNPythonImporter >> isAveragePooling: anInvocation [

	^ ('*avgpool*' match: (self getCandidateName: anInvocation)) or:[('*averagepool*' match: (self getCandidateName: anInvocation))]
]

{ #category : #checking }
CNNPythonImporter >> isBatchnorm: anInvocation [

	^ ('*batchnorm*' match: (self getCandidateName: anInvocation)) or:[
		 ('*batch_norm*' match: (self getCandidateName: anInvocation))]
]

{ #category : #checking }
CNNPythonImporter >> isConvolution: anInvocation [

	^ '*conv*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isDense: anInvocation [

	^ ('*dense' match: (self getCandidateName: anInvocation)) or: [
		  '*linear' match: (self getCandidateName: anInvocation) ]
]

{ #category : #checking }
CNNPythonImporter >> isDropout: anInvocation [

	^ '*dropout' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isFlatten: anInvocation [

	^ '*flatten' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isGlobalPooling: anInvocation [

	^ '*global*pool*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isMaxPooling: anInvocation [

	^ '*maxpool*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isNewLayer: anInvocation [

	^ (self isConvolution: anInvocation) 
		or: [ (self isDense: anInvocation)
	  	or: [self isFlatten: anInvocation]]
]

{ #category : #checking }
CNNPythonImporter >> isOptimizer: anInvocation [

	^ ('*ada' match: (self getCandidateName: anInvocation)) or: [
		  ('*sgd' match: (self getCandidateName: anInvocation)) or: [
			  ('*adam*' match: (self getCandidateName: anInvocation)) or: [
				  ('*prop' match: (self getCandidateName: anInvocation)) or: [
					  ('*lbfgs' match: (self getCandidateName: anInvocation)) or: [
						  '*ftrl' match: (self getCandidateName: anInvocation) ] ] ] ] ]
]

{ #category : #checking }
CNNPythonImporter >> isPooling: anInvocation [

	^ '*pool*' match: (self getCandidateName: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isRegularization: anInvocation [

	^ (self isDropout: anInvocation) | (self isBatchnorm: anInvocation)
]

{ #category : #checking }
CNNPythonImporter >> isSequential: anInvocation [

	^ '*sequential*' match: (self getCandidateName: anInvocation)
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> layers [

	^ ( model allWithType: CNNFamixLayer) asOrderedCollection
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> model [

	^ model
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> moduleName: aModel [

	^
		  (aModel allWithType: FamixPythonModule) first name
]

{ #category : #'accessing - classes' }
CNNPythonImporter >> program [

	^ program
]

{ #category : #helper }
CNNPythonImporter >> sortedBySourceAnchor: aCollection [

	^ aCollection
		  sorted: [ :a :b |
		  a sourceAnchor startPos < b sourceAnchor startPos ]
]

{ #category : #'entity creation' }
CNNPythonImporter >> stringToBoolean: aString [

				aString asLowercase = 'true'
				ifTrue: [ ^true ] .
				aString asLowercase = 'false'
				ifTrue: [ ^false ] .

]
