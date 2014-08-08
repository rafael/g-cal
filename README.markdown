g-Cal is a simple and effective way to synchronize your google calendar with 
our iPhone. The user interface is designed in an apple-like manner, 
so you don’t have to get used to anything new. 


This app is also under GPL license so if you buy it you will have access to 
the code! You will be able to add your own features!

g-Cal is also intended to be used with a google account, 
if you don’t have one or you don’t use google’s calendar 
this app is not for you. 


The app’s main features are the following:

* See all the calendars associated with your google account 
 (owned or not owned by you).
* Create, edit and delete events from all your google calendars
* See events while offline.
* Show events of an specific calendar.
* Month view for your events.

Linking the other libraries instructions:

 1. Parse a JSON string into its Abstract Syntax Tree (AST) representation
    
    ```scala
    val source = """{ "some": "JSON source" }"""
    val jsonAst = source.parseJson // or JsonParser(source)
    ```
    
 2. Print a JSON AST back to a String using either the `CompactPrinter` or the `PrettyPrinter`
    
    ```scala
    val json = jsonAst.prettyPrint // or .compactPrint
    ```
    
 3. Convert any Scala object to a JSON AST using the pimped `toJson` method
    
    ```scala
    val jsonAst = List(1, 2, 3).toJson
    ```
    
 4. Convert a JSON AST to a Scala object with the `convertTo` method
    
    ```scala
    val myObject = jsonAst.convertTo[MyObjectType]
    ```

