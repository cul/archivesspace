<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="xs marc"
    version="2.0">
<!--  this stylesheet will take OAI marc records from the Columbia University Libraries ArchivesSpace instance and clean them up for Voyager import. v1 KS 2018-06-13  -->
   
<!--    three templates copy everything sans namespace -->
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- template to copy attributes -->
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- template to copy the rest of the nodes -->
    <xsl:template match="comment() | text() | processing-instruction()">
        <xsl:copy/>
    </xsl:template>
<!--    end three templates     -->
    
    
<!--  remove elements without content (extra 035 and 040s etc being exported by AS for some reason) -->
    <xsl:template match="marc:datafield[not(marc:subfield)]">
<!--        do nothing  -->
    </xsl:template>
    
<!--    reorder elements -->
    <!-- Grab the record, copy the leader and sort the control and data fields. -->
    <xsl:template match="marc:record">
        <record>
        <xsl:element name="leader">
            <xsl:value-of select="marc:leader"/>
        </xsl:element>
        <xsl:element name="controlfield">
            <xsl:attribute name="tag">008</xsl:attribute>
            <xsl:value-of select="marc:controlfield"/>
        </xsl:element>
            
            <xsl:for-each select="marc:datafield">
                <xsl:sort select="@tag"/>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </record>
    </xsl:template>
    
<!--    remove colons from beginning of fields -->
    <xsl:template match="marc:subfield[starts-with(., ':')]">
        <xsl:element name="subfield">
            <xsl:attribute name="code">
                <xsl:value-of select="@code"/>
            </xsl:attribute>
        <xsl:copy-of select="translate(., ':', '')"/>
        </xsl:element>
    </xsl:template>
    
<!--    for LTI, remove 500 fields-->
    
</xsl:stylesheet>