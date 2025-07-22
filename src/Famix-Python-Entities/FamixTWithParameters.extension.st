Extension { #name : 'FamixTWithParameters' }

{ #category : '*Famix-Python-Entities' }
FamixTWithParameters >> keywordSeparatorPosition [

	<FMProperty: #keywordSeparatorPosition type: #Number>
	<derived>
	<FMComment: 'If there is a keyword separator in the parameters, return its position (first parameter been 1 and not 0)'>
	^ self attributeAt: #keywordSeparatorPosition ifAbsent: [ nil ]
]

{ #category : '*Famix-Python-Entities' }
FamixTWithParameters >> positionalSeparatorPosition [

	<FMProperty: #positionalSeparatorPosition type: #Number>
	<derived>
	<FMComment: 'If there is a positional separator in the parameters, return its position (first parameter been 1 and not 0)'>
	^ self attributeAt: #positionalSeparatorPosition ifAbsent: [ nil ]
]
