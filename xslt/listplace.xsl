<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl tei xs"
    version="2.0">
    <xsl:import href="./partials/register_common.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:call-template name="register_page">
            <xsl:with-param name="page" select="'listplace.html'"/>
            <xsl:with-param name="title_key" select="'reg__places_title'"/>
            <xsl:with-param name="title" select="'Ortsregister'"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
