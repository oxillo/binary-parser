<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:bin="http://expath.org/ns/binary"
    xmlns:bp="urn://binary-parser"
    exclude-result-prefixes="xs xd"
    extension-element-prefixes="bp"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 8, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b>XILLO Olivier</xd:p>
            <xd:p>A stylesheet to test the binary-parser package</xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:use-package name="binary-parser" package-version="1.0"/>
    
    <xsl:template name="png2xml" expand-text="yes">
        <xsl:variable name="data" select="bp:from-file('data/simple.png')"/>
        
        <xsl:variable name="header" select="$data=>bp:read(8)=>bp:result()=>bp:from-data()"/>
        
        <xsl:variable name="headerfields" select="$header=>bp:read(1)=>bp:read(3)=>bp:read(2)=>bp:read(1)=>bp:read(1)"/>
        <header>
            <field pos="1" value="{$headerfields=>bp:result(5)}"/>                 
            <field pos="2" value="{$headerfields=>bp:result(4)=>bin:decode-string()}"/>
            <field pos="3" value="{$headerfields=>bp:result(3)}"/>
            <field pos="4" value="{$headerfields=>bp:result(2)}"/>
            <field pos="5" value="{$headerfields=>bp:result(1)}"/>
        </header>
    </xsl:template>
</xsl:stylesheet>