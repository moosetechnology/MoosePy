"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentPackage` | `FamixTPackageable` | `childEntities` | `FamixTPackage` | Package containing the entity in the code structure (if applicable)|

### Incoming dependencies
| Relation | Origin | Opposite | Type | Comment |
|---|
| `incomingImports` | `FamixTImportable` | `importedEntity` | `FamixTImport` | List of imports of this entity|



"
Class {
	#name : 'FamixPythonUnknownImportedEntity',
	#superclass : 'FamixPythonContainerEntity',
	#traits : 'FamixTImportable + FamixTPackageable',
	#classTraits : 'FamixTImportable classTrait + FamixTPackageable classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonUnknownImportedEntity class >> annotation [

	<FMClass: #UnknownImportedEntity super: #FamixPythonContainerEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'testing' }
FamixPythonUnknownImportedEntity >> isStub [
	"Those entities represent stub entities by design."

	^ true
]
