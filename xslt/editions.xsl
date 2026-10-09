<?xml version="1.0" encoding="UTF-8"?>
<!-- Textedition: eine HTML-Seite pro Blatt (data/editions/fol*.xml), Text neben dem IIIF-Faksimile.
     Personen- und Ortsnamen werden zu klickbaren Elementen; die Karteninfos stammen aus den Registern. -->
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
    <xsl:import href="./partials/register_lookup.xsl"/>
    <!-- indent="no": Leerzeichen im Handschriftentext dürfen nicht verändert werden -->
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no" omit-xml-declaration="yes"/>

    <xsl:variable name="prev" select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '\.xml$', '.html')"/>
    <xsl:variable name="next" select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '\.xml$', '.html')"/>
    <xsl:variable name="teiSource" select="data(tei:TEI/@xml:id)"/>
    <xsl:variable name="link" select="replace($teiSource, '\.xml$', '.html')"/>
    <xsl:variable name="doc_title" select="string(.//tei:titleStmt/tei:title[1])"/>
    <xsl:variable name="info_url" select="replace(string(.//tei:facsimile//tei:graphic[1]/@url), '/full/full/0/default\.jpg$', '/info.json')"/>

    <xsl:template match="/">
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($doc_title, ' – ', $project_short_title)"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"/>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"/>
                </xsl:call-template>
                <link rel="stylesheet" href="css/edition.css" type="text/css"/>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <nav aria-label="breadcrumb" class="container-fluid px-4 page-breadcrumb">
                        <ol class="breadcrumb mb-2">
                            <li class="breadcrumb-item">
                                <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="toc.html" data-i18n="navbar__toc">Blattübersicht</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>
                    <div class="container-fluid px-4">
                        <!-- Kopfzeile: Blattnavigation und Werkzeuge -->
                        <div class="edition-toolbar d-flex flex-wrap align-items-center gap-2 mb-3">
                            <a class="btn btn-outline-secondary btn-sm {if (ends-with($prev, '.html')) then '' else 'disabled'}"
                                href="{if (ends-with($prev, '.html')) then $prev else '#'}" data-i18n="[title]text__prev;[aria-label]text__prev">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                            <h1 class="mb-0"><xsl:value-of select="$doc_title"/></h1>
                            <a class="btn btn-outline-secondary btn-sm {if (ends-with($next, '.html')) then '' else 'disabled'}"
                                href="{if (ends-with($next, '.html')) then $next else '#'}" data-i18n="[title]text__next;[aria-label]text__next">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                            <select id="folioSelect" class="form-select form-select-sm w-auto ms-2" data-i18n="[aria-label]text__jump">
                                <xsl:for-each select="collection('../data/editions?select=fol*.xml')/tei:TEI">
                                    <xsl:sort select="@xml:id"/>
                                    <xsl:variable name="f" select="replace(@xml:id, '\.xml$', '.html')"/>
                                    <option value="{$f}">
                                        <xsl:if test="$f = $link"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                                        <xsl:value-of select="tei:teiHeader//tei:title[1]"/>
                                    </option>
                                </xsl:for-each>
                            </select>
                            <div class="btn-group btn-group-sm ms-auto" role="group">
                                <button type="button" class="btn btn-outline-secondary active" id="toggleFacs" aria-pressed="true">
                                    <i class="bi bi-image"></i> <span data-i18n="text__facs_toggle">Faksimile</span>
                                </button>
                                <button type="button" class="btn btn-outline-secondary active" id="toggleLines" aria-pressed="true">
                                    <i class="bi bi-text-left"></i> <span data-i18n="text__lines">Zeilen wie in der Handschrift</span>
                                </button>
                                <xsl:if test="$link = 'fol154v.html'">
                                    <a class="btn btn-outline-primary" href="karte.html">
                                        <i class="bi bi-globe-europe-africa"></i> <span data-i18n="navbar__map">Karte</span>
                                    </a>
                                </xsl:if>
                                <a class="btn btn-outline-secondary" href="{$teiSource}" data-i18n="[title]common__download_xml">
                                    <i class="bi bi-filetype-xml"></i><span class="visually-hidden">TEI/XML</span>
                                </a>
                            </div>
                        </div>
                        <p class="edition-hint">
                            <i class="bi bi-info-circle"></i> <span data-i18n="text__hint">Klicken Sie auf einen Personen- oder Ortsnamen.</span>
                            <span class="ms-3 entity-legend"><span class="ent person" data-i18n="ent__person">Person</span> <span class="ent place" data-i18n="ent__place">Ort</span></span>
                        </p>
                        <div class="row edition-row" id="editionRow">
                            <div class="col-lg-6 text-col" id="textCol">
                                <div id="textPane" class="text-pane lines" lang="la">
                                    <xsl:apply-templates select=".//tei:body"/>
                                </div>
                            </div>
                            <div class="col-lg-6 facs-col" id="facsCol">
                                <div id="osd" data-info="{$info_url}"></div>
                                <p class="facs-credit" data-i18n="text__facs_credit">Digitalisat: Bayerische Staatsbibliothek München</p>
                            </div>
                        </div>
                        <div>
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="$link"/>
                            </xsl:call-template>
                        </div>
                    </div>
                    <!-- Informationskarten der auf diesem Blatt vorkommenden Personen und Orte -->
                    <div id="entityCards" hidden="hidden">
                        <xsl:for-each-group select=".//tei:body//*[self::tei:persName or self::tei:placeName][@ref]" group-by="substring-after(@ref, '#')">
                            <xsl:call-template name="entity_card">
                                <xsl:with-param name="id" select="current-grouping-key()"/>
                            </xsl:call-template>
                        </xsl:for-each-group>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="vendor/openseadragon-bin-4.1.1/openseadragon.min.js"></script>
                <script src="js/edition.js"></script>
            </body>
        </html>
    </xsl:template>

    <!-- ===== TEI -> HTML ===== -->
    <xsl:template match="tei:body | tei:div">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:pb"/>
    <xsl:template match="tei:cb">
        <h2 class="col-label"><span data-i18n="text__col">Sp.</span><xsl:text> </xsl:text><xsl:value-of select="@n"/></h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p class="tei-p"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:lb">
        <xsl:if test="@break = 'no'"><span class="hy" aria-hidden="true">-</span></xsl:if>
        <span class="lb">
            <xsl:attribute name="data-break" select="if (@break = 'no') then 'no' else 'yes'"/>
            <xsl:if test="number(@n) = 1 or number(@n) mod 5 = 0">
                <xsl:attribute name="data-n" select="@n"/>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:persName[@ref] | tei:placeName[@ref]">
        <xsl:variable name="id" select="substring-after(@ref, '#')"/>
        <xsl:variable name="kind" select="if (self::tei:persName) then 'person' else 'place'"/>
        <span class="entity {$kind}" id="{@xml:id}" data-ref="{$id}" data-kind="{$kind}" tabindex="0" role="button">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:note">
        <span class="editorial-note"> [<xsl:apply-templates/>] </span>
    </xsl:template>

    <!-- ===== Informationskarte zu einem Registereintrag ===== -->
    <xsl:template name="entity_card">
        <xsl:param name="id"/>
        <xsl:variable name="e" select="tei:register_entry($id)"/>
        <template id="ent-{$id}">
            <div class="ent-card">
                <div class="small text-muted">
                    <span data-i18n="{if ($e/self::tei:person) then 'ent__person' else 'ent__place'}"></span>
                    <xsl:if test="$e/@type">
                        <xsl:text> · </xsl:text><span data-i18n="type__{$e/@type}"><xsl:value-of select="$e/@type"/></span>
                    </xsl:if>
                </div>
                <h3 class="h6 mb-2"><xsl:value-of select="($e/tei:persName | $e/tei:placeName)[1]"/></h3>
                <dl class="ent-dl">
                    <xsl:if test="($e/tei:persName | $e/tei:placeName)[@type = 'variant']">
                        <dt data-i18n="ent__variants">Belegformen</dt>
                        <dd><xsl:value-of select="string-join(($e/tei:persName | $e/tei:placeName)[@type = 'variant'], ', ')"/></dd>
                    </xsl:if>
                    <dt data-i18n="ent__authority">Normdaten</dt>
                    <dd>
                        <xsl:choose>
                            <xsl:when test="$e/tei:idno">
                                <xsl:for-each select="$e/tei:idno">
                                    <a href="{.}" target="_blank" rel="noopener"><xsl:value-of select="tei:auth_label(@subtype)"/> <i class="bi bi-box-arrow-up-right small"></i></a>
                                    <xsl:if test="position() != last()"><xsl:text> · </xsl:text></xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise><span class="text-muted" data-i18n="ent__no_authority">keine Normdaten</span></xsl:otherwise>
                        </xsl:choose>
                    </dd>
                    <xsl:if test="$e/tei:noteGrp/tei:note[@type = 'map']">
                        <dt data-i18n="ent__on_map">Auf der Karte</dt>
                        <dd>
                            <xsl:for-each select="$e/tei:noteGrp/tei:note[@type = 'map']">
                                <a href="karte.html?hl={substring-after(@target, '#')}"><i class="bi bi-geo-alt"></i> <xsl:value-of select="."/></a>
                                <xsl:if test="position() != last()"><br/></xsl:if>
                            </xsl:for-each>
                        </dd>
                    </xsl:if>
                </dl>
                <a class="btn btn-sm btn-outline-primary" href="{$id}.html">
                    <span data-i18n="ent__page">Registereintrag</span>
                    <xsl:text> (</xsl:text><xsl:value-of select="count($e/tei:noteGrp/tei:note[@type = 'mentions'])"/><xsl:text>)</xsl:text>
                </a>
            </div>
        </template>
    </xsl:template>
</xsl:stylesheet>
