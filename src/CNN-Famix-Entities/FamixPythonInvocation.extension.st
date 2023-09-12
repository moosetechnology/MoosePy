Extension { #name : #FamixPythonInvocation }

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> activation [
	"Relation named: #activation type: #CNNFamixActivation opposite: #invocation"

	<generated>
	<derived>
	<FMProperty: #activation type: #CNNFamixActivation opposite: #invocation>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #activation ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> activation: anObject [

	<generated>
	(self attributeAt: #activation ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self activation.
		self attributeAt: #activation put: anObject.
		otherSide invocation: nil ]
	ifNotNil: [ 
		self attributeAt: #activation put: anObject.
		anObject invocation: self ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> convolution [
	"Relation named: #convolution type: #CNNFamixConvolution opposite: #invocation"

	<generated>
	<derived>
	<FMProperty: #convolution type: #CNNFamixConvolution opposite: #invocation>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #convolution ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> convolution: anObject [

	<generated>
	(self attributeAt: #convolution ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self convolution.
		self attributeAt: #convolution put: anObject.
		otherSide invocation: nil ]
	ifNotNil: [ 
		self attributeAt: #convolution put: anObject.
		anObject invocation: self ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> dense [
	"Relation named: #dense type: #CNNFamixDense opposite: #invocation"

	<generated>
	<derived>
	<FMProperty: #dense type: #CNNFamixDense opposite: #invocation>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #dense ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> dense: anObject [

	<generated>
	(self attributeAt: #dense ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self dense.
		self attributeAt: #dense put: anObject.
		otherSide invocation: nil ]
	ifNotNil: [ 
		self attributeAt: #dense put: anObject.
		anObject invocation: self ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> flatten [
	"Relation named: #flatten type: #CNNFamixFlatten opposite: #invocation"

	<generated>
	<derived>
	<FMProperty: #flatten type: #CNNFamixFlatten opposite: #invocation>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #flatten ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> flatten: anObject [

	<generated>
	(self attributeAt: #flatten ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self flatten.
		self attributeAt: #flatten put: anObject.
		otherSide invocation: nil ]
	ifNotNil: [ 
		self attributeAt: #flatten put: anObject.
		anObject invocation: self ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> layer [
	"Relation named: #layer type: #CNNFamixLayer opposite: #invocations"

	<generated>
	<container>
	<FMProperty: #layer type: #CNNFamixLayer opposite: #invocations>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #layer ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> layer: anObject [

	<generated>
	self attributeAt: #layer put: (FMMultivalueLink on: self update: #invocations from: self layer to: anObject).
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> pooling [
	"Relation named: #pooling type: #CNNFamixPooling opposite: #invocation"

	<generated>
	<derived>
	<FMProperty: #pooling type: #CNNFamixPooling opposite: #invocation>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #pooling ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> pooling: anObject [

	<generated>
	(self attributeAt: #pooling ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self pooling.
		self attributeAt: #pooling put: anObject.
		otherSide invocation: nil ]
	ifNotNil: [ 
		self attributeAt: #pooling put: anObject.
		anObject invocation: self ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> regularization [
	"Relation named: #regularization type: #CNNFamixRegularization opposite: #invocation"

	<generated>
	<derived>
	<FMProperty: #regularization type: #CNNFamixRegularization opposite: #invocation>
	<package: #'CNN-Famix-Entities'>
	^ self attributeAt: #regularization ifAbsent: [ nil ]
]

{ #category : #'*CNN-Famix-Entities-accessing' }
FamixPythonInvocation >> regularization: anObject [

	<generated>
	(self attributeAt: #regularization ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self regularization.
		self attributeAt: #regularization put: anObject.
		otherSide invocation: nil ]
	ifNotNil: [ 
		self attributeAt: #regularization put: anObject.
		anObject invocation: self ]
]
