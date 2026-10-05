// Leseansicht: Faksimile (OpenSeadragon/IIIF), Umschalter, Klick auf Personen und Orte
(function () {
  'use strict';

  // ---------- Faksimile ----------
  var osdEl = document.getElementById('osd');
  var viewer = null;
  function initViewer() {
    if (viewer || !osdEl || typeof OpenSeadragon === 'undefined') return;
    viewer = OpenSeadragon({
      element: osdEl,
      prefixUrl: 'vendor/openseadragon-bin-4.1.1/images/',
      tileSources: osdEl.dataset.info,
      showNavigator: true,
      navigatorPosition: 'BOTTOM_RIGHT',
      showRotationControl: true,
      gestureSettingsMouse: { clickToZoom: false },
      maxZoomPixelRatio: 3
    });
  }
  initViewer();

  // ---------- Umschalter ----------
  var row = document.getElementById('editionRow');
  var pane = document.getElementById('textPane');
  var btnFacs = document.getElementById('toggleFacs');
  var btnLines = document.getElementById('toggleLines');
  function store(k, v) { try { localStorage.setItem(k, v); } catch (e) {} }
  function load(k, d) { try { var v = localStorage.getItem(k); return v === null ? d : v; } catch (e) { return d; } }

  function setFacs(on) {
    row.classList.toggle('facs-hidden', !on);
    btnFacs.classList.toggle('active', on);
    btnFacs.setAttribute('aria-pressed', on);
    store('facs', on ? '1' : '0');
    if (on && viewer) setTimeout(function () { viewer.viewport.goHome(true); }, 50);
  }
  function setLines(on) {
    pane.classList.toggle('lines', on);
    pane.classList.toggle('flow', !on);
    btnLines.classList.toggle('active', on);
    btnLines.setAttribute('aria-pressed', on);
    store('lines', on ? '1' : '0');
  }
  btnFacs.addEventListener('click', function () { setFacs(!btnFacs.classList.contains('active')); });
  btnLines.addEventListener('click', function () { setLines(!btnLines.classList.contains('active')); });
  setFacs(load('facs', '1') === '1');
  setLines(load('lines', '1') === '1');

  // ---------- Blattauswahl ----------
  var sel = document.getElementById('folioSelect');
  if (sel) sel.addEventListener('change', function () { window.location.href = sel.value; });

  // ---------- Personen und Orte ----------
  var open = null;
  function closePopover() { if (open) { open.hide(); open = null; } }

  document.querySelectorAll('.entity').forEach(function (el) {
    var tpl = document.getElementById('ent-' + el.dataset.ref);
    if (!tpl) return;
    var pop = new bootstrap.Popover(el, {
      html: true, sanitize: false, trigger: 'manual', placement: 'auto',
      container: 'body', customClass: 'ent-popover',
      content: function () { return tpl.content.firstElementChild.cloneNode(true); }
    });
    el.addEventListener('shown.bs.popover', function () {
      var tip = document.getElementById(el.getAttribute('aria-describedby'));
      if (tip && window.$ && $.fn.localize) $(tip).localize();
    });
    function toggle(ev) {
      ev.stopPropagation();
      if (open === pop) { closePopover(); return; }
      closePopover();
      pop.show();
      open = pop;
    }
    el.addEventListener('click', toggle);
    el.addEventListener('keydown', function (ev) { if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); toggle(ev); } });
    // gleiche Person/gleicher Ort im Text mitmarkieren
    el.addEventListener('mouseenter', function () { highlight(el.dataset.ref, true); });
    el.addEventListener('mouseleave', function () { highlight(el.dataset.ref, false); });
  });
  function highlight(ref, on) {
    document.querySelectorAll('.entity[data-ref="' + ref + '"]').forEach(function (n) { n.classList.toggle('hl', on); });
  }
  document.addEventListener('click', function (ev) {
    if (open && !ev.target.closest('.popover')) closePopover();
  });
  document.addEventListener('keydown', function (ev) { if (ev.key === 'Escape') closePopover(); });

  // Sprung aus einem Register: fol155r.html#m-155r-004
  function focusHash() {
    var id = decodeURIComponent(location.hash.slice(1));
    if (!id) return;
    var el = document.getElementById(id);
    if (!el) return;
    el.scrollIntoView({ block: 'center' });
    el.classList.add('hl');
    setTimeout(function () { el.classList.remove('hl'); }, 3500);
  }
  window.addEventListener('hashchange', focusHash);
  focusHash();
})();
