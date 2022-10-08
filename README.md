# binary-parser
a XSLT package to parse binary data in XSLT

## Description

This XSLT package provides functions to easily parse binary data in XSLT. 
To use this package, you'll need a processor that :
  - complies with XSLT 3.0
  - support EXPATH file module
  - support EXPATH binary module
 
 As of today, this has only been tested with Saxon PE 11.4.

## Installation

TODO

## How to use

For use with Saxon, you need to create/update the [saxon configuration file](https://www.saxonica.com/documentation11/index.html#!configuration/configuration-file)
to add a reference to the binary-parser package in the xsltPackages element.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration xmlns="http://saxon.sf.net/ns/configuration"
    label="Binary Parser" edition="PE">
    
    <xsltPackages>
        <package name="binary-parser" version="1.0" sourceLocation="binaryParser.xsl"/>
    </xsltPackages>  
    
</configuration>
````
