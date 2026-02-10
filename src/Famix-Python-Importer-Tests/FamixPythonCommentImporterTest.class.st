Class {
	#name : 'FamixPythonCommentImporterTest',
	#superclass : 'FamixPythonAbstractSnippetImporterTest',
	#category : 'Famix-Python-Importer-Tests',
	#package : 'Famix-Python-Importer-Tests'
}

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testMergeSingleLineComment [

	| comment |
	self import: '# This is a comment
# This is another comment
print(1 + 1)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
# This is another comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 46.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 46
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testMergeSingleLineCommentWide [

	| comment |
	self import: '# This is a comment £
# This is another comment
print(1 + 1)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
# This is another comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 49.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 48
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testMergeSingleLineCommentWithTabs [

	| comment |
	self import: '	# This is a comment
	# This is another comment
print(1 + 1)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
	# This is another comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 2.
	self assert: comment sourceAnchor endByte equals: 48.
	self assert: comment sourceAnchor startPos equals: 2.
	self assert: comment sourceAnchor endPos equals: 48
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testMergeSingleLineCommentWithTabsWide [

	| comment |
	self import: '	# This is a comment £
	# This is another comment
print(1 + 1)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
	# This is another comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 2.
	self assert: comment sourceAnchor endByte equals: 51.
	self assert: comment sourceAnchor startPos equals: 2.
	self assert: comment sourceAnchor endPos equals: 50
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testOnlySingleLineComment [

	| comment |
	self import: '# This is a comment'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment'.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 19.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 19
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testOnlySingleLineCommentWide [
	"£ is encoded on 2 bytes in UTF8"

	| comment |
	self import: '# It cost 6£ in total'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# It cost 6£ in total'.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 22.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 21
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testOnlySingleLineCommentWideLast [
	"£ is encoded on 2 bytes in UTF8"

	| comment |
	self import: '# It cost 6£'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# It cost 6£'.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 13.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 12
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineComment [

	| comment |
	self import: '# This is a comment
print(1 + 1)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 20.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 20
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentBeforeFunction [

	| comment |
	self import: '# This is a comment
def x():
	pass'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 20.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 20.
	self assert: comment commentedEntity class equals: FamixPythonFunction
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentBeforeFunctionAndTabs [

	| comment |
	self import: '	# This is a comment
	def x():
		pass'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 2.
	self assert: comment sourceAnchor endByte equals: 21.
	self assert: comment sourceAnchor startPos equals: 2.
	self assert: comment sourceAnchor endPos equals: 21.
	self assert: comment commentedEntity class equals: FamixPythonFunction
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentBeforeFunctionAndTabsWide [

	| comment |
	self import: '	# This is a comment £
	def x():
		pass'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 2.
	self assert: comment sourceAnchor endByte equals: 24.
	self assert: comment sourceAnchor startPos equals: 2.
	self assert: comment sourceAnchor endPos equals: 23.
	self assert: comment commentedEntity class equals: FamixPythonFunction
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentBeforeFunctionWide [

	| comment |
	self import: '# This is a comment £
def x():
	pass'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 23.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 22.
	self assert: comment commentedEntity class equals: FamixPythonFunction
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentOnGlobalVariableDeclaration [

	| comment |
	self import: 'var = 1 # This is a comment
print(global)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 9.
	self assert: comment sourceAnchor endByte equals: 28.
	self assert: comment sourceAnchor startPos equals: 9.
	self assert: comment sourceAnchor endPos equals: 28.
	self assert: comment commentedEntity class equals: FamixPythonGlobalVariable
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentOnGlobalVariableDeclarationWide [

	| comment |
	self import: 'var = 1 # This is a comment £
print(global)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 9.
	self assert: comment sourceAnchor endByte equals: 31.
	self assert: comment sourceAnchor startPos equals: 9.
	self assert: comment sourceAnchor endPos equals: 30.
	self assert: comment commentedEntity class equals: FamixPythonGlobalVariable
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentTwoLinesBeforeFunction [

	| comment |
	self import: '# This is a comment

def x():
	pass'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 20.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 20.
	self assert: comment commentedEntity class equals: FamixPythonModule
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentTwoLinesBeforeFunctionWide [

	| comment |
	self import: '# This is a comment £

def x():
	pass'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 23.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 22.
	self assert: comment commentedEntity class equals: FamixPythonModule
]

{ #category : 'tests' }
FamixPythonCommentImporterTest >> testSingleLineCommentWide [

	| comment |
	self import: '# This is a comment £
print(1 + 1)'.

	self assert: model allComments size equals: 1.

	comment := model allComments anyOne.
	self assert: comment sourceText equals: '# This is a comment £
' withPlatformLineEndings.
	self assert: comment sourceAnchor startByte equals: 1.
	self assert: comment sourceAnchor endByte equals: 23.
	self assert: comment sourceAnchor startPos equals: 1.
	self assert: comment sourceAnchor endPos equals: 22
]
