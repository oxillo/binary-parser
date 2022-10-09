<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:bin="http://expath.org/ns/binary"
    xmlns:file="http://expath.org/ns/file"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:bp="urn://binary-parser"
    exclude-result-prefixes="xs xd bin map bp"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 08, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b>XILLO Olivier</xd:p>
            <xd:p>Collection of functions to manage results of binary content parsing</xd:p>
            <xd:p>Results are managed as a LIFO pile. It is possible to :
                <xd:ul>
                    <xd:li>Get results value with bp:results or bp:result</xd:li>
                    <xd:li>Add a result with bp:push</xd:li>
                    <xd:li>Remove last results with bp:pop</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Read 'count' octets from parsing context data</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="count">Number of octets to read</xd:param>
        <xd:return>Read octets are removed from data and pushed to results</xd:return>
    </xd:doc>
    <xsl:function name="bp:read" as="map(xs:string,item()*)"  visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:variable name="context" as="map(xs:string,item()*)">
            <xsl:variable name="new-data" select="bin:part($parsing-context?data,$count)"/>
            <xsl:variable name="read-data" select="bin:part($parsing-context?data,0,$count)"/>
            <xsl:sequence select="$parsing-context=>map:put('data',$new-data)=>bp:push($read-data)"/>
        </xsl:variable>
        <xsl:sequence select="$context"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Check if the parser has data </xd:p>
            <xd:p>The parsing context is not modified</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>true is parser still has data</xd:return>
    </xd:doc>
    <xsl:function name="bp:hasdata" as="xs:boolean" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="bin:length($parsing-context?data) gt 0"/>
    </xsl:function>
    
    
    
    <xsl:function name="bp:from-data" as="map(xs:string,item()*)" visibility="public">
        <xsl:param name="data" as="xs:base64Binary"/>
        
        <xsl:sequence select="map{
            'data':$data,
            'config':map{},
            'results':()}"/>
    </xsl:function>
    
    <xsl:function name="bp:from-file" as="map(xs:string,item()*)" visibility="public">
        <xsl:param name="file" as="xs:string"/>
        
        <xsl:sequence select="file:read-binary($file)=>bp:from-data()"/>
    </xsl:function>
</xsl:stylesheet>