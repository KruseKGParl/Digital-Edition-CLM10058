// UI-Sprache: Deutsch / Englisch (i18next). Übersetzungen: translations.csv -> make_translations.py
const lngs = {
  de: { nativeName: 'Deutsch' },
  en: { nativeName: 'English' }
};

function applyLang(lng) {
  // Fließtexte in beiden Sprachen (.lang-de / .lang-en) werden per CSS umgeschaltet
  document.documentElement.dataset.lang = (lng || 'de').slice(0, 2) === 'de' ? 'de' : 'en';
  document.documentElement.lang = document.documentElement.dataset.lang;
}

const rerender = () => {
  $('body').localize();
  applyLang(i18next.resolvedLanguage);
  document.dispatchEvent(new CustomEvent('i18n:changed'));
};

$(function () {
  i18next
    .use(i18nextHttpBackend)
    .use(i18nextBrowserLanguageDetector)
    .init({
      debug: false,
      fallbackLng: 'en',
      supportedLngs: ['de', 'en'],
      nonExplicitSupportedLngs: true,
      load: 'languageOnly',
      backend: {
        loadPath: 'locales/{{lng}}/translation.json',
      }
    }, (err, t) => {
      if (err) return console.error(err);
      jqueryI18next.init(i18next, $, { useOptionsAttr: true });
      Object.keys(lngs).forEach((lng) => {
        const opt = new Option(lngs[lng].nativeName, lng);
        if (lng === i18next.resolvedLanguage) {
          opt.setAttribute('selected', 'selected');
        }
        $('#languageSwitcher').append(opt);
      });
      $('#languageSwitcher').on('change', function () {
        const chosenLng = $(this).find('option:selected').attr('value');
        i18next.changeLanguage(chosenLng, () => rerender());
      });
      rerender();
      document.dispatchEvent(new CustomEvent('i18n:ready'));
    });
});
