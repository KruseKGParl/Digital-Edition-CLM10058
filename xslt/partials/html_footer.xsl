<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template name="html_footer">
        <footer class="py-3 bg-body-tertiary">
            <div class="text-center">
                <a href="{$github_url}">
                    <i aria-hidden="true" class="bi bi-github fs-2"></i>
                    <span class="visually-hidden">GitHub repo</span>
                </a>
                <p class="small text-muted mb-0 mt-1">
                    <span class="lang-de">Edition: CC BY-NC-SA 4.0 · Digitalisate: Bayerische Staatsbibliothek München</span>
                    <span class="lang-en">Edition: CC BY-NC-SA 4.0 · Digital copies: Bavarian State Library Munich</span>
                </p>
            </div>
        </footer>
        <script src="vendor/jquery/jquery-3.7.1.min.js"></script>
        <script src="vendor/bootstrap-5.3.5-dist/js/bootstrap.bundle.min.js"></script>
        
        <script src="js/i18n.js"></script>
        
    </xsl:template>
</xsl:stylesheet>