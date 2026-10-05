<?xml version="1.0" encoding="UTF-8"?>
<!-- Zugriff auf die Register (data/indices) aus beliebigen Stylesheets:
     tei:register_entry('asi1') liefert das tei:place bzw. tei:person mit dieser xml:id. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei"
    version="2.0">

    <xsl:variable name="reg_place" select="document('../../data/indices/listplace.xml')"/>
    <xsl:variable name="reg_person" select="document('../../data/indices/listperson.xml')"/>
    <xsl:key name="reg" match="tei:person | tei:place" use="@xml:id"/>

    <xsl:function name="tei:register_entry" as="element()?">
        <xsl:param name="id" as="xs:string"/>
        <xsl:sequence select="(key('reg', $id, $reg_place), key('reg', $id, $reg_person))[1]"/>
    </xsl:function>

    <xsl:function name="tei:auth_label" as="xs:string">
        <xsl:param name="scheme" as="xs:string?"/>
        <xsl:sequence select="if ($scheme = 'wikidata') then 'Wikidata'
            else if ($scheme = 'viaf') then 'VIAF'
            else if ($scheme = 'gnd') then 'GND'
            else if ($scheme = 'tgn') then 'Getty TGN'
            else 'Link'"/>
    </xsl:function>
</xsl:stylesheet>
