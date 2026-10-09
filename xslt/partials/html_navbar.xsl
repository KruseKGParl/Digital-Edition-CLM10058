<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="nav_bar">
        <a class="visually-hidden-focusable" href="#main" data-i18n="navbar__skip">Zum Hauptinhalt springen</a>
        <header>
            <nav aria-label="Primary" class="navbar navbar-expand-lg site-header" data-bs-theme="dark">
                <div class="container-fluid px-4">
                    <a class="navbar-brand" href="index.html">
                        <span>Isidor von Sevilla · Clm 10058</span>
                        <small>Etymologiae XIV · Mappa Mundi</small>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-i18n="navbar__text">Text</a>
                                <ul class="dropdown-menu" data-bs-theme="light">
                                    <li>
                                        <a class="dropdown-item" href="fol154r.html">fol. 154r – 165v</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="toc.html" data-i18n="navbar__toc">Blattübersicht</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="karte.html" data-i18n="navbar__map">Karte</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-i18n="navbar__register">Register</a>
                                <ul class="dropdown-menu" data-bs-theme="light">
                                    <li>
                                        <a class="dropdown-item" href="listperson.html" data-i18n="navbar__persons">Personen</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listplace.html" data-i18n="navbar__places">Orte</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-i18n="navbar__project">Projekt</a>
                                <ul class="dropdown-menu" data-bs-theme="light">
                                    <li>
                                        <a class="dropdown-item" href="about.html" data-i18n="navbar__about">Über die Edition</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="imprint.html" data-i18n="navbar__imprint">Impressum</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                        <select name="language" id="languageSwitcher" class="form-select form-select-sm w-auto" aria-label="Sprache / Language"/>
                    </div>
                </div>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>
