Class {
	#name : #CNNPythonDetectorTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'designSmellDetector'
	],
	#category : #'DL-Python-Tests'
}

{ #category : #accessing }
CNNPythonDetectorTest >> createCNNModel: aFamixModel [

	| cnnImporter |
	cnnImporter := CNNPythonImporter new.
	^ cnnImporter createCNNModel: aFamixModel
]

{ #category : #accessing }
CNNPythonDetectorTest >> createFamixModel: aPythonCode [

	| pyFamixVisior |
	pyFamixVisior := MSEPythonToFamixImporterVisitor new.
	(PythonParser parseWithErrors: aPythonCode) acceptVisitor:
		pyFamixVisior.
	^ pyFamixVisior model.
]

{ #category : #tests }
CNNPythonDetectorTest >> setUp [



	designSmellDetector := CNNPythonDetector new
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasBiasWithBatchNormalization [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5), input_shape=input_shape, padding=''same'', use_bias=''false''))
model.add(BatchNormalization())
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))  #<-- Design Smell: use_bias default value is true
model.add(BatchNormalization())  #<-- Design Smell: use BatchNorn when use_bias=true
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))

model.add(Conv2D(64, (3, 3), padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
'.

	cnnModel := self createCNNModel: famixModel.

	self
		assert:
		(designSmellDetector hasBiasWithBatchNormalization: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasHeterogeneousBlocks [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5))) 
model.add(Activation(''relu''))

#<-- Design smell : only one block homogeneous. should favor blocks have 2, 3, or even 4 homogeneous blocks

model.add(Conv2D(32, (3, 3)))  #<-- Start block homogeneous 1
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))  #<-- block homogeneous 1
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))  #<-- block homogeneous 1
model.add(MaxPooling2D(pool_size=(2, 2)))

'.

	cnnModel := self createCNNModel: famixModel.

	self
		assert: (designSmellDetector hasHeterogeneousBlocks: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasLargeKernelConvolution [

	| famixModel cnnModelLayers cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5))) #<-- Design Smell: large kernel_size (5x5). Ccan be replaced by two 3 × 3, or four 2 × 2 kernels.
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
'.

	cnnModel := self createCNNModel: famixModel.

	cnnModelLayers := cnnModel layers.


	self
		assert: (designSmellDetector hasLargeKernelConvolution: cnnModel)
		equals: true.
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasLosingLocalCorrelation [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(256, (7, 7), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
'.



	cnnModel := self createCNNModel: famixModel.


	self
		assert: (designSmellDetector hasLosingLocalCorrelation: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasNoNexpandingFeatureMap [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
'.

	cnnModel := self createCNNModel: famixModel.


	self
		assert: (designSmellDetector hasNoNexpandingFeatureMap: cnnModel)
		equals: true
		
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasNonDominatingDownSampling [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
conv9 = Convolution2D(nb_classes, 1, padding=''valid'')
relu9 = Activation(''relu'')

gap = AveragePooling2D(pool_size=(7,7)) #<-- Design Smell
flt = Flatten()
sftm = Activation(''softmax'')
'.

	cnnModel := self createCNNModel: famixModel.


	self
		assert: (designSmellDetector  hasNonDominatingDownSampling: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasNonRepresentativeStatisticsEstimation [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5)))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(BatchNormalization())

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
model.add(BatchNormalization())
model.add(Activation(''relu''))

'.


	cnnModel := self createCNNModel: famixModel.


	self
		assert: (designSmellDetector hasNonRepresentativeStatisticsEstimation: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasTooMuchDownSampling [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

'.

	cnnModel := self createCNNModel: famixModel.



	self
		assert: (designSmellDetector hasTooMuchDownSampling: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHasUselessDropout [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2)) #<-- Design Smell: Dropout used before down-sampling
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25)) #<-- Design Smell: Dropout used before down-sampling
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
'.

	cnnModel := self createCNNModel: famixModel.


	self
		assert: (designSmellDetector hasUselessDropout: cnnModel)
		equals: true
]

{ #category : #tests }
CNNPythonDetectorTest >> testHomogeneousBlocks [

	| famixModel cnnModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))  #<-- Start block homogeneous 1
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))


model.add(Conv2D(32, (5, 5)))
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3))) #<-- Start block homogeneous 2
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

'.

	cnnModel := self createCNNModel: famixModel.


	self
		assert: (designSmellDetector homogeneousBlocks: cnnModel) size
		equals: 2
]

{ #category : #tests }
CNNPythonDetectorTest >> testLayersWithBiasWithBatchNormalization [

	| famixModel cnnModelLayers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5), input_shape=input_shape, padding=''same'', use_bias=''false''))
model.add(BatchNormalization())
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))  #<-- Design Smell: use_bias default value is true
model.add(BatchNormalization())  #<-- Design Smell: use BatchNorm when use_bias=true
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))

