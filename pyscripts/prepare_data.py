#!/usr/bin/env python3
"""
Bereitet die Quelldateien in ``source/`` für den Static-Site-Build auf und schreibt
das Ergebnis nach ``data/``:

  data/editions/fol154r.xml ... fol165v.xml   eine TEI-Datei pro Blatt (Text + Faksimile)
  data/editions/karte.xml                     Kartenedition (Mappa Mundi, Zonen als facs)
  data/indices/listperson.xml                 Personenregister (inkl. Belegstellen)
  data/indices/listplace.xml                  Ortsregister     (inkl. Belegstellen)

Zusätzlich werden Text und Karte über gleiche Normdaten-IDs (VIAF / GND / Wikidata / Getty TGN)
direkt miteinander verknüpft (``corresp`` in der Karte, ``note[@type='map']`` im Register).

Aufruf:  python3 pyscripts/prepare_data.py
"""
import copy
import re
import sys
import unicodedata
from collections import OrderedDict, defaultdict
from pathlib import Path

from lxml import etree

ROOT = Path(__file__).resolve().parent.parent
SRC_TEXT = ROOT / "source" / "Textedition_Oxygen.xml"
SRC_MAP = ROOT / "source" / "Kartenedition_Oxygen.xml"
OUT = ROOT / "data"

TEI = "http://www.tei-c.org/ns/1.0"
XML = "http://www.w3.org/XML/1998/namespace"
NS = {"t": TEI}
T = "{%s}" % TEI
XID = "{%s}id" % XML
XLANG = "{%s}lang" % XML

IIIF = "https://api.digitale-sammlungen.de/iiif/image/v2/"
BSB = "bsb00112097"
# Die BSB-Scans laufen von 00311 (fol. 154r) bis 00334 (fol. 165v).
# In der Oxygen-Quelle waren die IDs für 154r und 154v vertauscht (154r zeigte auf die
# Karte, 154v auf die Textseite). Hier wird die Reihenfolge aus der Foliierung berechnet.
FIRST_SCAN = 311

# Deutsche Übersetzung der (englischen) Abschnittsüberschriften der Kartenedition.
SECTION_DE = {
    "Winds": "Winde",
    "The Ocean and the isles of the Ocean": "Der Ozean und die Inseln des Ozeans",
    "The isles of the Red Sea": "Die Inseln des Roten Meeres",
    "The Mediterranean Sea and the Black Sea": "Das Mittelmeer und das Schwarze Meer",
    "The Isles of Mediterranean Sea": "Die Inseln des Mittelmeers",
    "Asia": "Asien",
    "The rivers of Asia": "Die Flüsse Asiens",
    "Mountains of Asia": "Die Berge Asiens",
    "The regiones, cities and peoples of Asia": "Die Regionen, Städte und Völker Asiens",
    "Europe": "Europa",
    "The rivers of Europe": "Die Flüsse Europas",
    "The regions and cities of Europe": "Die Regionen und Städte Europas",
    "Africa": "Afrika",
    "The rivers of Africa": "Die Flüsse Afrikas",
    "The mountains of Africa": "Die Berge Afrikas",
    "Animals of Africa": "Tiere Afrikas",
    "The regions and cities of Africa": "Die Regionen und Städte Afrikas",
}
SECTION_EN_FIX = {"The Isles of Mediterranean Seaye": "The Isles of Mediterranean Sea"}


def E(tag, attrib=None, text=None, **kw):
    el = etree.Element(T + tag, nsmap={None: TEI})
    for k, v in (attrib or {}).items():
        el.set(k, v)
    for k, v in kw.items():
        el.set(k, v)
    if text is not None:
        el.text = text
    return el


def SE(parent, tag, attrib=None, text=None, **kw):
    el = E(tag, attrib, text, **kw)
    parent.append(el)
    return el


def slug(xml_id):
    """xml:id -> dateinamentauglich (ASCII); ä -> a usw. (die Nummern am Ende sind eindeutig)."""
    s = unicodedata.normalize("NFKD", xml_id.strip().lstrip("#"))
    return re.sub(r"[^A-Za-z0-9_-]", "", s)


