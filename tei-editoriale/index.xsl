<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
<xsl:output method="html" encoding="utf8"/>


    <xsl:template match="page">
      <div>
        <h1>
                <xsl:value-of select="projet"/>
            </h1>  
        <h2>
                <xsl:value-of select="titre"/>
            </h2>
        <h4>
                <xsl:value-of select="salutation"/>
            </h4>
        <xsl:apply-templates select="texte"/>
      </div>
    </xsl:template>
      
    <xsl:template match="texte">
        <h3> <xsl:value-of select="partie"/>
        </h3>
        <xsl:for-each select="paragraphe">
        <p> <xsl:value-of select="."/> </p>
        </xsl:for-each>
    </xsl:template>
    
      
      
</xsl:stylesheet>