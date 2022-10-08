<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="binary-parser" package-version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:bin="http://expath.org/ns/binary"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:bp="urn://binary-parser"
    exclude-result-prefixes="xs xd bin map bp"
    version="3.0">
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 06, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b>XILLO Olivier</xd:p>
            <xd:p>Collection of functions to parse binary files</xd:p>
            <xd:p>Functions operate on a parsing context that is a map :
                <xd:ul>
                    <xd:li>'data' : the unparsed data</xd:li>
                    <xd:li>'results' : the result of parsed data as a sequence of item</xd:li>
                    <xd:li>'config' : the configuration of the parser that can be altered by parsing.</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:include href="data.xsl"/>
    <xsl:include href="config.xsl"/>
    <xsl:include href="results.xsl"/>
    
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Apply a function on the last result of the parsing context</xd:p>
            <xd:p>If the parsing context has no result, it will returned unchanged</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="fn">The function to apply on the last result</xd:param>
        <xd:return>Updated Parsing context</xd:return>
    </xd:doc>
    <xsl:function name="bp:applyFn" as="map(xs:string,item()*)">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        <xsl:param name="fn" as="function(item()) as item()"/>
        
        <!-- Return the parsing context unchanged if there are no result -->
        <xsl:if test="count($parsing-context?results) eq 0">
            <xsl:sequence select="$parsing-context"/>
        </xsl:if>
        
        <!-- Apply fn on the last result of the parsing context -->
        <xsl:if test="count($parsing-context?results) gt 0">
            <xsl:variable name="v" select="$parsing-context => bp:result() => $fn()"/>
            <!-- Replace in the parsing context -->
            <xsl:sequence select="$parsing-context=>bp:pop()=>bp:push( $v )"/>
        </xsl:if>
    </xsl:function>
    
    
    
    
    
    
    
    
    

    
</xsl:package>