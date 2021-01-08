<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"    
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    exclude-result-prefixes="xs">
    <xsl:output method="xml" indent="yes"/>    
    
    <xsl:template match="office:document-meta">
        <xsl:apply-templates select="office:meta"/>
    </xsl:template>
    
    <xsl:template match="office:meta">
        <TEI xmlns="http://www.tei-c.org/ns/1.0"
            xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
            xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"    
            xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
            >
            <!-- Traitement de la métadonnée -->
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>   
                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Titre')]"/>
                        </title>
                        <author>
                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Auteur')]"/>
                        </author>
                    </titleStmt>  
                    
                    <editionStmt>
                        <edition/>
                    </editionStmt>
                    
                    <publicationStmt>
                        <authority/>
                        <publisher/>
                        <availability>
                            <licence target="">
                                <xsl:attribute name="target">
                                    <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Licence')]"/> 
                                </xsl:attribute>
                            </licence>
                        </availability>
                        <date>
                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Date de publication')]"/>
                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Date de la publication')]"/>
                        </date>
                    </publicationStmt>
                    
                    <sourceDesc>
                        <biblFull>
                            <titleStmt>
                                <title>   
                                    <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Titre')]"/>
                                </title>
                                <author>
                                    <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Auteur')]"/>
                                </author>
                            </titleStmt>  
                            
                            <publicationStmt>
                                <publisher/>
                                <availability>
                                    <licence target="">
                                        <xsl:attribute name="target">
                                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Source')]"/> 
                                        </xsl:attribute>
                                    </licence>
                                </availability>
                            </publicationStmt>
                            
                        </biblFull>
                    </sourceDesc>
                    
                </fileDesc>       
                
                <encodingDesc>
                    <projectDesc>
                        <p>
                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Description')]"/>
                        </p>
                    </projectDesc>
                </encodingDesc>
                
                <profileDesc>
                    <creation>
                        <date>
                            <xsl:value-of select="meta:user-defined[contains(@meta:name/data(),'Date de la source')]"/>
                        </date>
                    </creation>
                </profileDesc>
            </teiHeader>
            
            <!-- Traitement du style -->
            <text>   
                <body>
                    <head>
                        <xsl:value-of select="meta:textp('Title')"/>
                    </head>
                    

                    <xsl:variable name="chemin" select="document('/Users/wq/documents-structures/projet-documents-structures/transformation/input/content.xml')/office:document-content/office:body/office:text/text:h[contains(@text:style-name/data(),'Heading_20_1')]"/>
                    <xsl:variable name="chemin2" select="document('/Users/wq/documents-structures/projet-documents-structures/transformation/input/content.xml')/office:document-content/office:body/office:text/text:h[contains(@text:style-name/data(),'Heading_20_2')]"/>
                    
                    <xsl:choose>
                        <!-- 1ère condition: le body commence par <text:h text:style-name="Heading_20_1"> et suit par <text:h text:style-name="Heading_20_2"> -->
                        <xsl:when test="$chemin">
                            <xsl:for-each select="$chemin">
                                <div n="">
                                    <xsl:attribute name="n"><xsl:value-of select="attribute::text:outline-level"/></xsl:attribute>                          
                                    <head><xsl:value-of select="self::*"/></head>
                                    
                                    <quote>
                                        <xsl:value-of select="following-sibling::text:p[@text:style-name='citation'][1]"/>
                                        
                                        <xsl:for-each select="following-sibling::text:p[@text:style-name='citation'][1]/text:span">                                    
                                                <hi>
                                                    <xsl:attribute name="rend" select="attribute::text:style-name"/>
                                                    <xsl:value-of select="text()"/>
                                                </hi>              
                                        </xsl:for-each>
                                    </quote>
                                    
                                    <xsl:variable name="head" select="generate-id(.)"/>
                                    <xsl:for-each select="$chemin2[generate-id(preceding-sibling::text:h[contains(@text:style-name/data(),'Heading_20_1')][1]) = $head]">
                                        <div n="">                          
                                            <xsl:attribute name="n"><xsl:value-of select="attribute::text:outline-level"/></xsl:attribute>
                                            <head><xsl:value-of select="child::text()"/></head>    
                                            
                                            <xsl:variable name="p" select="generate-id(.)"/>                                                
                                            <xsl:for-each select="following-sibling::text:p[@text:style-name='Text_20_body'][generate-id(preceding-sibling::text:h[@text:style-name='Heading_20_2'][1]) = $p]">                                                        
                                                <p>
                                                    <xsl:value-of select="self::*"/>
                                                    <xsl:choose>
                                                        <xsl:when test="child::text:span">                                               
                                                            <hi>
                                                                <xsl:attribute name="rend" select="text:span/attribute::text:style-name"/>
                                                                <xsl:value-of select="text:span/text()"/>
                                                            </hi>              
                                                        </xsl:when>                                           
                                                    </xsl:choose>
                                                </p>
                                            </xsl:for-each>
                                        </div>
                                        
                                    
                                    </xsl:for-each>
                                        </div>
                                    </xsl:for-each>
                        </xsl:when>   
                        
                        <!-- 2ème condition(else): le body commence par <text:h text:style-name="Heading_20_2"> -->
                        <xsl:otherwise>
                            <xsl:for-each select="$chemin2">
                                <div n="">                          
                                    <xsl:attribute name="n"><xsl:value-of select="attribute::text:outline-level"/></xsl:attribute>
                                    <head><xsl:value-of select="child::text()"/></head>    
                                    
                                    <xsl:variable name="p" select="generate-id(.)"/>                                                
                                    <xsl:for-each select="following-sibling::text:p[@text:style-name='Text_20_body'][generate-id(preceding-sibling::text:h[@text:style-name='Heading_20_2'][1]) = $p]">                                                        
                                        <p>
                                            <xsl:value-of select="self::*"/>
                                            <xsl:choose>
                                                <xsl:when test="child::text:span">                                               
                                                    <hi>
                                                        <xsl:attribute name="rend" select="text:span/attribute::text:style-name"/>
                                                        <xsl:value-of select="text:span/text()"/>
                                                    </hi>              
                                                </xsl:when>                                           
                                            </xsl:choose>
                                        </p>
                                    </xsl:for-each>
                                </div>
                            </xsl:for-each>
                        </xsl:otherwise>
                                                
                    </xsl:choose>                    
                </body> 
            </text> 
        </TEI>
    </xsl:template>
    
    <xsl:function name="meta:textp" as="xs:string">
        <xsl:param name="style" as="xs:string" required="yes"/>
        <xsl:variable name="chemin"><xsl:value-of select="concat('/Users/wq/documents-structures/projet-documents-structures/transformation/input', '/content.xml')"/></xsl:variable>
        <xsl:value-of select="document($chemin)/office:document-content/office:body/office:text/text:p[contains(@text:style-name/data(),$style)]"/>
    </xsl:function>
    
</xsl:stylesheet>

