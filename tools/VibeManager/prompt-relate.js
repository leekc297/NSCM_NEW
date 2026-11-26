// 2026-11-23 사용자: 작업 중 입력한 프롬프트는 기본 대기열. 현재 작업과 같은 안건이면 응답 중이라도 그 작업에 바로 반영(두 번 작업 방지).
//   judge(text, ctx) → { related, why }. 규칙 순서대로 처음 맞는 규칙이 판정한다. 맞는 규칙이 없으면 대기열(related false).
//   ctx = { screens: [현재 작업 화면 ID], texts: [현재 작업 지시문, 체인 이름, 단계 이름] }
//   ① 맨 앞 '+' = 현재 작업에 반영, 맨 앞 '>' = 대기열(사용자 지정)
//   ② 현재 작업 화면 ID 가 들어 있음 = 반영 · 다른 화면 ID 만 있음 = 대기열
//   ③ 새 작업 표현(끝나면, 다음 작업, 별개로 등) = 대기열
//   ④ 이어 말하기 표현(지금 작업, 방금, 추가로, 누락, 대신 등) = 반영
//   ⑤ 현재 작업 지시문과 같은 낱말 3개 이상, 또는 2개 이상이면서 새 글 낱말의 1/3 이상 = 반영
'use strict';

const SID = /\b[A-Z]{2,4}\d{4}[A-Z]?\b/g;
const NEW_TASK = /(끝나면|끝난\s*(뒤|후|다음)|완료\s*(되면|후|뒤)|다음\s*(작업|으로|에)|그\s*다음|이후에|별개로|별도로|별건|새\s*(작업|요청|건)|새로운\s*(작업|요청|건)|다른\s*(작업|건|화면|요청)|따로\s*(진행|작업))/;
const CONT = /(지금\s*(하는|작업|진행|돌고|하고)|현재\s*(작업|진행|하는|돌고)|진행\s*중인|하고\s*있는|돌고\s*있는|방금|아까|이번\s*작업|이\s*작업|위\s*작업|그\s*작업|같은\s*(작업|건|안건)|추가로|덧붙여|덧붙이|참고로|빠졌|빠진|누락|대신|말고|아니라|수정해서|반영해|반영하|감안|고려해|고려하|같이\s*(해|처리|반영)|함께\s*(해|처리|반영)|잠깐|그리고\s|그런데\s|근데\s|제\s*말은|다시\s*말해)/;
const STOP = new Set(['해주세요', '주세요', '합니다', '있습니다', '없습니다', '입니다', '그리고', '하지만', '그래서', '에서', '으로', '하는', '하고', '있는', '없는', '같은', '경우', '현재', '지금', '해줘', '확인', '작업', '부탁', '요청', '대한', '관련', 'the', 'and', 'for']);
const JOSA = /(으로|에서|에게|까지|부터|처럼|보다|은|는|이|가|을|를|에|의|도|만|로|와|과)$/;

function idsOf(t) { return [...new Set(String(t || '').toUpperCase().match(SID) || [])]; }
function words(t) {
  const out = new Set();
  for (let w of String(t || '').toLowerCase().split(/[^0-9a-z가-힣_.]+/)) {
    w = w.replace(/^\.+|\.+$/g, ''); if (w.length >= 3 && /[가-힣]/.test(w)) w = w.replace(JOSA, '');
    if (w.length >= 2 && !STOP.has(w) && !/^\d+$/.test(w)) out.add(w);
  }
  return out;
}

function judge(text, ctx) {
  const t = String(text || '').trim(); const c = ctx || {};
  if (!t) return { related: false, why: '빈 글' };
  if (t.startsWith('+')) return { related: true, why: "맨 앞 '+' 표시", text: t.slice(1).trim() };
  if (t.startsWith('>')) return { related: false, why: "맨 앞 '>' 표시", text: t.slice(1).trim() };
  const cur = new Set((c.screens || []).map(s => String(s || '').toUpperCase()).filter(Boolean));
  for (const s of (c.texts || [])) for (const id of idsOf(s)) cur.add(id);
  const mine = idsOf(t);
  if (mine.some(id => cur.has(id))) return { related: true, why: `현재 작업 화면 ${mine.filter(id => cur.has(id)).join(', ')}` };
  if (mine.length && cur.size) return { related: false, why: `다른 화면 ${mine.join(', ')}` };
  const nt = NEW_TASK.exec(t); if (nt) return { related: false, why: `새 작업 표현 '${nt[0]}'` };
  const ct = CONT.exec(t); if (ct) return { related: true, why: `이어 말하기 표현 '${ct[0].trim()}'` };
  const a = words(t); const b = new Set(); for (const s of (c.texts || [])) for (const w of words(s)) b.add(w);
  const shared = [...a].filter(w => b.has(w));
  if (shared.length >= 3 || (shared.length >= 2 && shared.length * 3 >= a.size)) return { related: true, why: `같은 낱말 ${shared.slice(0, 5).join(', ')}` };
  return { related: false, why: shared.length ? `같은 낱말 ${shared.length}개(기준 미달)` : '현재 작업과 겹치는 내용 없음' };
}

module.exports = { judge, idsOf, words };
