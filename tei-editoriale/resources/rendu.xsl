<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">

<xsl:output indent="yes"/>

    <xsl:template match="/">
        
        <h3>
            <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title"/>
        </h3>
        <h4>Metadonnées</h4>
        <table border="1">
         
         <tr>
             <th>Titre</th>
             <th>Auteur</th>
             <th>Licence</th>             
             <th>Date de la publication</th>
             <th>Source</th>
             <th>Description</th>
             <th>Date de la source</th> 
         </tr>
         
        <tr>
            <td>
                    <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title"/>
                </td>
            <td>
                    <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:author"/>
                </td>
            <td>
                    <xsl:value-of select="//tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
                </td>
            <td>
                    <xsl:value-of select="//tei:publicationStmt/tei:date"/>
                </td>
            <td>
                    <xsl:value-of select="//tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:availability/tei:licence/@target"/>
                </td>
            <td>
                    <xsl:value-of select="//tei:encodingDesc/tei:projectDesc/tei:p"/>
                </td>
            <td>
                    <xsl:value-of select="//tei:profileDesc/tei:creation/tei:date"/>
                </td>
        </tr>
        </table>
        
         <h4>Contenu de texte</h4>
            <xsl:choose>
                <xsl:when test="//tei:div[@n='1']">
                    <xsl:apply-templates select="//tei:div[@n='1']"/> 
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="//tei:div[@n='2']"/> 
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
               
    <xsl:template match="//tei:div[@n='1']">
        <h5>
           <xsl:value-of select="tei:head"/> 
        </h5>
            <xsl:apply-templates select="tei:div[@n='2']"/> 
    </xsl:template>
    
    <xsl:template match="//tei:div[@n='2']">
        <h6>
            <xsl:value-of select="tei:head"/>
        </h6>
        <p>
            <xsl:value-of select="tei:p"/>
        </p>
    </xsl:template>
    
</xsl:stylesheet>