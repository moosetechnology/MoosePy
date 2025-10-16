"
I am a cleaner used by FamixReplication to detect duplicated code in Python code
"
Class {
	#name : 'FamixRepPythonCleaner',
	#superclass : 'FamixRepPairedCommentsCleaner',
	#category : 'Famix-Python-Entities-Replication',
	#package : 'Famix-Python-Entities',
	#tag : 'Replication'
}

{ #category : 'accessing' }
FamixRepPythonCleaner class >> description [

	^ 'Clearner for Python language'
]

{ #category : 'displaying' }
FamixRepPythonCleaner class >> displayStringOn: aStream [

	aStream << 'Python comments'
]

{ #category : 'private' }
FamixRepPythonCleaner >> cleanLine: aText [
	"a++ //asd -> a++"

	^ (super cleanLine: aText) copyUpToSubString: '//'
]

{ #category : 'private' }
FamixRepPythonCleaner >> isComment: aLine [
	"we could have defined this method
	but just returning false because a comment line will be empty because cleaner removes everything within double qoutes and hence not considered by the detector"

	^ false
]

{ #category : 'actions' }
FamixRepPythonCleaner >> multilineCommentCloser [

	^ '"""'
]

{ #category : 'actions' }
FamixRepPythonCleaner >> multilineCommentOpener [

	^ '"""'
]
