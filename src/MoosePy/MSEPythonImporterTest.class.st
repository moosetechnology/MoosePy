Class {
	#name : #MSEPythonImporterTest,
	#superclass : #TestCase,
	#category : #MoosePy
}

{ #category : #accessing }
MSEPythonImporterTest >> parserClass [

	^ PythonParser
]

{ #category : #tests }
MSEPythonImporterTest >> testClasses [


	| pyDoc importer |
	pyDoc := self parserClass parse: PythonParserTests new sourceBig2.
	importer := MSEPythonSmaccImporterVisitor new.
	importer accept: pyDoc. 
	
	self assert: importer classes size equals: 3.
	
]

{ #category : #tests }
MSEPythonImporterTest >> testClassesImportedTwiceAreOnlyImportedOnce [


	| pyDoc importer |
	pyDoc := self parserClass parse: PythonParserTests new sourceBig2.
	importer := MSEPythonSmaccImporterVisitor new.
	
	importer accept: pyDoc. 
	
	self assert: importer classes size equals: 3.
	
	importer accept: pyDoc. 
	
	self assert: importer classes size equals: 3.
]

{ #category : #tests }
MSEPythonImporterTest >> testInitOfClass [

	| pyDoc importer |
	pyDoc := self parserClass parse: PythonParserTests new sourceBig2.
	importer := MSEPythonSmaccImporterVisitor new.
	importer accept: pyDoc. 
	
	self assert: importer functions size equals: 5.
	
]

{ #category : #tests }
MSEPythonImporterTest >> testParseClassFindsClasses [
	"a not so eciting tests but we should start somewhere"

	| pyDoc importer |
	pyDoc := self parserClass parse: PythonParserTests new sourceBig2.
	importer := MSEPythonSmaccImporterVisitor new.
	importer accept: pyDoc. 
	
	self assert: importer classes size equals: 3.
	
]
