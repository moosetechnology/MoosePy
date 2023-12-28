"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.
"
Trait {
	#name : #FamixPythonTEntityCreator,
	#category : #'Famix-Python-Entities-Model'
}

{ #category : #meta }
FamixPythonTEntityCreator classSide >> annotation [

	<FMClass: #TEntityCreator super: #Object>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newAccess [

	<generated>
	^ self add: FamixPythonAccess new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newAttribute [

	<generated>
	^ self add: FamixPythonAttribute new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newAttributeNamed: aName [

	<generated>
	^ self add: (FamixPythonAttribute named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newClass [

	<generated>
	^ self add: FamixPythonClass new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newClassNamed: aName [

	<generated>
	^ self add: (FamixPythonClass named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newComment [

	<generated>
	^ self add: FamixPythonComment new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newFunction [

	<generated>
	^ self add: FamixPythonFunction new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newFunctionNamed: aName [

	<generated>
	^ self add: (FamixPythonFunction named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newImplicitVariable [

	<generated>
	^ self add: FamixPythonImplicitVariable new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newImplicitVariableNamed: aName [

	<generated>
	^ self add: (FamixPythonImplicitVariable named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newImport [

	<generated>
	^ self add: FamixPythonImport new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newIndexedFileAnchor [

	<generated>
	^ self add: FamixPythonIndexedFileAnchor new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newInheritance [

	<generated>
	^ self add: FamixPythonInheritance new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newInvocation [

	<generated>
	^ self add: FamixPythonInvocation new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newLocalVariable [

	<generated>
	^ self add: FamixPythonLocalVariable new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newLocalVariableNamed: aName [

	<generated>
	^ self add: (FamixPythonLocalVariable named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newMethod [

	<generated>
	^ self add: FamixPythonMethod new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newMethodNamed: aName [

	<generated>
	^ self add: (FamixPythonMethod named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newModule [

	<generated>
	^ self add: FamixPythonModule new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newPackage [

	<generated>
	^ self add: FamixPythonPackage new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newPackageNamed: aName [

	<generated>
	^ self add: (FamixPythonPackage named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newParameter [

	<generated>
	^ self add: FamixPythonParameter new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newParameterNamed: aName [

	<generated>
	^ self add: (FamixPythonParameter named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newPrimitiveType [

	<generated>
	^ self add: FamixPythonPrimitiveType new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newPrimitiveTypeNamed: aName [

	<generated>
	^ self add: (FamixPythonPrimitiveType named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newReference [

	<generated>
	^ self add: FamixPythonReference new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newSourceLanguage [

	<generated>
	^ self add: FamixPythonSourceLanguage new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newSourceTextAnchor [

	<generated>
	^ self add: FamixPythonSourceTextAnchor new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newType [

	<generated>
	^ self add: FamixPythonType new
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newTypeNamed: aName [

	<generated>
	^ self add: (FamixPythonType named: aName)
]

{ #category : #'entity creation' }
FamixPythonTEntityCreator >> newUnknownSourceLanguage [

	<generated>
	^ self add: FamixPythonUnknownSourceLanguage new
]
