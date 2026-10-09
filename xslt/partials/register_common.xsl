<?xml version="1.0" encoding="UTF-8"?>
<!-- Gemeinsame Bausteine für Personen- und Ortsregister:
     Listenseite (Tabulator) und je Eintrag eine Detailseite mit Belegstellen und Kartenverknüpfung. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl tei xs"
    version="2.0">

    <xsl:import href="./html_navbar.xsl"/>
    <xsl:import href="./html_head.xsl"/>
    <xsl:import href="./html_footer.xsl"/>
    <xsl:import href="./blockquote.xsl"/>
    <xsl:import href="./zotero.xsl"/>
    <xsl:import href="./register_lookup.xsl"/>

    <xsl:template name="register_page">
        <xsl:param name="page"/>      <!-- z. B. listplace.html -->
        <xsl:param name="title_key"/> <!-- i18n-Schlüssel der Überschrift -->
        <xsl:param name="title"/>
        <xsl:variable name="entries" select="//tei:person | //tei:place"/>
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($title, ' – ', $project_short_title)"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$page"/>
                    <xsl:with-param name="zoteroTitle" select="$title"/>
                </xsl:call-template>
                <link href="vendor/tabulator-tables/css/tabulator.min.css" rel="stylesheet"/>
                <link href="vendor/tabulator-tables/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <nav aria-label="breadcrumb" class="container page-breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="index.html"><xsl:value-of select="$project_short_title"/></a></li>
                            <li class="breadcrumb-item"><span data-i18n="navbar__register">Register</span></li>
                            <li class="breadcrumb-item active" aria-current="page"><span data-i18n="{$title_key}"><xsl:value-of select="$title"/></span></li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1 class="page-title" data-i18n="{$title_key}"><xsl:value-of select="$title"/></h1>
                        <p class="text-muted small"><span data-i18n="reg__mentions_hint">Belegstellen: Blatt, Spalte.Zeile</span></p>
                        <table id="regTable" class="table table-sm register-table" data-kind="{if (//tei:person) then 'person' else 'place'}">
                            <thead>
                                <tr>
                                    <th data-i18n="reg__name">Name</th>
                                    <th data-i18n="reg__type">Typ</th>
                                    <th data-i18n="reg__variants">Belegformen</th>
                                    <th data-i18n="reg__authority">Normdaten</th>
                                    <th data-i18n="reg__mentions">Belege</th>
                                    <th data-i18n="reg__map">Karte</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="$entries">
                                    <xsl:variable name="n" select="(tei:persName | tei:placeName)[1]"/>
                                    <tr>
                                        <td data-href="{@xml:id}.html"><xsl:value-of select="$n"/></td>
                                        <td data-type="{@type}"><xsl:value-of select="@type"/></td>
                                        <td><xsl:value-of select="string-join((tei:persName | tei:placeName)[@type = 'variant'], ', ')"/></td>
                                        <td>
                                            <xsl:for-each select="tei:idno">
                                                <a href="{.}" target="_blank" rel="noopener"><xsl:value-of select="tei:auth_label(@subtype)"/></a>
                                                <xsl:text> </xsl:text>
                                            </xsl:for-each>
                                        </td>
                                        <td><xsl:value-of select="count(tei:noteGrp/tei:note[@type = 'mentions'])"/></td>
                                        <td><xsl:value-of select="count(tei:noteGrp/tei:note[@type = 'map'])"/></td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <div>
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="$page"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script type="text/javascript" src="vendor/tabulator-tables/js/tabulator.min.js"></script>
                <script src="js/register.js"></script>
            </body>
        </html>
        <!-- Detailseiten -->
        <xsl:for-each select="$entries">
            <xsl:variable name="filename" select="concat(@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space((tei:persName | tei:placeName)[1])"/>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="{$default_lang}">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="concat($name, ' – ', $project_short_title)"/>
                        </xsl:call-template>
                        <xsl:call-template name="zoterMetaTags">
                            <xsl:with-param name="pageId" select="$filename"/>
                            <xsl:with-param name="zoteroTitle" select="$name"/>
                        </xsl:call-template>
                    </head>
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                            <nav aria-label="breadcrumb" class="container page-breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="index.html"><xsl:value-of select="$project_short_title"/></a></li>
                                    <li class="breadcrumb-item"><a href="{$page}" data-i18n="{$title_key}"><xsl:value-of select="$title"/></a></li>
                                    <li class="breadcrumb-item active" aria-current="page"><xsl:value-of select="$name"/></li>
                                </ol>
                            </nav>
                            <div class="container">
                                <h1 class="mb-1"><xsl:value-of select="$name"/></h1>
                                <p class="text-muted">
                                    <span data-i18n="{if (self::tei:person) then 'ent__person' else 'ent__place'}"></span>
                                    <xsl:if test="@type"> · <span data-i18n="type__{@type}"><xsl:value-of select="@type"/></span></xsl:if>
                                </p>
                                <xsl:call-template name="register_detail"/>
                                <div>
                                    <xsl:call-template name="blockquote">
                                        <xsl:with-param name="pageId" select="$filename"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="register_detail">
        <dl class="row detail-list">
            <xsl:if test="(tei:persName | tei:placeName)[@type = 'variant']">
                <dt class="col-sm-3" data-i18n="ent__variants">Belegformen</dt>
                <dd class="col-sm-9"><xsl:value-of select="string-join((tei:persName | tei:placeName)[@type = 'variant'], ', ')"/></dd>
            </xsl:if>
            <dt class="col-sm-3" data-i18n="ent__authority">Normdaten</dt>
            <dd class="col-sm-9">
                <xsl:for-each select="tei:idno">
                    <a href="{.}" target="_blank" rel="noopener"><xsl:value-of select="tei:auth_label(@subtype)"/> <i class="bi bi-box-arrow-up-right small"></i></a>
                    <xsl:text> </xsl:text><span class="text-muted small"><xsl:value-of select="."/></span>
                    <br/>
                </xsl:for-each>
                <xsl:if test="not(tei:idno)"><span class="text-muted" data-i18n="ent__no_authority">keine Normdaten</span></xsl:if>
            </dd>
            <dt class="col-sm-3"><span data-i18n="ent__mentions">Belege im Text</span> (<xsl:value-of select="count(tei:noteGrp/tei:note[@type = 'mentions'])"/>)</dt>
            <dd class="col-sm-9">
                <xsl:choose>
                    <xsl:when test="tei:noteGrp/tei:note[@type = 'mentions']">
                        <xsl:for-each-group select="tei:noteGrp/tei:note[@type = 'mentions']" group-by="@n">
                            <div class="mb-1">
                                <a class="fw-semibold me-2" href="fol{current-grouping-key()}.html">fol. <xsl:value-of select="current-grouping-key()"/></a>
                                <xsl:for-each select="current-group()">
                                    <a class="me-3 text-nowrap" href="{replace(@target, '\.xml#', '.html#')}">
                                        <xsl:value-of select="@subtype"/>
                                        <span class="text-muted small"> <xsl:value-of select="tei:term"/></span>
                                    </a>
                                </xsl:for-each>
                            </div>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise><span class="text-muted" data-i18n="ent__unused">Kein Beleg im edierten Text</span></xsl:otherwise>
                </xsl:choose>
            </dd>
            <xsl:if test="tei:noteGrp/tei:note[@type = 'map']">
                <dt class="col-sm-3" data-i18n="reg__map_labels">Beschriftungen auf der Mappa Mundi</dt>
                <dd class="col-sm-9">
                    <xsl:for-each select="tei:noteGrp/tei:note[@type = 'map']">
                        <a class="me-3" href="karte.html?hl={substring-after(@target, '#')}"><i class="bi bi-geo-alt"></i> <xsl:value-of select="."/></a>
                    </xsl:for-each>
                </dd>
            </xsl:if>
        </dl>
    </xsl:template>
</xsl:stylesheet>