def norm_space(s):
    return re.sub(r"\s+", " ", s or "").strip()


def norm_ref(ref):
    """Normdaten-Referenz vereinheitlichen -> (schluessel, schema, url) oder None."""
    r = (ref or "").strip()
    if not r or r in {"/", "o"}:
        return None
    if re.fullmatch(r"Q\d+", r):
        return ("wd:" + r, "wikidata", "https://www.wikidata.org/wiki/" + r)
    m = re.search(r"viaf\.org/viaf/(\d+)", r)
    if m:
        return ("viaf:" + m.group(1), "viaf", "https://viaf.org/viaf/" + m.group(1))
    m = re.search(r"d-nb\.info/gnd/([\w\-]+)", r)
    if m:
        return ("gnd:" + m.group(1), "gnd", "https://d-nb.info/gnd/" + m.group(1))
    m = re.search(r"vocab\.getty\.edu/page/tgn/(\d+)", r)
    if m:
        return ("tgn:" + m.group(1), "tgn", "https://vocab.getty.edu/page/tgn/" + m.group(1))
    return ("url:" + r, "other", r)


def folio_ids(n_folios):
    out = []
    for i in range(n_folios):
        num = 154 + i // 2
        out.append("%d%s" % (num, "r" if i % 2 == 0 else "v"))
    return out


def scan_id(index):
    return "%s_%05d" % (BSB, FIRST_SCAN + index)


def build_header(title_main, title_sub, extra=None):
    h = E("teiHeader")
    fd = SE(h, "fileDesc")
    ts = SE(fd, "titleStmt")
    SE(ts, "title", {"type": "main"}, title_main)
    SE(ts, "title", {"type": "sub"}, title_sub)
    SE(ts, "editor", {"ref": "https://orcid.org/0000-0002-6615-6791"}, "Maximilian Kruse")
    ps = SE(fd, "publicationStmt")
    av = SE(ps, "availability")
    SE(av, "licence", {"target": "https://creativecommons.org/licenses/by-nc-sa/4.0/"}, "CC BY-NC-SA 4.0")
    sd = SE(fd, "sourceDesc")
    ms = SE(sd, "msIdentifier")
    SE(ms, "settlement", text="München")
    SE(ms, "institution", text="Bayerische Staatsbibliothek")
    SE(ms, "idno", text="Clm 10058")
    if extra is not None:
        sd.append(extra)
    return h


def write(tree_root, path):
    path.parent.mkdir(parents=True, exist_ok=True)
    etree.ElementTree(tree_root).write(str(path), encoding="UTF-8", xml_declaration=True, pretty_print=True)


