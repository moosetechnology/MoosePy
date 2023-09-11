Class {
	#name : #CNNFamixGenerator,
	#superclass : #FamixBasicInfrastructureGenerator,
	#instVars : [
		'layer',
		'pooling',
		'convolution',
		'activation',
		'regularization',
		'indexedFileAnchor',
		'dense',
		'invocation',
		'flatten',
		'program',
		'containerEntity'
	],
	#category : #'DL-Python-Generators'
}

{ #category : #accessing }
CNNFamixGenerator class >> packageName [

		^ #'CNN-Famix-Entities'
]

{ #category : #accessing }
CNNFamixGenerator class >> prefix [

	^ #'CNNFamix'
]

{ #category : #accessing }
CNNFamixGenerator class >> submetamodels [

	^ { FamixPythonGenerator }
]

{ #category : #definition }
CNNFamixGenerator >> defineClasses [

	super defineClasses.

	activation := builder newClassNamed: #Activation.
	containerEntity := builder newAbstractClassNamed: #ContainerEntity.
	convolution := builder newClassNamed: #Convolution.
	dense := builder newClassNamed: #Dense.
	flatten := builder newClassNamed: #Flatten.
	indexedFileAnchor := builder newClassNamed: #IndexedFileAnchor.
	invocation := self remoteEntity: #Invocation withPrefix: #FamixPython.
	layer := builder newClassNamed: #Layer.
	program := builder newClassNamed: #Program.
	pooling := builder newClassNamed: #Pooling.
	regularization := builder newClassNamed: #Regularization
]

{ #category : #definition }
CNNFamixGenerator >> defineHierarchy [

	super defineHierarchy.

	indexedFileAnchor --|> sourceAnchor.
	indexedFileAnchor --|> #TIndexedFileNavigation.

	layer --|> #TSourceEntity.

	program --|> namedEntity
]

{ #category : #definition }
CNNFamixGenerator >> defineProperties [

	super defineProperties.
	(program property: #type type: #String) comment:
		'Sequential or Fonctional model'.

	(layer property: #name type: #String) comment: 'layer name >> L1'.

	(convolution property: #useBias type: #Boolean) comment:
		'layer convolution  useBias >> [true|false]'.

	(convolution property: #filters type: #String defaultValue:true ) comment:
		'layer convolution  filters >> 32'.

	(convolution property: #kernelSize type: #String) comment:
		'layer convolution  kernelSize >> 3'
]

{ #category : #definition }
CNNFamixGenerator >> defineRelations [

	super defineRelations.

	activation - invocation.
	convolution - invocation.
	dense - invocation.
	flatten - invocation.
	pooling - invocation.
	regularization - invocation.

	
	layer <>- convolution.
	layer <>- dense.
	layer <>- flatten.
	layer <>-* activation.
	layer <>-* invocation.
	layer <>-* pooling.
	layer <>-* regularization.

	program <>-* layer
]
