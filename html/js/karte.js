// Kartenedition: IIIF-Bild der Mappa Mundi mit klickbaren Zonen, Liste, Suche, Detailkarte
(function () {
  'use strict';
  var el = document.getElementById('mapViewer');
  if (!el || typeof OpenSeadragon === 'undefined') return;

  var imgW = parseInt(el.dataset.width, 10) || 1842;
  var items = Array.prototype.slice.call(document.querySelectorAll('.label-item'));
  var detail = document.getElementById('labelDetail');
  var overlays = {};
  var current = null;

  var viewer = OpenSeadragon({
    element: el,
    prefixUrl: 'vendor/openseadragon-bin-4.1.1/images/',
    tileSources: el.dataset.info,
    showNavigator: true,
    navigatorPosition: 'BOTTOM_LEFT',
    showRotationControl: true,
    gestureSettingsMouse: { clickToZoom: false },
    maxZoomPixelRatio: 3
  });

  function rectOf(li) {
    return viewer.viewport.imageToViewportRectangle(
      +li.dataset.x, +li.dataset.y, +li.dataset.w, +li.dataset.h);
  }

  viewer.addHandler('open', function () {
    items.forEach(function (li) {
      var z = document.createElement('div');
      z.className = 'map-zone ' + li.dataset.kind + (li.dataset.linked === '1' ? ' linked' : '');
      z.title = li.querySelector('.label-btn').textContent.trim();
      z.tabIndex = 0;
      z.addEventListener('click', function (ev) { ev.stopPropagation(); select(li, false); });
      z.addEventListener('keydown', function (ev) { if (ev.key === 'Enter') select(li, false); });
      overlays[li.id] = z;
      viewer.addOverlay({ element: z, location: rectOf(li) });
    });
    var hl = new URLSearchParams(location.search).get('hl');
    if (hl && document.getElementById(hl)) select(document.getElementById(hl), true);
  });

  function select(li, zoom) {
    if (current) {
      current.classList.remove('active');
      if (overlays[current.id]) overlays[current.id].classList.remove('active');
    }
    current = li;
    li.classList.add('active');
    overlays[li.id].classList.add('active');
    // Detailkarte füllen
    var tpl = li.querySelector('template.detail');
    detail.innerHTML = '';
    detail.appendChild(tpl.content.cloneNode(true));
    detail.hidden = false;
    // i18next lädt asynchron; ist es noch nicht bereit, übersetzt i18n.js die Karte nach dem Start
    if (window.$ && $.fn.localize) $(detail).localize();
    history.replaceState(null, '', '?hl=' + li.id);
    if (zoom) focusOn(li);
    // Liste: Abschnitt aufklappen und Eintrag in Sicht bringen
    var det = li.closest('details');
    if (det) det.open = true;
    // nur die Liste rollen, nicht die ganze Seite
    var list = document.getElementById('labelList');
    list.scrollTo({ top: Math.max(0, li.offsetTop - list.clientHeight / 3), behavior: 'smooth' });
  }

  function focusOn(li) {
    var r = rectOf(li);
    var min = 0.22;                       // Mindestausschnitt (Anteil der Bildbreite)
    var w = Math.max(r.width * 4, min), h = Math.max(r.height * 4, min * 0.9);
    var cx = r.x + r.width / 2, cy = r.y + r.height / 2;
    viewer.viewport.fitBoundsWithConstraints(new OpenSeadragon.Rect(cx - w / 2, cy - h / 2, w, h));
  }

  items.forEach(function (li) {
    li.querySelector('.label-btn').addEventListener('click', function () { select(li, true); });
  });

  // ---------- Filter ----------
  var search = document.getElementById('labelSearch');
  var linked = document.getElementById('linkedToggle');
  var zones = document.getElementById('zonesToggle');
  function applyFilter() {
    var q = search.value.trim().toLowerCase();
    var onlyLinked = linked.checked;
    items.forEach(function (li) {
      var show = (!q || li.dataset.text.indexOf(q) !== -1) && (!onlyLinked || li.dataset.linked === '1');
      li.hidden = !show;
      if (overlays[li.id]) overlays[li.id].classList.toggle('filtered-out', !show);
    });
    document.querySelectorAll('.map-section').forEach(function (d) {
      d.hidden = !d.querySelector('.label-item:not([hidden])');
    });
    document.querySelectorAll('.map-group').forEach(function (g) {
      g.hidden = !g.querySelector('.map-section:not([hidden])');
    });
  }
  search.addEventListener('input', applyFilter);
  linked.addEventListener('change', applyFilter);
  zones.addEventListener('change', function () { el.classList.toggle('zones-off', !zones.checked); });
})();
