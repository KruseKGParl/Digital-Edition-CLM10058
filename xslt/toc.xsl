<?xml version="1.0" encoding="UTF-8"?>
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
        <xsl:variable name="doc_title" select="'Blattübersicht'"/>
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($doc_title, ' – ', $project_short_title)"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="'toc.html'"/>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <nav aria-label="breadcrumb" class="container page-breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="index.html"><xsl:value-of select="$project_short_title"/></a></li>
                            <li class="breadcrumb-item active" aria-current="page" data-i18n="navbar__toc">Blattübersicht</li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1 class="page-title" data-i18n="navbar__toc">Blattübersicht</h1>
                        <div class="table-wrap"><table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th scope="col" data-i18n="toc__fol">Blatt</th>
                                    <th scope="col" data-i18n="toc__incipit">Textbeginn</th>
                                    <th scope="col" class="text-end" data-i18n="toc__persons">Personen</th>
                                    <th scope="col" class="text-end" data-i18n="toc__places">Orte</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="collection('../data/editions?select=fol*.xml')/tei:TEI">
                                    <xsl:sort select="@xml:id"/>
                                    <xsl:variable name="f" select="replace(@xml:id, '\.xml$', '.html')"/>
                                    <tr>
                                        <td class="text-nowrap"><a href="{$f}"><i class="bi bi-link-45deg"></i> <xsl:value-of select="tei:teiHeader//tei:title[1]"/></a></td>
                                        <td class="fst-italic text-muted small" lang="la">
                                            <xsl:variable name="txt" select="normalize-space(string-join(.//tei:body//tei:p[1]//text(), ''))"/>
                                            <xsl:value-of select="concat(substring($txt, 1, 90), if (string-length($txt) gt 90) then ' …' else '')"/>
                                        </td>
                                        <td class="text-end"><xsl:value-of select="count(.//tei:persName[@ref])"/></td>
                                        <td class="text-end"><xsl:value-of select="count(.//tei:placeName[@ref])"/></td>
                                    </tr>
                                </xsl:for-each>
                                <tr class="table-light">
                                    <td class="text-nowrap"><a href="karte.html"><i class="bi bi-globe-europe-africa"></i> <span data-i18n="navbar__map">Karte</span></a></td>
                                    <td class="text-muted small" data-i18n="toc__map_note">Kartenseite (Mappa Mundi)</td>
                                    <td class="text-end">–</td>
                                    <td class="text-end">–</td>
                                </tr>
                            </tbody>
                        </table></div>
                        <div>
                            <xsl:call-template name="blockquote"><xsl:with-param name="pageId" select="'toc.html'"/></xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
