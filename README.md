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

Copy all files from the 'src' folder somewhere into your project.
Configure Saxon to be able to find the package by editing the [Saxon configuration file](https://www.saxonica.com/documentation11/index.html#!configuration/configuration-file).
Add a reference to the 'binary-parser' package in the [`<xsltPackages>`](https://www.saxonica.com/documentation11/index.html#!configuration/configuration-file/config-xsltPackages)  element and set the `sourceLocation` according to your project.
You Saxon configuration file may look like the following :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration xmlns="http://saxon.sf.net/ns/configuration"
    label="My super project using Binary Parser" edition="PE">
    
    <xsltPackages>
        <package name="binary-parser" version="1.0" sourceLocation="binary-parser/binaryParser.xsl"/>
    </xsltPackages>  
    
</configuration>
```

## How to use

binary-parser package provides several functions in the "urn://binary-parser" namespace.

Add this namespace to your stylesheet and define as an extension prefix.

Remember that your stylesheet version must be 3.0 as XSLT packages are required.

Finally, add the `<xsl:use-package>` element to use the binary-parser package.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bp="urn://binary-parser"
    extension-element-prefixes="bp"
    version="3.0">
    
    <xsl:use-package name="binary-parser" package-version="1.0"/>
</xsl:stylesheet>
```

### Initializing the parsing context

A parsing context can be created with :
  - bp:from-file( $file as xs:string) 
  - bp:from-data( $data as xs:base64Binary)

```xml
<xsl:variable name="png-file" select="bp:from-file('simple.png')"/>
```

### Parsing data

binary-parser only provide the bp:read($context, $count as xs:integer) function.
This funtion moves `count` bytes from the data to the `results` pile.

```xml
<!-- parse the PNG header (8 bytes) -->
<xsl:variable name="png-chunks" select="bp:read($png-file, 8)"/>
<!-- The header is now available in the results -->
<xsl:variable name="png-header" select="bp:result($png-chunks)"/>
<!-- further calls to bp:read on $png-chunks will retrieve chunks data -->
```

### Working with results

The parsing context holds a `results` pile that carry the already parsed data. The bp:results($context) will return the full pile whereas bp:result($context,$pos as xs:integer) will just return the result at position `pos` from the end. 

bp:pop($context) will remove the last result; bp:push($context, $value) will add a new value to the result pile.

```xml
<!-- parse the PNG header (14 bytes) -->
<xsl:variable name="header" select="bp:from-data(bin:hex('89504e470d0a1a0d'))"/>
<xsl:variable name="parsed" select="$header=>bp:read(1)=>bp:read(3)=>bp:read(2)=>bp:read(1)=>bp:read(1)"/>
<!-- bp:results($parsed) is (bin:hex('89'),bin:hex('504e47'),bin:hex('0d0a'),bin:hex('1a'),bin:hex('0d')) but we just want to keep the 3 bytes field converted as a string -->
<xsl:variable name="cleaned" select="$parsed=>bp:pop()=>bp:pop()=>bp:pop()=>bp:pop()=>bp:pop()=>bp:push(bp:result($parsed,4)=>bin:decode-string())"/>
<!-- bp:results($cleaned) is now ('PNG') -->
```

An alternative to the previous is
```xml
<!-- parse the PNG header (14 bytes) -->
<xsl:variable name="header" select="bp:from-data(bin:hex('89504e470d0a1a0d'))"/>
<xsl:variable name="parsed" select="$header=>bp:read(1)=>bp:pop()=>bp:read(3)=>bp:read(2)=>bp:pop()=>bp:read(1)=>bp:pop()=>bp:read(1)=>bp:pop()"/>
<!-- bp:results($parsed) is now (bin:hex('504e47')) but we just need to convert as a string -->
<xsl:variable name="cleaned" select="$parsed=>bp:pop()=>bp:push(bp:result($parsed,1)=>bin:decode-string())"/>
<!-- bp:results($cleaned) is now ('PNG') -->
```