def main():
    src = etree.parse(str(SRC_TEXT))
    body = src.find(".//t:body", NS)
    divs = body.findall("t:div", NS)
    fols = folio_ids(len(divs))
    print("Blätter:", len(divs), fols[0], "-", fols[-1])

    # ------------------------------------------------------------------ Register lesen
    reg = {}  # id -> dict
    for kind, tag in (("person", "person"), ("place", "place")):
        for el in src.iterfind(".//t:standOff//t:%s" % tag, NS):
            eid = slug(el.get(XID))
            if eid != el.get(XID):
                print("ID vereinfacht:", el.get(XID), "->", eid)
            assert eid not in reg, eid
            nm_tag = "persName" if kind == "person" else "placeName"
            names = el.findall("t:" + nm_tag, NS)
            norm_el = next((n for n in names if n.get("type") == "norm"), names[0] if names else None)
            variants = []
            for n in names:
                if n is norm_el:
                    continue
                v = norm_space("".join(n.itertext()))
                if v and v not in variants:
                    variants.append(v)
            reg[eid] = OrderedDict(
                id=eid, kind=kind, type=el.get("type"),
                name=norm_space("".join(norm_el.itertext())) if norm_el is not None else eid,
                ref=norm_ref(norm_el.get("ref") if norm_el is not None else None),
                variants=variants, mentions=[], maps=[])
    print("Register:", sum(1 for r in reg.values() if r["kind"] == "person"), "Personen,",
          sum(1 for r in reg.values() if r["kind"] == "place"), "Orte")

    # ------------------------------------------------------------------ Foliodateien
    for idx, (div, fol) in enumerate(zip(divs, fols)):
        prev_f = fols[idx - 1] if idx > 0 else None
        next_f = fols[idx + 1] if idx < len(fols) - 1 else None
        tei = E("TEI")
        tei.set(XID, "fol%s.xml" % fol)
        if prev_f:
            tei.set("prev", "fol%s.xml" % prev_f)
        if next_f:
            tei.set("next", "fol%s.xml" % next_f)
        tei.append(build_header("fol. %s" % fol, "Isidor von Sevilla, Etymologiae XIV, Clm 10058"))
        fac = SE(tei, "facsimile")
        sf = SE(fac, "surface", {XID: "fol%s" % fol})
        SE(sf, "graphic", {"url": "%s%s/full/full/0/default.jpg" % (IIIF, scan_id(idx)),
                            "n": scan_id(idx)})
        text = SE(tei, "text")
        b = SE(text, "body")
        nd = copy.deepcopy(div)
        # Strukturbereinigung
        for fw in nd.findall(".//t:fw", NS):
            fw.getparent().remove(fw)
        pb = nd.find(".//t:pb", NS)
        pb.set("n", "fol. %s" % fol)
        pb.set("facs", "#fol%s" % fol)
        # Spalten / Zeilen nummerieren, Erwähnungen mit ID versehen
        col, line, k = 0, 0, 0
        for el in nd.iter():
            if not isinstance(el.tag, str):
                continue
            name = etree.QName(el).localname
            if name == "cb":
                col = int(el.get("n", "1")); line = 0
            elif name == "lb":
                line += 1
                el.set("n", str(line))
            elif name in ("persName", "placeName") and el.get("ref"):
                eid = slug(el.get("ref"))
                k += 1
                mid = "m-%s-%03d" % (fol, k)
                el.set(XID, mid)
                el.set("ref", "#" + eid)
                if eid in reg:
                    reg[eid]["mentions"].append((fol, mid, col, line, "".join(el.itertext())))
                else:
                    print("WARN unbekannte Referenz", eid, fol)
        # Whitespace innerhalb der Namen normalisieren
        for el in nd.iter(T + "persName", T + "placeName"):
            for t in el.iter():
                if t.text:
                    t.text = re.sub(r"\s+", " ", t.text)
                if t.tail:
                    t.tail = re.sub(r"\s+", " ", t.tail)
        # leere <note/> nicht mitnehmen
        for n in nd.findall(".//t:note", NS):
            if not norm_space("".join(n.itertext())):
                n.getparent().remove(n)
        b.append(nd)
        write(tei, OUT / "editions" / ("fol%s.xml" % fol))

    # ------------------------------------------------------------------ Karte
    msrc = etree.parse(str(SRC_MAP))
    mbody = msrc.find(".//t:body", NS)
    # Schlüssel Normdaten -> Registereinträge
    key2reg = defaultdict(list)
    for r in reg.values():
        if r["ref"]:
            key2reg[r["ref"][0]].append(r["id"])

    MAPSCAN = scan_id(1)  # fol. 154v
    tei = E("TEI")
    tei.set(XID, "karte.xml")
    tei.append(build_header("Mappa Mundi (fol. 154v)", "Kartenedition, Isidor von Sevilla, Clm 10058"))
    fac = SE(tei, "facsimile")
    sf = SE(fac, "surface", {XID: "fol154v"})
    SE(sf, "graphic", {"url": "%s%s/full/full/0/default.jpg" % (IIIF, MAPSCAN), "n": MAPSCAN,
                        "ulx": "0", "uly": "0", "lrx": "1842", "lry": "2618"})
    text = SE(tei, "text")
    mb = SE(text, "body")

    sections = []  # (head_en, [p...])
    cur = ("Winds", [])
    for el in mbody.iter():
        if not isinstance(el.tag, str):
            continue
        name = etree.QName(el).localname
        if name == "head":
            sections.append(cur)
            en = SECTION_EN_FIX.get(norm_space("".join(el.itertext())), norm_space("".join(el.itertext())))
            cur = (en, [])
        elif name == "p" and el.get("facs"):
            cur[1].append(el)
    sections.append(cur)

    group = None
    lab_no = 0
    unmatched = 0
    linked = 0
    for en, ps in sections:
        de = SECTION_DE.get(en, en)
        if not ps:  # reine Kontinent-Überschrift -> Gruppe
            group = SE(mb, "div", {"type": "group"})
            SE(group, "head", {XLANG: "en"}, en)
            SE(group, "head", {XLANG: "de"}, de)
            continue
        container = group if group is not None else mb
        d = SE(container, "div", {"type": "section"})
        SE(d, "head", {XLANG: "en"}, en)
        SE(d, "head", {XLANG: "de"}, de)
        for p in ps:
            lab_no += 1
            lid = "k%03d" % lab_no
            m = re.search(r"/(\d+),(\d+),(\d+),(\d+)$", p.get("facs"))
            x, y, w, h = (int(v) for v in m.groups())
            np_ = SE(d, "p", {XID: lid, "facs": "%d,%d,%d,%d" % (x, y, w, h)})
            ent = next((c for c in p.iter() if isinstance(c.tag, str) and etree.QName(c).localname in ("persName", "placeName")), None)
            label = norm_space("".join(p.itertext()))
            if ent is None:
                np_.text = label
                continue
            nn = SE(np_, etree.QName(ent).localname, text=label)
            if ent.get("type") and ent.get("type") != "/":
                nn.set("type", ent.get("type").strip())
            nr = norm_ref(ent.get("ref"))
            if nr:
                nn.set("ref", nr[2])
                hits = [i for i in key2reg.get(nr[0], [])]
                if hits:
                    nn.set("corresp", " ".join("#" + i for i in hits))
                    linked += 1
                    for i in hits:
                        reg[i]["maps"].append((lid, label))
            else:
                unmatched += 1
    write(tei, OUT / "editions" / "karte.xml")
    print("Karte: %d Beschriftungen, %d mit Register verknüpft, %d ohne Normdaten" % (lab_no, linked, unmatched))

    # ------------------------------------------------------------------ Register schreiben
    for kind, fname, title_de, list_tag, item_tag, name_tag in (
        ("person", "listperson.xml", "Personenregister", "listPerson", "person", "persName"),
        ("place", "listplace.xml", "Ortsregister", "listPlace", "place", "placeName"),
    ):
        tei = E("TEI")
        tei.append(build_header(title_de, "Isidor von Sevilla, Etymologiae XIV, Clm 10058"))
        text = SE(tei, "text")
        b = SE(text, "body")
        div = SE(b, "div")
        lst = SE(div, list_tag)
        items = sorted((r for r in reg.values() if r["kind"] == kind), key=lambda r: r["name"].lower())
        for r in items:
            it = SE(lst, item_tag, {XID: r["id"]})
            if r["type"]:
                it.set("type", r["type"])
            SE(it, name_tag, text=r["name"])
            for v in r["variants"]:
                SE(it, name_tag, {"type": "variant"}, v)
            if r["ref"]:
                SE(it, "idno", {"type": "URL", "subtype": r["ref"][1]}, r["ref"][2])
            g = SE(it, "noteGrp")
            for fol, mid, col, line, form in r["mentions"]:
                n = SE(g, "note", {"type": "mentions", "target": "fol%s.xml#%s" % (fol, mid),
                                   "n": fol, "subtype": "%d.%d" % (col, line)},
                       "%s, %d.%d " % (fol, col, line))
                SE(n, "term", text=norm_space(form))
            mg = SE(it, "noteGrp")
            for lid, label in r["maps"]:
                SE(mg, "note", {"type": "map", "target": "karte.xml#%s" % lid}, label)
        write(tei, OUT / "indices" / fname)

    used_types = sorted({r["type"] for r in reg.values() if r["type"]})
    print("Ortstypen:", used_types)
    unused = [r["id"] for r in reg.values() if not r["mentions"]]
    print("Registereinträge ohne Beleg im Text:", unused)


if __name__ == "__main__":
    sys.exit(main())
