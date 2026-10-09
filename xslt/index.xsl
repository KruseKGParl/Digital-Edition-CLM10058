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

    <!-- Kennzahlen direkt aus den Daten -->
    <xsl:variable name="n_folios" select="count(collection('../data/editions?select=fol*.xml'))"/>
    <xsl:variable name="n_labels" select="count(document('../data/editions/karte.xml')//tei:body//tei:p)"/>
    <xsl:variable name="n_places" select="count(document('../data/indices/listplace.xml')//tei:place)"/>
    <xsl:variable name="n_persons" select="count(document('../data/indices/listperson.xml')//tei:person)"/>
    <!-- Ausschnitt des Kartenkreises (fol. 154v) direkt über IIIF der BSB -->
    <xsl:variable name="hero_img" select="concat($iiif_base, 'bsb00112097_00312/50,40,1730,1710/600,/0/default.jpg')"/>

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
                    <section class="hero">
                        <div class="container">
                            <div class="row align-items-center g-5">
                                <div class="col-lg-7">
                                    <span class="eyebrow" data-i18n="index__eyebrow">Digitale Edition</span>
                                    <h1>Isidor von Sevilla, <em>Etymologiae</em> XIV</h1>
                                    <p class="subtitle">
                                        <span class="lang-de">„De terra“ und die Mappa Mundi der Handschrift Clm 10058</span>
                                        <span class="lang-en">“De terra” and the Mappa Mundi of manuscript Clm 10058</span>
                                    </p>
                                    <p class="lead lang-de">
                                        Digitale Teiledition des 14. Buchs der <em>Etymologiae</em> nach der Handschrift München,
                                        Bayerische Staatsbibliothek, Clm 10058 (fol. 154r–165v), mit einer Edition der eingebundenen
                                        Weltkarte. Text und Karte sind über Personen und Orte miteinander verknüpft.
                                    </p>
                                    <p class="lead lang-en">
                                        Digital partial edition of Book XIV of the <em>Etymologiae</em> after the manuscript Munich,
                                        Bavarian State Library, Clm 10058 (fols. 154r–165v), including an edition of the world map
                                        it contains. Text and map are linked through persons and places.
                                    </p>
                                    <div class="d-flex flex-wrap gap-2 mt-4">
                                        <a class="btn btn-primary btn-lg px-4" href="fol154r.html" data-i18n="index__text_btn">Zum Text</a>
                                        <a class="btn btn-outline-primary btn-lg px-4" href="karte.html" data-i18n="index__map_btn">Zur Karte</a>
                                    </div>
                                </div>
                                <div class="col-lg-5 text-center">
                                    <figure>
                                        <a href="karte.html">
                                            <img class="hero-image" src="{$hero_img}" width="440" height="440"
                                                alt="Mappa Mundi, Clm 10058, fol. 154v" data-i18n="[alt]index__hero_alt"/>
                                        </a>
                                        <figcaption data-i18n="index__hero_caption">Mappa Mundi, fol. 154v · München, BSB, Clm 10058</figcaption>
                                    </figure>
                                </div>
                            </div>
                        </div>
                    </section>

                    <div class="container">
                        <div class="row g-4 entry-cards">
                            <div class="col-md-4">
                                <div class="card entry-card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <span class="icon"><i class="bi bi-book" aria-hidden="true"></i></span>
                                        <h2 class="h5 card-title" data-i18n="index__text_title">Textedition</h2>
                                        <p class="card-text" data-i18n="index__text_desc"></p>
                                        <a class="btn btn-outline-primary mt-auto align-self-start" href="fol154r.html" data-i18n="index__text_btn">Zum Text</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card entry-card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <span class="icon"><i class="bi bi-globe-europe-africa" aria-hidden="true"></i></span>
                                        <h2 class="h5 card-title" data-i18n="index__map_title">Kartenedition</h2>
                                        <p class="card-text" data-i18n="index__map_desc"></p>
                                        <a class="btn btn-outline-primary mt-auto align-self-start" href="karte.html" data-i18n="index__map_btn">Zur Karte</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card entry-card h-100">
                                    <div class="card-body d-flex flex-column">
                                        <span class="icon"><i class="bi bi-list-ul" aria-hidden="true"></i></span>
                                        <h2 class="h5 card-title" data-i18n="index__reg_title">Register</h2>
                                        <p class="card-text" data-i18n="index__reg_desc"></p>
                                        <div class="mt-auto d-flex gap-2">
                                            <a class="btn btn-outline-primary" href="listplace.html" data-i18n="navbar__places">Orte</a>
                                            <a class="btn btn-outline-primary" href="listperson.html" data-i18n="navbar__persons">Personen</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-0 facts" aria-label="Die Edition in Zahlen">
                            <div class="col-6 col-md-3 fact">
                                <span class="num"><xsl:value-of select="$n_folios"/></span>
                                <span class="lbl" data-i18n="facts__folios">Blätter</span>
                            </div>
                            <div class="col-6 col-md-3 fact">
                                <span class="num"><xsl:value-of select="$n_labels"/></span>
                                <span class="lbl" data-i18n="facts__labels">Kartenbeschriftungen</span>
                            </div>
                            <div class="col-6 col-md-3 fact">
                                <span class="num"><xsl:value-of select="$n_places"/></span>
                                <span class="lbl" data-i18n="facts__places">Orte</span>
                            </div>
                            <div class="col-6 col-md-3 fact">
                                <span class="num"><xsl:value-of select="$n_persons"/></span>
                                <span class="lbl" data-i18n="facts__persons">Personen</span>
                            </div>
                        </div>

                        <xsl:call-template name="blockquote"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
