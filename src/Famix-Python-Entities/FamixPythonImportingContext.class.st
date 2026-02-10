"
This class is used to choose the entities to be imported when loading a model from file.
It is used by `MiImportingContextPresenter` in a `MiImportModelFromFileDialog` to import a FamixPythonModel.
"
Class {
	#name : 'FamixPythonImportingContext',
	#superclass : 'FamixImportingContext',
	#category : 'Famix-Python-Entities-Import',
	#package : 'Famix-Python-Entities',
	#tag : 'Import'
}

{ #category : 'accessing' }
FamixPythonImportingContext class >> importedMetamodel [

	<generated>
	^ FamixPythonModel metamodel
]

{ #category : 'importing' }
FamixPythonImportingContext >> importAccess [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #Access)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importAttribute [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Attribute)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importBytesFileAnchor [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #BytesFileAnchor)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importClass [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Class)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importComment [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Comment)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importFunction [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Function)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importGlobalVariable [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #GlobalVariable)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importImplicitVariable [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #ImplicitVariable)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importImport [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #Import)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importInheritance [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #Inheritance)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importInvocation [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #Invocation)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importLambda [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Lambda)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importLocalVariable [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #LocalVariable)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importMetaclass [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Metaclass)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importMetaclassUsage [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #MetaclassUsage)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importMethod [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Method)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importModule [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Module)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importPackage [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Package)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importParameter [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Parameter)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importPrimitiveType [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #PrimitiveType)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importReference [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #Reference)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importSourceLanguage [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #SourceLanguage)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importSourceTextAnchor [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #SourceTextAnchor)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importType [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #Type)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importUnknowAccessOrReference [

	<generated>
	^ self importAssociation: (self class fm3ClassNamed: #UnknowAccessOrReference)
]

{ #category : 'importing' }
FamixPythonImportingContext >> importUnknownEntity [

	<generated>
	^ self importConcreteEntity: (self class fm3ClassNamed: #UnknownEntity)
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportAccess [

	<generated>
	^ self shouldImport: #Access
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportAttribute [

	<generated>
	^ self shouldImport: #Attribute
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportBytesFileAnchor [

	<generated>
	^ self shouldImport: #BytesFileAnchor
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportClass [

	<generated>
	^ self shouldImport: #Class
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportComment [

	<generated>
	^ self shouldImport: #Comment
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportFunction [

	<generated>
	^ self shouldImport: #Function
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportGlobalVariable [

	<generated>
	^ self shouldImport: #GlobalVariable
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportImplicitVariable [

	<generated>
	^ self shouldImport: #ImplicitVariable
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportImport [

	<generated>
	^ self shouldImport: #Import
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportInheritance [

	<generated>
	^ self shouldImport: #Inheritance
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportInvocation [

	<generated>
	^ self shouldImport: #Invocation
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportLambda [

	<generated>
	^ self shouldImport: #Lambda
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportLocalVariable [

	<generated>
	^ self shouldImport: #LocalVariable
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportMetaclass [

	<generated>
	^ self shouldImport: #Metaclass
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportMetaclassUsage [

	<generated>
	^ self shouldImport: #MetaclassUsage
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportMethod [

	<generated>
	^ self shouldImport: #Method
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportModule [

	<generated>
	^ self shouldImport: #Module
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportPackage [

	<generated>
	^ self shouldImport: #Package
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportParameter [

	<generated>
	^ self shouldImport: #Parameter
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportPrimitiveType [

	<generated>
	^ self shouldImport: #PrimitiveType
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportReference [

	<generated>
	^ self shouldImport: #Reference
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportSourceLanguage [

	<generated>
	^ self shouldImport: #SourceLanguage
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportSourceTextAnchor [

	<generated>
	^ self shouldImport: #SourceTextAnchor
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportType [

	<generated>
	^ self shouldImport: #Type
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportUnknowAccessOrReference [

	<generated>
	^ self shouldImport: #UnknowAccessOrReference
]

{ #category : 'testing' }
FamixPythonImportingContext >> shouldImportUnknownEntity [

	<generated>
	^ self shouldImport: #UnknownEntity
]
