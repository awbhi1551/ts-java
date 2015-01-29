Feature: TypeScript generator for node-java

As a Node.js + TypeScript + node-java developer
I want to have TypeScript declaration (.d.ts) files java packages I use
so that I can use javascript with type safety comparable to java type safety.

  Scenario: Package declaration only
    Given the default TinkerPop packages
    And the following sample program:
    """
    ///<reference path='./java.d.ts'/>

    """
    Then it compiles and lints cleanly

  Scenario: Hello World
    Given the default TinkerPop packages
    And the following sample program:
    """
    /// <reference path='../o/java.d.ts'/>
    /// <reference path='../typings/node/node.d.ts' />
    /// <reference path='../typings/glob/glob.d.ts' />

    import glob = require('glob');
    import nodejava = require('java');

    var filenames = glob.sync('tinkerpop/target/dependency/**/*.jar');
    filenames.forEach((name: string) => { nodejava.classpath.push(name); });

    // TODO: this test is still awkward. Make it better.
    var newArray: Java.java.util.ArrayList = nodejava.newInstanceSync('java.util.ArrayList');
    var obj: Java.java.lang.Object = nodejava.newInstanceSync('java.lang.String', 'hello');
    newArray.addSync(obj);
    newArray.addSync(nodejava.newInstanceSync('java.lang.String', 'world'));
    console.log(newArray.toStringSync());

    """
    Then it compiles and lints cleanly
    And it runs and produces output:
    """
    [hello, world]

    """

  Scenario: TinkerGraph Query
    Given the default TinkerPop packages
    And the following sample program:
    """
    /// <reference path='../o/java.d.ts'/>
    /// <reference path='../typings/node/node.d.ts' />
    /// <reference path='../typings/glob/glob.d.ts' />

    import glob = require('glob');
    import nodejava = require('java');

    var filenames = glob.sync('tinkerpop/target/dependency/**/*.jar');
    filenames.forEach((name: string) => { nodejava.classpath.push(name); });

    var tinkerFactoryClassName = 'com.tinkerpop.gremlin.tinkergraph.structure.TinkerFactory';
    var TinkerFactory: Java.TinkerFactory.Static = nodejava.import(tinkerFactoryClassName);
    var g: Java.TinkerGraph = TinkerFactory.createClassicSync();

    // These two definitions illustrate how to use newArray() to create a parameter for a varargs argument.
    // This is awkward due to a limitation in node-java's ability to map a function call to the correct
    // method variant for methods with varargs. We may be able to fix this in node-java, though most likely
    // this will be something we address in 'wrapper' classes.
    var noargs: Java.Array<Java.Object> = nodejava.newArray<Java.Object>('java.lang.Object', []);
    var props: Java.Array<Java.String> = nodejava.newArray<Java.String>('java.lang.String', ['name', 'age']);

    var vertList: Java.List = g.VSync(noargs).valuesSync(props).toListSync();
    console.log(vertList.toStringSync());

    """
    Then it compiles and lints cleanly
    And it runs and produces output:
    """
    [marko, 29, vadas, 27, lop, josh, 32, ripple, peter, 35]

    """

  Scenario: Varargs Negative Test
    Given the default TinkerPop packages
    And the following sample program:
    """
    /// <reference path='../o/java.d.ts'/>
    /// <reference path='../typings/node/node.d.ts' />
    var g: Java.TinkerGraph;
    var s: Java.String;
    g.VSync(s);
    """
    When compiled it produces this error containing this snippet:
    """
    error TS2345: Argument of type 'String' is not assignable to parameter of type
    """
