<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:bin="http://expath.org/ns/binary"
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
            <xd:p>Return the parser configuration</xd:p>
            <xd:p>If the parsing context has no result, it will returned unchanged</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>A map of configuration properties</xd:return>
    </xd:doc>
    <xsl:function name="bp:config-get" as="map(xs:string,item()*)">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="$parsing-context?config"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Set the parser configuration</xd:p>
            <xd:p>The remaining items of the parser contex are not modified</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="new-configuration">The new configuration of the parser</xd:param>
        <xd:return>A map of configuration properties</xd:return>
    </xd:doc>
    <xsl:function name="bp:config-set" as="map(xs:string,item()*)">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        <xsl:param name="new-configuration" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="$parsing-context=>map:put('config',$new-configuration)"/>
    </xsl:function>
    
    
</xsl:stylesheet>