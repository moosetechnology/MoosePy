"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `sourcedEntities` | `FamixTSourceLanguage` | `declaredSourceLanguage` | `FamixTWithSourceLanguages` | References to the entities saying explicitly that are written in this language.|



"
Class {
	#name : 'FamixPythonSourceLanguage',
	#superclass : 'FamixPythonEntity',
	#traits : 'FamixTSourceLanguage',
	#classTraits : 'FamixTSourceLanguage classTrait',
	#category : 'Famix-Python-Entities-Entities',
	#package : 'Famix-Python-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixPythonSourceLanguage class >> annotation [

	<FMClass: #SourceLanguage super: #FamixPythonEntity>
	<package: #'Famix-Python-Entities'>
	<generated>
	^ self
]

{ #category : 'meta' }
FamixPythonSourceLanguage class >> languageKeyWords [
	"keywords from keyword.kwlist 
	Python version: 3.10.18"

	^ #( 
and      as        assert    async     await
break    class     continue  def       del
elif     else      except    False     finally
for      from      global    if        import
in       is        lambda    None      nonlocal
not      or        pass      raise     return
True     try       while     with      yield
	)
]
