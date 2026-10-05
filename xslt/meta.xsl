<?xml version="1.0" encoding="UTF-8"?>
<!-- Statische, zweisprachige Seiten (data/meta/*.xml): je Sprache ein <div xml:lang="de|en"> -->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xsl tei xs">
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="string(.//tei:title[@type = 'main'][@xml:lang = 'de'][1])"/>
        <xsl:variable name="link" select="replace(string(tei:TEI/@xml:id), '\.xml$', '.html')"/>
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($doc_title, ' – ', $project_short_title)"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"/>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="index.html"><xsl:value-of select="$project_short_title"/></a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:for-each select=".//tei:title[@type = 'main']">
                                    <span class="lang-{@xml:lang}"><xsl:value-of select="."/></span>
                                </xsl:for-each>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1>
                            <xsl:for-each select=".//tei:title[@type = 'main']">
                                <span class="lang-{@xml:lang}"><xsl:value-of select="."/></span>
                            </xsl:for-each>
                        </h1>
                        <div class="meta-text">
                            <xsl:apply-templates select=".//tei:body"/>
                        </div>
                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="$link"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:body"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:div[@xml:lang]">
        <div class="lang-{@xml:lang}" lang="{@xml:lang}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:div"><div><xsl:apply-templates/></div></xsl:template>
    <xsl:template match="tei:head"><h2 class="h4 mt-4"><xsl:apply-templates/></h2></xsl:template>
    <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
    <xsl:template match="tei:list"><ul><xsl:apply-templates/></ul></xsl:template>
    <xsl:template match="tei:item"><li><xsl:apply-templates/></li></xsl:template>
    <xsl:template match="tei:ref"><a href="{@target}"><xsl:apply-templates/></a></xsl:template>
    <xsl:template match="tei:hi"><em><xsl:apply-templates/></em></xsl:template>
    <xsl:template match="tei:lb"><br/></xsl:template>
</xsl:stylesheet>
