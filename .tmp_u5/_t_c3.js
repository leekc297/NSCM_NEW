// T541 C3 원천 고르기·Insert 리터럴 단위 시험(_trace.spec.ts 891줄 앞 블록과 같은 식)
const rows = require('./_t_c3.json');
const escRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
for (const [rid, c] of Object.entries(rows)) {
  const tgt = c.name; const srcs = (c.src || []).filter(s => s !== tgt);
  const rawsJ = (c.raws || []).join(' ');
  const insLit = (c.raws || []).length && (c.raws || []).every(s => /^\w*Insert\w*:\d+/i.test(s)) ? (new RegExp(`DefColumns\\.${escRe(tgt)}\\)\\s*,\\s*"([^"]*)"\\s*\\)`).exec(rawsJ) || [])[1] : undefined;
  const selfTrig = (c.raws || []).some(s => /^\w*(?:Changed|EditChange|Change|EditModeOff)\w*:\d+/.test(s) && s.includes(`DefColumns.${tgt})`));
  const lits = [...rawsJ.matchAll(/==\s*"(\w+)"/g)].map(m => m[1].toUpperCase());
  const byLit = srcs.filter(s => lits.some(l => s.toUpperCase().split('_').includes(l)));
  const head0 = tgt.split('_')[0];
  const cand = selfTrig ? [tgt] : byLit.length ? byLit : [...srcs].sort((a, b) => Number(b.split('_')[0] === head0) - Number(a.split('_')[0] === head0));
  const run = (c.viaPopup || (!srcs.length && !c.selfAssign)) && cand.length;
  console.log(rid, tgt, 'insLit=', insLit, 'selfTrig=', selfTrig, 'lits=', [...new Set(lits)].join('/'), 'cand=', cand.join('/'), 'measure=', !!run || insLit != null);
}
