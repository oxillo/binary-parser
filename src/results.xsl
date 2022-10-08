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
            <xd:p>Retrieve the results of the result as a sequence of items</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>A sequence of items </xd:return>
    </xd:doc>
    <xsl:function name="bp:results" as="item()*" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="$parsing-context?results"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Get a result at position index in results pile</xd:p>
            <xd:p>Last result as index 1, result before as index 2,...</xd:p>
            <xd:p>If the parsing context has no result, it will returned the empty sequence</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="index">index of result to return; 1 for last result, 2 for the 2nd last,...</xd:param>
        <xd:return>The result in the parsing context or the empty sequence if no result
        </xd:return>
    </xd:doc>
    <xsl:function name="bp:result" as="item()?" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        <xsl:param name="index" as="xs:integer"/>
        
        <xsl:sequence select="reverse($parsing-context?results)[$index]"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Get the last result in the result pile</xd:p>
            <xd:p>Same as calling bp:result($parsing-context,1)</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>The last result in the parsing context or the empty sequence if no result</xd:return>
    </xd:doc>
    <xsl:function name="bp:result" as="item()?" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <!-- return the last result -->
        <xsl:sequence select="$parsing-context=>bp:result(1)"/>
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Append a result to the parsing context</xd:p>
            <xd:p>This item is generally the result of the parsing</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="value">Result to add</xd:param>
        <xd:return>Updated Parsing context</xd:return>
    </xd:doc>
    <xsl:function name="bp:push" as="map(xs:string,item()*)" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        <xsl:param name="value" as="item()"/>
        
        <xsl:sequence select="map:put($parsing-context, 'results', ($parsing-context?results,$value))"/>    
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Remove the last result from the parsing context</xd:p>
            <xd:p>If the parsing context has no result, it will returned unchanged</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="count">number of result to drop</xd:param>
        <xd:return>Updated Parsing context</xd:return>
    </xd:doc>
    
    <xsl:function name="bp:pop" as="map(xs:string,item()*)" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <!-- The parsing context has not enough results, return it unchanged -->
        <xsl:if test="count($parsing-context?results) eq 0">
            <xsl:sequence select="$parsing-context"/>    
        </xsl:if>
        <!-- The parsing context has results, drop the last 'count' results and return it -->
        <xsl:if test="count($parsing-context?results) ge $count">
            <xsl:variable name="new-results" select="subsequence($parsing-context?results, 1, count($parsing-context?results) - $count)"/>
            <xsl:sequence select="map:put($parsing-context, 'results', $new-results)"/>    
        </xsl:if>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Remove the last result from the parsing context</xd:p>
            <xd:p>If the parsing context has no result, it will returned unchanged</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>Updated Parsing context</xd:return>
    </xd:doc>
    <xsl:function name="bp:pop" as="map(xs:string,item()*)" visibility="public">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="bp:pop($parsing-context,1)"/>
    </xsl:function>
    
    
    
    
    
</xsl:stylesheet>