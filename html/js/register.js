// Register: Tabulator-Tabelle aus der (server-seitig erzeugten) HTML-Tabelle; Spaltentitel/Typen sind übersetzbar
(function () {
  'use strict';
  var src = document.getElementById('regTable');
  if (!src || typeof Tabulator === 'undefined') return;
  var isPlace = src.dataset.kind === 'place';

  var rows = Array.prototype.slice.call(src.tBodies[0].rows).map(function (tr) {
    var c = tr.cells;
    return {
      name: c[0].textContent.trim(), href: c[0].dataset.href,
      type: c[1].dataset.type || '', variants: c[2].textContent.trim(),
      auth: c[3].innerHTML.trim(), mentions: parseInt(c[4].textContent, 10) || 0,
      map: parseInt(c[5].textContent, 10) || 0
    };
  });

  var holder = document.createElement('div');
  src.parentNode.insertBefore(holder, src);
  var table = null;

  function t(key, fallback) { return (window.i18next && i18next.isInitialized) ? i18next.t(key) : fallback; }

  function build() {
    src.hidden = true;
    if (table) table.destroy();
    var data = rows.map(function (r) {
      return Object.assign({}, r, { typeLabel: r.type ? t('type__' + r.type, r.type) : '' });
    });
    var cols = [
      { title: t('reg__name', 'Name'), field: 'name', headerFilter: 'input', width: 220,
        formatter: function (cell) { var d = cell.getData(); return '<a href="' + d.href + '">' + cell.getValue() + '</a>'; } },
      { title: t('reg__variants', 'Belegformen'), field: 'variants', headerFilter: 'input' },
      { title: t('reg__authority', 'Normdaten'), field: 'auth', formatter: 'html', headerSort: false, width: 200,
        headerFilter: 'input', headerFilterFunc: function (v, d) { return !v || d.toLowerCase().indexOf(v.toLowerCase()) !== -1; } },
      { title: t('reg__mentions', 'Belege'), field: 'mentions', hozAlign: 'right', sorter: 'number', width: 100 }
    ];
    if (isPlace) {
      cols.splice(1, 0, { title: t('reg__type', 'Typ'), field: 'typeLabel', headerFilter: 'input', width: 150 });
      cols.push({ title: t('reg__map', 'Karte'), field: 'map', hozAlign: 'right', sorter: 'number', width: 90 });
    }
    table = new Tabulator(holder, {
      data: data, columns: cols, layout: 'fitColumns',
      pagination: true, paginationSize: 50, paginationSizeSelector: [25, 50, 100, true],
      initialSort: [{ column: 'name', dir: 'asc' }], responsiveLayout: 'collapse'
    });
  }

  if (window.i18next && i18next.isInitialized) build();
  document.addEventListener('i18n:changed', function () { if (i18next.isInitialized) build(); });
})();
