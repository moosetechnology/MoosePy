Extension { #name : #CNNFamixConvolution }

{ #category : #'*DL-Python' }
CNNFamixConvolution >> addHomogeneous: anObject [

	 homogeneous add: anObject
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> homogeneous [

	^ homogeneous
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> homogeneous: anObject [

	homogeneous := anObject
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> initialize [

	super initialize.

	homogeneous := OrderedCollection new.
	
isStartOfBlock := false
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> isHomogeneous [

	^ homogeneous isNotEmpty
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> isHomogeneousTo: aConvolution [

	^(self filters = aConvolution filters ) & (self kernelSize  = aConvolution kernelSize )
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> isStartOfBlock [

	^ isStartOfBlock 
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> isStartOfBlock: aBoolean [

	isStartOfBlock := aBoolean
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> itsHomogeneous [

	^itsHomogeneous
]

{ #category : #'*DL-Python' }
CNNFamixConvolution >> itsHomogeneous: anObject [

	itsHomogeneous := anObject
]
