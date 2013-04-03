JARS=jackson-core-2.1.4.jar
space :=
space +=
comma :=,
JARS_CP=$(subst $(space),:,$(JARS))
JSON=../data-telemetry/export.log
PYTHON_JSON=json
PYTHON_CMD=python
JYTHON_JSON=com.xhaus.jyson.JysonCodec

node:
	nodejs node.js $(JSON) 

jython: jython-standalone-2.7-b1.jar jyson-1.0.2.jar
	$(MAKE) python PYTHON_CMD="java  -jar $< -Dpython.path=jyson-1.0.2.jar" PYTHON_JSON=$(JYTHON_JSON)
 
python:
	$(PYTHON_CMD) loadjson.py $(PYTHON_JSON) < $(JSON)

python_simplejson:
	$(MAKE) python PYTHON_JSON=simplejson

spidermonkey:
	~/obj/js -f spidermonkey.js < ~/work/data-telemetry/export.log

json: json.cpp json.h
	c++ -Wall -O3 json.cpp -o json

cxx:
	 ./json < $(JSON)

cxx1: json
	 $(PIPE) | ./json

cxx2: json
	 $(PIPE) | ./json
cxx3: json
	 $(PIPE)| ./json
cxx4: json
	 $(PIPE)| ./json

cxxp: cxx1 cxx2 cxx3 cxx4

java: $(JARS)
	javac -cp $(JARS_CP)  JSON.java && java -cp $(JARS_CP):. JSON < $(JSON)

jackson-core-2.1.4.jar:
	wget -c http://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.1.4/jackson-core-2.1.4.jar

jython-standalone-2.7-b1.jar:
	wget -c http://repo1.maven.org/maven2/org/python/jython-standalone/2.7-b1/jython-standalone-2.7-b1.jar

jyson-1.0.2.jar:
	wget -c http://people.mozilla.org/~tglek/jyson-1.0.2.jar
