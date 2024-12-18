"
I am a resolvable to resolve accesses or references to entities that are imported using a simple `import` and not a `from import`. For example

```python
import moduleAtRoot

print(moduleAtRoot.moduleAtRootVariable)
```
"
Class {
	#name : 'FamixPythonImportedAccessOrReferenceResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'import',
		'identifier',
		'entity'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonImportedAccessOrReferenceResolvable class >> identifier: aString import: anImport [

	^ self new
		  identifier: aString;
		  import: anImport;
		  yourself
]

{ #category : 'hooks' }
FamixPythonImportedAccessOrReferenceResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [

	self entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
FamixPythonImportedAccessOrReferenceResolvable >> entity [

	^ entity
]

{ #category : 'accessing' }
FamixPythonImportedAccessOrReferenceResolvable >> entity: anObject [

	entity := anObject
]

{ #category : 'accessing' }
FamixPythonImportedAccessOrReferenceResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
FamixPythonImportedAccessOrReferenceResolvable >> identifier: anObject [

	identifier := anObject
]

{ #category : 'accessing' }
FamixPythonImportedAccessOrReferenceResolvable >> import [

	^ import
]

{ #category : 'accessing' }
FamixPythonImportedAccessOrReferenceResolvable >> import: anObject [

	import := anObject
]

{ #category : 'resolution' }
FamixPythonImportedAccessOrReferenceResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	import importedEntity name = identifier ifTrue: [ ^ self entity: import importedEntity ].

	^ (import importedEntity definedEntitiesNamed: identifier ofKinds: {
			   FamixPythonClass.
			   FamixPythonFunction.
			   FamixPythonLocalVariable.
			   FamixPythonGlobalVariable.
			   FamixPythonAttribute.
			   FamixPythonParameter }) ifEmpty: [ SRNoResolutionPossible signal ] ifNotEmpty: [ :entities | self entity: entities anyOne ]
]
