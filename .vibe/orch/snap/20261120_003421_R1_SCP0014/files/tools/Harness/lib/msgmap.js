'use strict';
// msgmap — AS-IS 메시지 ID → TO-BE 메시지 ID (사용자 지시 2026-10-22)
//   AS-IS(TB_FX_MessageInfo)와 TO-BE(SCM_ADM_MSG_M)는 같은 ID 를 다른 문구에 쓴다(실측: MSG00001 AS-IS "모든 항목은 필수 입력입니다." / TO-BE "저장 하시겠습니까?").
//   그래서 AS-IS ID 를 그대로 쓰지 않고 **메시지 문구로 TO-BE ID 를 찾는다**: KO 문구 일치 → EN 문구 일치 → (없음) MSG?????(신규 등록 대상, MSG01001+ 채번 규칙).
//   정규화 = 공백·문장부호 무시 · 자리표시자 {0}{1}… 는 {n} 으로 같게 본다. 후보가 여럿이면 KO·EN 둘 다 맞는 것 → 사용 행 많은 것(ID 작은 것) 순.
const fs = require('fs'); const path = require('path');
const { readCsv } = require('../../TobeFacts/src/util');
const norm = s => String(s || '').replace(/\{\s*\d+\s*\}/g, '{n}').toLowerCase().replace(/[\s.,!?。！？:;'"`·~\-_()\[\]]/g, '');
const unq = s => String(s || '').replace(/^"+|"+$/g, '');

function load(cfg) {
  const asis = new Map(); // id → { ko, en }
  const af = path.join(cfg.asisOutDir || '', 'db', 'meta', 'dbo.TB_FX_MessageInfo.csv');
  if (fs.existsSync(af)) for (const r of readCsv(af)) { const id = unq(r.MessageID || r.messageid); if (id) asis.set(id.toUpperCase(), { ko: unq(r.Ko), en: unq(r.En) }); }
  const tobe = new Map(); // id → { KO, EN, CN }  (MSG 유형만)
  const tf = path.join(cfg.tobeOutDir || '', 'db', 'msg_master.csv');
  if (fs.existsSync(tf)) for (const r of readCsv(tf)) {
    const id = (r.msg_id || '').toUpperCase(); if (!/^MSG/.test(id) || (r.use_yn && r.use_yn !== 'Y')) continue;
    if (!tobe.has(id)) tobe.set(id, {}); tobe.get(id)[(r.lang_cd || '').toUpperCase()] = r.msg_nm || '';
  }
  const byKo = new Map(), byEn = new Map();
  for (const [id, t] of tobe) {
    if (t.KO) { const k = norm(t.KO); if (k) (byKo.get(k) || byKo.set(k, []).get(k)).push(id); }
    if (t.EN) { const k = norm(t.EN); if (k) (byEn.get(k) || byEn.set(k, []).get(k)).push(id); }
  }
  return { asis, tobe, byKo, byEn, ok: asis.size > 0 && tobe.size > 0 };
}

// asisId: AS-IS 코드(MSGxxxxx 등) · asisText: 분석서에 적힌 문구(있으면 우선) → { asis, tobe, how, asisText, tobeText, cands }
function map(M, asisId, asisText) {
  const id = String(asisId || '').trim().toUpperCase();
  const a = M.asis.get(id) || {}; const ko = asisText && /[가-힣]/.test(asisText) ? asisText : (a.ko || asisText || ''); const en = a.en || (asisText && !/[가-힣]/.test(asisText) ? asisText : '');
  const pick = list => [...new Set(list)].sort((x, y) => { const bx = M.tobe.get(x), by = M.tobe.get(y); const both = t => (norm(t.KO) === norm(ko) && norm(t.EN) === norm(en)) ? 0 : 1; return both(bx) - both(by) || x.localeCompare(y); });
  const kc = ko ? (M.byKo.get(norm(ko)) || []) : []; const ec = en ? (M.byEn.get(norm(en)) || []) : [];
  let cands = pick([...kc, ...ec]), how = kc.length ? 'KO 문구 일치' : ec.length ? 'EN 문구 일치' : '';
  const tobe = cands[0] || ''; const t = tobe ? M.tobe.get(tobe) : null;
  return { asis: id, tobe: tobe || 'MSG?????', how: how || (ko || en ? 'TO-BE 에 같은 문구 없음 — 신규 등록 대상(MSG01001+)' : 'AS-IS 문구를 찾지 못함 — 사람 확인'),
           asisText: ko || en, tobeText: t ? (t.KO || t.EN || '') : '', cands, sameId: !!tobe && tobe === id, idCollision: !tobe ? false : (M.tobe.has(id) && tobe !== id) };
}
// 이 AS-IS ID 를 TO-BE 에서 그대로 쓰면 뜻이 달라지는가(같은 ID 가 TO-BE 에 있는데 문구가 다름)
function collides(M, asisId) {
  const id = String(asisId || '').toUpperCase(); const a = M.asis.get(id); const t = M.tobe.get(id);
  if (!a || !t) return false; return norm(a.ko) !== norm(t.KO) && norm(a.en) !== norm(t.EN);
}
module.exports = { load, map, collides, norm };
