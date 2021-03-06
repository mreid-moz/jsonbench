JARS=jackson-core-2.1.4.jar jackson-databind-2.1.4.jar jackson-annotations-2.1.4.jar
space :=
space +=
comma :=,
JARS_CP=$(subst $(space),:,$(JARS))
JSON=./big_jsonbench_sample.txt
PYTHON_JSON=json
PYTHON_CMD=python
JYTHON_JSON=com.xhaus.jyson.JysonCodec
SPIDERMONKEY=~/obj/js
LIMIT=cat
CPUS=$(foreach proc,$(shell grep processor /proc/cpuinfo|$(LIMIT)|sed 's/[: \t]/_/g'),$(proc).cxx)
export GOPATH := $(PWD)/gojson

echo:
	echo $(CPUS)
node:
	node node.js $(JSON)

jython: jython-standalone-2.7-b1.jar jyson-1.0.2.jar
	$(MAKE) python PYTHON_CMD="java  -jar $< -Dpython.path=jyson-1.0.2.jar" PYTHON_JSON=$(JYTHON_JSON)
 
python:
	$(PYTHON_CMD) loadjson.py $(PYTHON_JSON) < $(JSON)

python_simplejson:
	$(MAKE) python PYTHON_JSON=simplejson

python_rapidjson:
	$(MAKE) python PYTHON_JSON=rapidjson

python_ujson:
	$(MAKE) python PYTHON_JSON=ujson

spidermonkey:
	$(SPIDERMONKEY) -f spidermonkey.js < $(JSON)

json: json.cpp json.h rapidjson
	c++ -Wall -O3 json.cpp -o json -Irapidjson/include

go:
	go install jsonbench
	$(GOPATH)/bin/jsonbench $(JSON)

rust:
	rustc -O rust.rs && ./rust  < $(JSON)

sample-data:
	tar xzvf jsonbench_sample.tar.gz
	for f in $$(seq 1 1500); do cat jsonbench_sample.txt >> big_jsonbench_sample.txt; done

%.cxx:
	FOO=$@ ./json < $(JSON)

cxx-proc: $(CPUS)
	echo all done
cxx: json
	 ./json < $(JSON)

javac: $(JARS)
	javac -cp $(JARS_CP) JSON.java

java: javac
	java -cp $(JARS_CP):. JSON < $(JSON)

java_tokenize: javac
	java -cp $(JARS_CP):. JSON tokenize < $(JSON)

jackson-core-2.1.4.jar:
	wget -c http://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.1.4/jackson-core-2.1.4.jar

jackson-databind-2.1.4.jar:
	wget -c http://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.1.4/jackson-databind-2.1.4.jar

jackson-annotations-2.1.4.jar:
	wget -c http://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.1.4/jackson-annotations-2.1.4.jar

jython-standalone-2.7-b1.jar:
	wget -c http://repo1.maven.org/maven2/org/python/jython-standalone/2.7-b1/jython-standalone-2.7-b1.jar

jyson-1.0.2.jar:
	wget -c http://people.mozilla.org/~tglek/jyson-1.0.2.jar

rapidjson:
	wget -c http://rapidjson.googlecode.com/files/rapidjson-0.11.zip
	unzip rapidjson-0.11.zip
