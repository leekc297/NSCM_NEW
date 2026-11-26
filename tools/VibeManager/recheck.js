// 2026-11-19 사용자: 미검증 해소(검사엔진 보완) 뒤에는 보완 전 CheckList 건수를 보여 주지 않는다. 보여 줄 때는 보완 뒤 다시 수행한 CheckList 건수만.
//   판단 = 보완 표식(Doc/verify/<ID>/_unverified_fix.json fixed_at · 🧪 세션이 pending_recheck.py --mark 로 남김)이 원장(verify_ledger.csv)보다 뒤면 '재수행 전'.
//   CheckList 를 다시 수행하면 원장이 새로 써져 풀린다. 같은 판단 = tools/Harness/verify/pending_recheck.py
const fs = require('fs');
const path = require('path');
const { fmtDT } = require('./date-fmt'); // 2026-11-23 R27: 화면 note 일자 = Windows 짧은 날짜 형식 · fixedAt, ledgerAt 저장 값은 stamp 그대로

const two = n => String(n).padStart(2, '0');
const stamp = ms => { const d = new Date(ms); return `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())} ${two(d.getHours())}:${two(d.getMinutes())}`; };

/** vd = Doc/verify/<ID> · 재수행 전이면 { fixedAt, ledgerAt, note } · 아니면 null */
function pendingRecheck(vd) {
  try {
    const m = path.join(vd, '_unverified_fix.json'), l = path.join(vd, 'verify_ledger.csv');
    if (!fs.existsSync(m) || !fs.existsSync(l)) return null;
    const fx = Number(JSON.parse(fs.readFileSync(m, 'utf8').replace(/^﻿/, '')).fixed_at) * 1000, lt = fs.statSync(l).mtimeMs;
    if (!fx || fx <= lt) return null;
    return { fixedAt: stamp(fx), ledgerAt: stamp(lt), note: `미검증 해소 보완 ${fmtDT(fx)} · CheckList 재수행 전(보완 전 건수는 표시하지 않음, 재수행 뒤 표시)` };
  } catch { return null; }
}

module.exports = { pendingRecheck };
