Extension { #name : #FamixPythonModule }

{ #category : #'*MoosePy' }
FamixPythonModule >> createLocalVariable: aString [ 
	
]

{ #category : #'*MoosePy' }
FamixPythonModule >> dictLocalVariables [
	^self attributeAt: #dictLocalVariables ifAbsentPut: [ Dictionary new ] 
]

{ #category : #'*MoosePy' }
FamixPythonModule >> manualAddImport: aFamixImport [

	(self attributeAt: #manualImports ifAbsentPut: OrderedCollection new)
		add: aFamixImport
]

{ #category : #'*MoosePy' }
FamixPythonModule >> manualIncomingImports [

	^self attributeAt: #manualImports ifAbsent: OrderedCollection new
]
