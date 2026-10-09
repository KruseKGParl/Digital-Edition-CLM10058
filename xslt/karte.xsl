<?xml version="1.0" encoding="UTF-8"?>
<!-- Kartenedition: Mappa Mundi (fol. 154v) mit klickbaren Zonen; verknüpft mit Text und Registern. -->
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
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:variable name="doc_title" select="string(.//tei:titleStmt/tei:title[1])"/>
    <xsl:variable name="info_url" select="replace(string(.//tei:facsimile//tei:graphic[1]/@url), '/full/full/0/default\.jpg$', '/info.json')"/>
    <xsl:variable name="graphic" select=".//tei:facsimile//tei:graphic[1]"/>

    <xsl:template match="/">
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($doc_title, ' – ', $project_short_title)"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="'karte.html'"/>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"/>
                </xsl:call-template>
                <link rel="stylesheet" href="css/edition.css" type="text/css"/>
                <link rel="stylesheet" href="css/karte.css" type="text/css"/>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <nav aria-label="breadcrumb" class="container-fluid px-4 page-breadcrumb">
                        <ol class="breadcrumb mb-2">
                            <li class="breadcrumb-item">
                                <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page" data-i18n="navbar__map">Karte</li>
                        </ol>
                    </nav>
                    <div class="container-fluid px-4">
                        <div class="edition-toolbar d-flex flex-wrap align-items-center gap-2">
                            <h1 class="mb-0" data-i18n="map__title">Kartenedition – Mappa Mundi (fol. 154v)</h1>
                            <a class="btn btn-outline-secondary btn-sm ms-auto" href="fol154v.html">
                                <i class="bi bi-book"></i> <span>fol. 154v</span>
                            </a>
                            <a class="btn btn-outline-secondary btn-sm" href="karte.xml" data-i18n="[title]common__download_xml">
                                <i class="bi bi-filetype-xml"></i><span class="visually-hidden">TEI/XML</span>
                            </a>
                        </div>
                        <p class="edition-hint"><i class="bi bi-info-circle"></i> <span data-i18n="map__hint">Klicken Sie auf eine Zone.</span></p>
                        <div class="row map-row">
                            <div class="col-lg-8">
                                <div id="mapViewer" data-info="{$info_url}"
                                    data-width="{$graphic/@lrx}" data-height="{$graphic/@lry}"></div>
                                <p class="facs-credit" data-i18n="map__credit">Digitalisat: Bayerische Staatsbibliothek München</p>
                            </div>
                            <div class="col-lg-4">
                              <div class="map-side">
                               <div class="map-side-head">
                                <div class="input-group input-group-sm mb-2">
                                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    <input type="search" id="labelSearch" class="form-control" data-i18n="[placeholder]map__search" placeholder="Beschriftung suchen …"/>
                                </div>
                                <div class="d-flex flex-wrap gap-3 small mb-2">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" role="switch" id="zonesToggle" checked="checked"/>
                                        <label class="form-check-label" for="zonesToggle" data-i18n="map__zones">Zonen anzeigen</label>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" role="switch" id="linkedToggle"/>
                                        <label class="form-check-label" for="linkedToggle" data-i18n="map__only_linked">Nur mit Text verknüpfte</label>
                                    </div>
                                </div>
                                <div id="labelDetail" class="label-detail card card-body mb-2" hidden="hidden" aria-live="polite"></div>
                               </div>
                                <div id="labelList" class="label-list">
                                    <xsl:apply-templates select=".//tei:body/tei:div"/>
                                </div>
                              </div>
                            </div>
                        </div>
                        <div>
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="'karte.html'"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="vendor/openseadragon-bin-4.1.1/openseadragon.min.js"></script>
                <script src="js/karte.js"></script>
            </body>
        </html>
    </xsl:template>

    <!-- Abschnitte der Karte: flache Abschnitte und Kontinentgruppen -->
    <xsl:template match="tei:div[@type = 'group']">
        <div class="map-group">
            <h2 class="map-group-title">
                <span class="lang-de"><xsl:value-of select="tei:head[@xml:lang = 'de']"/></span>
                <span class="lang-en"><xsl:value-of select="tei:head[@xml:lang = 'en']"/></span>
            </h2>
            <xsl:apply-templates select="tei:div"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'section']">
        <details class="map-section" open="open">
            <summary>
                <span class="lang-de"><xsl:value-of select="tei:head[@xml:lang = 'de']"/></span>
                <span class="lang-en"><xsl:value-of select="tei:head[@xml:lang = 'en']"/></span>
                <span class="badge text-bg-light ms-1"><xsl:value-of select="count(tei:p)"/></span>
            </summary>
            <ul class="list-unstyled mb-2">
                <xsl:apply-templates select="tei:p"/>
            </ul>
        </details>
    </xsl:template>

    <!-- Einzelne Beschriftung -->
    <xsl:template match="tei:p">
        <xsl:variable name="ent" select="(tei:persName | tei:placeName)[1]"/>
        <xsl:variable name="kind" select="if ($ent/self::tei:persName) then 'person' else if ($ent/self::tei:placeName) then 'place' else 'other'"/>
        <xsl:variable name="corresp" select="tokenize(normalize-space($ent/@corresp), ' ')"/>
        <xsl:variable name="c" select="tokenize(@facs, ',')"/>
        <li class="label-item {if (exists($ent/@corresp)) then 'linked' else ''}" id="{@xml:id}"
            data-x="{$c[1]}" data-y="{$c[2]}" data-w="{$c[3]}" data-h="{$c[4]}" data-kind="{$kind}"
            data-linked="{if (exists($ent/@corresp)) then '1' else '0'}"
            data-text="{lower-case(normalize-space(.))}">
            <button type="button" class="label-btn">
                <span class="kind-dot {$kind}"></span>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="exists($ent/@corresp)"><i class="bi bi-link-45deg ms-1 text-primary"></i></xsl:if>
            </button>
            <!-- Detailansicht (wird von karte.js in die Detailkarte kopiert) -->
            <template class="detail">
                <h3 class="h6 mb-1"><xsl:value-of select="normalize-space(.)"/></h3>
                <dl class="ent-dl mb-2">
                    <dt data-i18n="map__section">Abschnitt</dt>
                    <dd>
                        <span class="lang-de"><xsl:value-of select="parent::tei:div/tei:head[@xml:lang = 'de']"/></span>
                        <span class="lang-en"><xsl:value-of select="parent::tei:div/tei:head[@xml:lang = 'en']"/></span>
                    </dd>
                    <dt data-i18n="map__kind">Art</dt>
                    <dd>
                        <span data-i18n="map__kind_{$kind}"><xsl:value-of select="$kind"/></span>
                        <xsl:for-each select="tokenize($ent/@type, '/')[. = ('ety', 'des')]">
                            <span class="badge text-bg-secondary ms-1" data-i18n="maptype__{.}"><xsl:value-of select="."/></span>
                        </xsl:for-each>
                    </dd>
                    <xsl:if test="$ent/@ref">
                        <dt data-i18n="ent__authority">Normdaten</dt>
                        <dd>
                            <a href="{$ent/@ref}" target="_blank" rel="noopener">
                                <xsl:value-of select="tei:auth_label(if (contains($ent/@ref, 'wikidata')) then 'wikidata' else if (contains($ent/@ref, 'viaf')) then 'viaf' else if (contains($ent/@ref, 'd-nb')) then 'gnd' else if (contains($ent/@ref, 'getty')) then 'tgn' else '')"/>
                                <i class="bi bi-box-arrow-up-right small ms-1"></i>
                            </a>
                        </dd>
                    </xsl:if>
                </dl>
                <xsl:choose>
                    <xsl:when test="exists($corresp)">
                        <h4 class="h6" data-i18n="map__in_text">Im Text (Buch XIV)</h4>
                        <xsl:for-each select="$corresp">
                            <xsl:variable name="e" select="tei:register_entry(substring-after(., '#'))"/>
                            <div class="mb-2">
                                <a class="fw-semibold" href="{substring-after(., '#')}.html">
                                    <xsl:value-of select="($e/tei:persName | $e/tei:placeName)[1]"/>
                                </a>
                                <span class="text-muted small"> (<xsl:value-of select="count($e/tei:noteGrp/tei:note[@type = 'mentions'])"/>)</span>
                                <div class="mentions small">
                                    <xsl:for-each select="$e/tei:noteGrp/tei:note[@type = 'mentions']">
                                        <a href="{replace(@target, '\.xml#', '.html#')}" class="me-2 text-nowrap"><xsl:value-of select="tei:mention_label(.)"/></a>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <p class="small text-muted mb-0" data-i18n="map__not_linked">Keine Verknüpfung mit dem Text.</p>
                    </xsl:otherwise>
                </xsl:choose>
            </template>
        </li>
    </xsl:template>

    <xsl:function name="tei:mention_label" as="xs:string">
        <xsl:param name="n" as="element()"/>
        <xsl:sequence select="normalize-space(string-join($n/text(), ''))"/>
    </xsl:function>
</xsl:stylesheet>
