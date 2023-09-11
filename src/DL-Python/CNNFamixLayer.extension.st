Extension { #name : #CNNFamixLayer }

{ #category : #'*DL-Python' }
CNNFamixLayer >> hasConvolution [

	^ convolution isNotNil
]

{ #category : #'*DL-Python' }
CNNFamixLayer >> hasDownSampling [

^ poolings isNotEmpty 
]
