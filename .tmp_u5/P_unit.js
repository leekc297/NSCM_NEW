const fs = require('fs');
const rel = 'Doc/_rules_v2/_tobe/10_popup_modal.md'; const m = new Map();
fs.readFileSync(rel, 'utf8').split(/\r?\n/).forEach((ln, i) => { const r = /^\|\s*\d+\s*\|\s*`(\w+)`\s*\|([^|]*)\|/.exec(ln); if (!r) return; for (const q of r[2].matchAll(/`(\w+)`/g)) if (!m.has(q[1])) m.set(q[1], { modal: r[1], ref: `${rel}:${i + 1}` }); });
console.log([...m.entries()].map(([k, v]) => `${k}->${v.modal}@${v.ref}`).join('\n'));
const rm = m.get('SCM0002_CitybyCountry'); const compToks = rm.modal.replace(/([a-z])([A-Z])/g, '$1 $2').toLowerCase().split(/\s+/).filter(t => t.length >= 3 && !['modal', 'by'].includes(t));
console.log('toks', compToks, 'Region Popup hit', compToks.filter(t => 'region popup'.includes(t)), 'City by Country hit', compToks.filter(t => 'city by country'.includes(t)));
function match(cls, names, all) {
  const clsW = new Set(cls.replace(/^[A-Z]+\d+_/, '').replace(/([a-z])([A-Z])/g, '$1 $2').split(/[\s_\d]+/).map(w => w.toLowerCase()).filter(w => w.length >= 3 && !['form', 'popup'].includes(w)));
  const texts = [...new Set(all.map(t => t.trim().replace(/\s*\(F\d+\)$/i, '').trim()).filter(t => !!t && t.length <= 40))];
  for (const n of names) { const nw = n.toLowerCase().split(/[\s_]+/).filter(Boolean); if (!nw.length) continue;
    const t = texts.find(tx => { const tw = tx.toLowerCase().split(/\s+/); if (tw.length <= nw.length) return false; for (let s0 = 0; s0 + nw.length <= tw.length; s0++) { if (nw.every((w, j) => tw[s0 + j] === w)) { const rest = tw.filter((_, j) => j < s0 || j >= s0 + nw.length); return rest.length > 0 && tw.every(w => clsW.has(w)); } } return false; });
    if (t) return `${n} -> ${t}`; }
  return null;
}
const btns = ['KOR', 'Home', 'Distribution Route', 'Search(F5)', 'Excel Form', 'Excel Upload', 'Insert(F8)', 'Delete(F9)', 'Save(F7)', 'Batch Save', 'Sort(F3)'];
console.log('Upload', match('ExcelUploadForm2', ['Upload', 'Upload', 'Eaxel_Upload'], btns));
console.log('FromSrch', match('SCM0002_CitybyCountry', ['From Srch', 'FromSrch'], btns));
console.log('Save vs Batch Save (cls SaveForm)', match('SCM0002_SavePopup', ['Save'], btns));
console.log('Form (ExcelUploadForm2) -> Excel Form?', match('ExcelUploadForm2', ['Form'], btns));
