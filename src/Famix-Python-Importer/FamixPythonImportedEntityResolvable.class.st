"
I am a resolvable to resolve accesses or references to entities that are imported using a simple `import` and not a `from import`. For example

```python
import moduleAtRoot

print(moduleAtRoot.moduleAtRootVariable)
```
"
Class {
	#name : 'FamixPythonImportedEntityResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'import',
		'identifier'
	],
	#category : 'Famix-Python-Importer-SymbolResolution',
	#package : 'Famix-Python-Importer',
	#tag : 'SymbolResolution'
}

{ #category : 'instance creation' }
FamixPythonImportedEntityResolvable class >> identifier: aString import: anImport [

	^ self new
		  identifier: aString;
		  import: anImport;
		  yourself
]

{ #category : 'accessing' }
FamixPythonImportedEntityResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
FamixPythonImportedEntityResolvable >> identifier: anObject [

	identifier := anObject
]

{ #category : 'accessing' }
FamixPythonImportedEntityResolvable >> import [

	^ import
]

{ #category : 'accessing' }
FamixPythonImportedEntityResolvable >> import: anObject [

	import := anObject
]

{ #category : 'resolution' }
FamixPythonImportedEntityResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	import importedEntity name = identifier ifTrue: [ ^ self result: import importedEntity ].

	^ (import importedEntity definedEntitiesNamed: identifier ofKinds: self expectedKinds)
		  ifEmpty: [ SRNoResolutionPossible signal ]
		  ifNotEmpty: [ :entities | self result: entities anyOne ]
]
