<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$project_short_title"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags"/>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <div class="container py-4">
                        <h1 class="display-6"><xsl:value-of select="$project_short_title"/></h1>
                        <h2 class="h4 text-muted mb-4"><xsl:value-of select="$project_title"/></h2>
                        <p class="lead lang-de">
                            Digitale Teiledition des 14. Buchs („De terra“) der <em>Etymologiae</em> Isidors von Sevilla nach der
                            Handschrift München, Bayerische Staatsbibliothek, Clm 10058 (fol. 154r–165v), samt Edition der
                            eingebundenen Weltkarte (<em>Mappa Mundi</em>). Text und Karte sind über Personen und Orte miteinander verknüpft.
                        </p>
                        <p class="lead lang-en">
                            Digital partial edition of Book XIV (“De terra”) of Isidore of Seville’s <em>Etymologiae</em> after the manuscript
                            Munich, Bavarian State Library, Clm 10058 (fols. 154r–165v), including an edition of the
                            world map (<em>Mappa Mundi</em>) it contains. Text and map are linked through persons and places.
                        </p>
                        <div class="row g-4 mt-2">
                            <div class="col-md-4">
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <h3 class="h5 card-title"><i class="bi bi-book"></i> <span data-i18n="index__text_title">Textedition</span></h3>
                                        <p class="card-text" data-i18n="index__text_desc"></p>
                                        <a class="btn btn-primary mt-auto" href="fol154r.html" data-i18n="index__text_btn">Zum Text</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <h3 class="h5 card-title"><i class="bi bi-globe-europe-africa"></i> <span data-i18n="index__map_title">Kartenedition</span></h3>
                                        <p class="card-text" data-i18n="index__map_desc"></p>
                                        <a class="btn btn-primary mt-auto" href="karte.html" data-i18n="index__map_btn">Zur Karte</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <h3 class="h5 card-title"><i class="bi bi-list-ul"></i> <span data-i18n="index__reg_title">Register</span></h3>
                                        <p class="card-text" data-i18n="index__reg_desc"></p>
                                        <div class="mt-auto d-flex gap-2">
                                            <a class="btn btn-outline-primary" href="listplace.html" data-i18n="navbar__places">Orte</a>
                                            <a class="btn btn-outline-primary" href="listperson.html" data-i18n="navbar__persons">Personen</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="text-center p-4 mt-4">
                            <xsl:call-template name="blockquote"/>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
