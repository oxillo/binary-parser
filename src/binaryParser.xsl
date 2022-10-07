<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:bin="http://expath.org/ns/binary"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:bp="urn://binary-parser"
    
    exclude-result-prefixes="xs xd bin map bp"
    version="3.0">
    <xd:doc scope="stylesheet">
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
    
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Read 'count' octets from parsing context data</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:param name="count">Number of octets to read</xd:param>
        <xd:return>Read octets are removed from data and pushed to results</xd:return>
    </xd:doc>
    <xsl:function name="bp:read" as="map(xs:string,item()*)">
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
            <xd:p>Retrieve the results of the result as a sequence of items</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>A sequence of items </xd:return>
    </xd:doc>
    <xsl:function name="bp:results" as="item()*">
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
    <xsl:function name="bp:result" as="item()?">
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
    <xsl:function name="bp:result" as="item()?">
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
    <xsl:function name="bp:push" as="map(xs:string,item()*)">
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
    
    <xsl:function name="bp:pop" as="map(xs:string,item()*)">
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
    <xsl:function name="bp:pop" as="map(xs:string,item()*)">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="bp:pop($parsing-context,1)"/>
    </xsl:function>
    
    
    
    
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
    
    
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Check if the parser has data </xd:p>
            <xd:p>The parsing context is not modified</xd:p>
        </xd:desc>
        <xd:param name="parsing-context">Parsing context</xd:param>
        <xd:return>true is parser still has data</xd:return>
    </xd:doc>
    <xsl:function name="bp:hasdata" as="xs:boolean">
        <xsl:param name="parsing-context" as="map(xs:string,item()*)"/>
        
        <xsl:sequence select="bin:length($parsing-context?data) gt 0"/>
    </xsl:function>

    
</xsl:stylesheet>