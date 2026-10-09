<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template name="html_footer">
        <footer class="site-footer">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-5">
                        <p class="footer-title">Isidor von Sevilla, Etymologiae XIV und Mappa Mundi</p>
                        <p class="mb-0">
                            <span class="lang-de">Digitale Teiledition der Handschrift München, Bayerische Staatsbibliothek, Clm 10058. Bearbeitet von Maximilian Kruse, Universität Paderborn.</span>
                            <span class="lang-en">Digital partial edition of the manuscript Munich, Bavarian State Library, Clm 10058. Edited by Maximilian Kruse, Paderborn University.</span>
                        </p>
                    </div>
                    <div class="col-6 col-md-3">
                        <h2 data-i18n="footer__links">Edition</h2>
                        <ul>
                            <li><a href="about.html" data-i18n="navbar__about">Über die Edition</a></li>
                            <li><a href="imprint.html" data-i18n="navbar__imprint">Impressum</a></li>
                            <li><a href="{$github_url}"><i class="bi bi-github" aria-hidden="true"></i> GitHub</a></li>
                        </ul>
                    </div>
                    <div class="col-6 col-md-4">
                        <h2 data-i18n="common__licence">Lizenz</h2>
                        <ul>
                            <li>
                                <span class="lang-de">Edition: </span><span class="lang-en">Edition: </span>
                                <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA 4.0</a>
                            </li>
                            <li>
                                <span class="lang-de">Digitalisate: Bayerische Staatsbibliothek München (IIIF)</span>
                                <span class="lang-en">Digital copies: Bavarian State Library Munich (IIIF)</span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="footer-bottom">
                    <span class="lang-de">Erstellt mit dem DSE Static Site Cookiecutter (ÖAW/ACDH-CH)</span>
                    <span class="lang-en">Built with the DSE Static Site Cookiecutter (ÖAW/ACDH-CH)</span>
                </div>
            </div>
        </footer>
        <script src="vendor/jquery/jquery-3.7.1.min.js"></script>
        <script src="vendor/bootstrap-5.3.5-dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/i18n.js"></script>
    </xsl:template>
</xsl:stylesheet>
