Extension { #name : 'MooseAbstractGroup' }

{ #category : '*Famix-Python-Importer' }
MooseAbstractGroup >> modelRootEntities [

	^ self propertyNamed: #modelRootEntities ifAbsentPut: [ self withoutStubs select: [ :entity | entity isQueryable and: [ entity isRoot ] ] ]
]