model.add(Conv2D(64, (3, 3), padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
'.

cnnModelLayers := (self createCNNModel: famixModel) layers.


	self
		assert: (designSmellDetector layersWithBiasWithBatchNormalization:
				 cnnModelLayers ) size
		equals: 1.
	self
		assert: (designSmellDetector layersWithBiasWithBatchNormalization:
				 cnnModelLayers ) first name
		equals: 'L2'
]

{ #category : #tests }
CNNPythonDetectorTest >> testLayersWithLargeKernelConvolution [

	| famixModel cnnModelLayers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5))) #<-- Design Smell: large kernel_size (5x5). Ccan be replaced by two 3 × 3, or four 2 × 2 kernels.
model.add(Activation(''relu''))

model.add(Conv2D(32, (3, 3)))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
'.

	cnnModelLayers := (self createCNNModel: famixModel) layers.


	self
		assert:
			(designSmellDetector layersWithLargeKernelConvolution:
				 cnnModelLayers) size
		equals: 1.

	self
		assert:
			(designSmellDetector layersWithLargeKernelConvolution:
				 cnnModelLayers) first name
		equals: 'L1'
]

{ #category : #tests }
CNNPythonDetectorTest >> testLayersWithNonDominatingDownSampling [

	| famixModel cnnModelLayers |
	famixModel := self createFamixModel: '
conv8 = Convolution2D(nb_classes, 1, padding=''valid'')
relu8 = Activation(''relu'')

gap = AveragePooling2D(pool_size=(7,7)) #<-- Design Smell 1


conv9 = Convolution2D(nb_classes, 1)
relu9 = Activation(''relu'')
gap = AveragePooling2D(pool_size=(7,7)) #<-- Design Smell 2

flt = Flatten()
sftm = Activation(''softmax'')
'.

	cnnModelLayers := (self createCNNModel: famixModel) layers.


	self
		assert: (designSmellDetector layersWithNonDominatingDownSampling:
				 cnnModelLayers ) size
		equals: 2.

	self
		assert: (designSmellDetector layersWithNonDominatingDownSampling:
				 cnnModelLayers ) first name
		equals: 'L1'
]

{ #category : #tests }
CNNPythonDetectorTest >> testLayersWithNonRepresentativeStatisticsEstimation [

	| famixModel cnnModelLayers |
	famixModel := self createFamixModel: '
model.add(Conv2D(32, (5, 5)))
model.add(Dropout(0.2))
model.add(Activation(''relu''))
model.add(BatchNormalization()) #<-- Design Smell:BatchNorm used after dropout

model.add(Conv2D(32, (3, 3)))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.2))
model.add(BatchNormalization()) #<-- Design Smell:BatchNorm used after dropout
model.add(Activation(''relu''))

'.

	cnnModelLayers := (self createCNNModel: famixModel) layers.


	self
		assert:
			(designSmellDetector
				 layersWithNonRepresentativeStatisticsEstimation: cnnModelLayers)
				size
		equals: 2.

	self
		assert:
			(designSmellDetector
				 layersWithNonRepresentativeStatisticsEstimation: cnnModelLayers)
				first name
		equals: 'L1'.

	self
		assert:
			(designSmellDetector
				 layersWithNonRepresentativeStatisticsEstimation: cnnModelLayers)
				first sourceAnchor startPos
		equals: 12
]

{ #category : #tests }
CNNPythonDetectorTest >> testLayersWithUselessDropout [

	| cnnModelLayers famixModel |
	famixModel := self createFamixModel: '
model.add(Conv2D(256, (3, 3), input_shape=X.shape[1:], padding=''same''))
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))
model.add(Dropout(0.2))

model.add(Conv2D(222, (3, 3), padding=''same''))
model.add(Dropout(0.2)) 				#<-- Design Smell: Dropout used before down-sampling
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(Dropout(0.25))          #<-- Design Smell: Dropout used before down-sampling
model.add(Activation(''relu''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))
model.add(MaxPooling2D(pool_size=(2, 2), strides=2))

model.add(Conv2D(256, (3, 3), padding=''same''))

model.add(Flatten())


'.


	cnnModelLayers := (self createCNNModel: famixModel) layers.


	self
		assert:
		(designSmellDetector layersWithUselessDropout: cnnModelLayers) size
		equals: 2.

	self
		assert:
			(designSmellDetector layersWithUselessDropout: cnnModelLayers)
				second name
		equals: 'L3'.

	self
		assert:
			(designSmellDetector layersWithUselessDropout: cnnModelLayers)
				first sourceAnchor startPos
		equals: 192.
		
	self
		assert:
			(designSmellDetector layersWithUselessDropout: cnnModelLayers)
				first sourceAnchor endPos
		equals: 390.
]
