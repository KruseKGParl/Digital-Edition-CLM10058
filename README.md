# Isidor von Sevilla, *Etymologiae* XIV („De terra“) und Mappa Mundi – Handschrift Clm 10058

**Digitale Teiledition · Digital partial edition**

🇩🇪 [Deutsch](#deutsch) · 🇬🇧 [English](#english)

> **Website:** <https://krusekgparl.github.io/Digital-Edition-CLM10058/> *(sobald GitHub Pages aktiviert ist / once GitHub Pages is enabled)*
> **Lizenz Edition / Licence (edition):** [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

---

## Deutsch

### Projektbeschreibung

Dieses Repositorium enthält die digitale Teiledition des 14. Buches „De terra“ aus den *Etymologiae* des Isidor von Sevilla, überliefert in der Handschrift **Clm 10058** der Bayerischen Staatsbibliothek (BSB).

Die Edition entstand im Rahmen meiner Masterarbeit im Bereich der Digital Humanities und Geschichte an der Universität Paderborn. Ziel des Projektes war es, sowohl den Handschriftentext (fol. 154r–165v) als auch die im Text eingebundene **Mappa Mundi** (mittelalterliche Weltkarte, fol. 154v) zu edieren, digital zu erschließen und online verfügbar zu machen.

### Editionsgrundlagen

| Teil | Grundlage |
|---|---|
| **Textedition** | Die Transkription des Handschriftentextes basiert auf der Edition von W. M. Lindsay (1911). |
| **Kartenedition** | Die Transkription der Mappa Mundi folgt der Edition von Patrick Gautier Dalché (1988). |

### Funktionen der Website

- **Textedition:** Jedes Blatt zeilengetreu neben dem Faksimile (IIIF der BSB), mit Spalten- und Zeilenzählung. Wahlweise als Fließtext.
- **Kartenedition:** Alle Beschriftungen der Mappa Mundi als klickbare Zonen im Bild, mit Suche und Filter.
- **Register:** Personen und Orte mit Normdaten (VIAF, GND, Wikidata, Getty TGN), Belegformen und allen Belegstellen.
- **Direkte Verknüpfung von Text und Karte** über übereinstimmende Normdaten: Von einem Namen im Text zur Beschriftung auf der Karte und zurück.
- Zweisprachige Oberfläche (Deutsch / Englisch).

### Daten und Struktur

Das Projekt umfasst TEI-konforme XML-Dokumente. Für die Entwicklung wurde der Oxygen XML Editor verwendet.

```
source/                  Quell-XML der Edition (Oxygen-Fassungen: Text- und Kartenedition)
pyscripts/
  prepare_data.py        bereitet source/ auf -> data/ (Blattdateien, Register, Verknüpfung Text/Karte)
data/
  editions/              fol154r.xml … fol165v.xml (eine TEI-Datei pro Blatt), karte.xml
  indices/               listperson.xml, listplace.xml (Register mit Belegstellen)
  meta/                  about.xml, imprint.xml (zweisprachige Seiten)
xslt/                    TEI -> HTML (XSLT)
html/                    Website (HTML wird beim Build erzeugt; css/, js/, vendor/, locales/)
build.xml                Ant-Build
translations.csv         Oberflächentexte Deutsch/Englisch
```

Die XML-Dateien enthalten die **IIIF-Verknüpfungen** zu den Digitalisaten der BSB; die Bilder werden direkt von dort geladen.

### Lokal bauen und ansehen

Voraussetzungen: Java, [Apache Ant](https://ant.apache.org/), Python 3 (mit `lxml`).

```bash
pip install lxml
python3 pyscripts/prepare_data.py   # nur nötig, wenn source/ geändert wurde
ant build                            # TEI/XML -> HTML nach html/
./serve.sh                           # Vorschau auf http://localhost:8000
```

Die Website wird mit dem [DSE Static Site Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter) der ÖAW/ACDH-CH erzeugt (XSLT, Saxon-HE, Bootstrap, OpenSeadragon).

### Herkunft: TEI Publisher

Die Edition wurde ursprünglich für den **TEI Publisher 7.1** entwickelt. Dazu gehörten speziell angepasste XML-Dokumente, ODD-Dateien (Schema- und Darstellungsmodell) und ein Template. Neuere Versionen der Software können Anpassungen erfordern; diese Fassung ist deshalb als statische Website neu umgesetzt. Die ursprünglichen Publisher-Dateien, ODDs, Template, Projektzeitplan und Transkriptionsdateien sind weiterhin im GitLab-Repositorium verfügbar:

→ <https://git.uni-paderborn.de/mkruse14/digital-edition-clm10058>

### Verfügbarkeit

Die Projektdaten sind zusätzlich auf GitLab (Universität Paderborn) verfügbar (siehe oben).

---

## English

### Project description

This repository contains the partial digital edition of Book XIV (“De terra”) of the *Etymologiae* by Isidore of Seville, preserved in manuscript **Clm 10058** at the Bayerische Staatsbibliothek (BSB).

The edition was created as part of a master’s thesis in Digital Humanities and History at Paderborn University. The project aimed to edit, digitally encode and publish both the manuscript text (fols. 154r–165v) and the **Mappa Mundi** (medieval world map, fol. 154v) embedded in the text.

### Editorial basis

| Part | Basis |
|---|---|
| **Text edition** | The transcription of the manuscript text is based on the edition by W. M. Lindsay (1911). |
| **Map edition** | The transcription of the Mappa Mundi follows the edition by Patrick Gautier Dalché (1988). |

### Features of the website

- **Text edition:** every folio line by line next to the facsimile (BSB IIIF), with column and line numbering; optionally as continuous text.
- **Map edition:** all inscriptions of the Mappa Mundi as clickable zones in the image, with search and filter.
- **Indices:** persons and places with authority data (VIAF, GND, Wikidata, Getty TGN), attested forms and all attestations.
- **Direct links between text and map** through matching authority data: from a name in the text to the inscription on the map and back.
- Bilingual interface (German / English).

### Data and structure

The project consists of TEI-conformant XML documents. Development was carried out using the Oxygen XML Editor.

```
source/                  source XML of the edition (Oxygen versions: text and map edition)
pyscripts/
  prepare_data.py        processes source/ -> data/ (folio files, indices, text/map links)
data/
  editions/              fol154r.xml … fol165v.xml (one TEI file per folio), karte.xml
  indices/               listperson.xml, listplace.xml (indices with attestations)
  meta/                  about.xml, imprint.xml (bilingual pages)
xslt/                    TEI -> HTML (XSLT)
html/                    website (HTML is generated by the build; css/, js/, vendor/, locales/)
build.xml                Ant build
translations.csv         interface texts German/English
```

The XML files contain complete **IIIF references** to the BSB’s digitized images; the images are loaded directly from there.

### Build and preview locally

Requirements: Java, [Apache Ant](https://ant.apache.org/), Python 3 (with `lxml`).

```bash
pip install lxml
python3 pyscripts/prepare_data.py   # only needed after changing source/
ant build                            # TEI/XML -> HTML into html/
./serve.sh                           # preview at http://localhost:8000
```

The website is generated with the [DSE Static Site Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter) by ÖAW/ACDH-CH (XSLT, Saxon-HE, Bootstrap, OpenSeadragon).

### Background: TEI Publisher

The edition was originally developed for **TEI Publisher 7.1**, with specially adapted XML documents, ODD files (schema and rendering models) and a template. Newer versions of the software may require adjustments; this version has therefore been re-implemented as a static website. The original Publisher files, ODDs, template, project timeline and transcription files remain available in the GitLab repository:

→ <https://git.uni-paderborn.de/mkruse14/digital-edition-clm10058>

### Availability

The project data are also available on GitLab (Paderborn University, see above).

---

## Lizenzen · Licences

- **Edition (Daten, Transkription, Kodierung) · edition (data, transcription, encoding):** [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
- **Code (XSLT, JS, Build) · code:** MIT, siehe/see [LICENSE](LICENSE) (Basis: DSE Static Site Cookiecutter, ÖAW/ACDH-CH)
- **Saxon-HE:** [Mozilla Public License 2.0](saxon/notices/LICENSE.txt)
- **Digitalisate · digital copies:** Bayerische Staatsbibliothek München – Nutzungsbedingungen der BSB beachten · please observe the BSB’s terms of use.
- **Bibliotheken in `html/vendor/` · libraries:** jeweils eigene Lizenzen, siehe die Dateien im jeweiligen Ordner · see the licence files in each folder.

## Zitation · Citation

<!-- TODO: Zitiervorschlag (und ggf. DOI, z. B. über Zenodo) eintragen -->

*Folgt / to follow.*

## Autor · Author

Maximilian Kruse ([ORCID 0000-0002-6615-6791](https://orcid.org/0000-0002-6615-6791)), Universität Paderborn
