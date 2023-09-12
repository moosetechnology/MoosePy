"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.
"
Trait {
	#name : #CNNFamixTEntityCreator,
	#category : #'CNN-Famix-Entities-Model'
}

{ #category : #meta }
CNNFamixTEntityCreator classSide >> annotation [

	<FMClass: #TEntityCreator super: #Object>
	<package: #'CNN-Famix-Entities'>
	<generated>
	^ self
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newActivation [

	<generated>
	^ self add: CNNFamixActivation new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newComment [

	<generated>
	^ self add: CNNFamixComment new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newConvolution [

	<generated>
	^ self add: CNNFamixConvolution new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newDense [

	<generated>
	^ self add: CNNFamixDense new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newFlatten [

	<generated>
	^ self add: CNNFamixFlatten new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newIndexedFileAnchor [

	<generated>
	^ self add: CNNFamixIndexedFileAnchor new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newLayer [

	<generated>
	^ self add: CNNFamixLayer new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newPooling [

	<generated>
	^ self add: CNNFamixPooling new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newProgram [

	<generated>
	^ self add: CNNFamixProgram new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newRegularization [

	<generated>
	^ self add: CNNFamixRegularization new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newSourceLanguage [

	<generated>
	^ self add: CNNFamixSourceLanguage new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newSourceTextAnchor [

	<generated>
	^ self add: CNNFamixSourceTextAnchor new
]

{ #category : #'entity creation' }
CNNFamixTEntityCreator >> newUnknownSourceLanguage [

	<generated>
	^ self add: CNNFamixUnknownSourceLanguage new
]
