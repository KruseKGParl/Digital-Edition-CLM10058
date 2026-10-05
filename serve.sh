#!/bin/sh
# Lokale Vorschau: baut nichts, liefert nur den Ordner html/ aus (immer relativ zu diesem Skript)
cd "$(dirname "$0")/html" && echo "http://localhost:8000" && python3 -m http.server 8000
