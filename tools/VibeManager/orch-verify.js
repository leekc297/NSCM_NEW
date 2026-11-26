// 2026-11-23 개념 재정립(사용자 지적 '반영실패가 계속 나오면 검사기 도출부터 승인까지 불필요한 토큰만 소모'): 개선안 검증을 항목 단위로 나누고 판정을 코드가 한다.
//   종전: verify 는 글 한 덩어리이고 반영한 AI 가 verified true/false 하나를 냈다. 항목 4개 중 2개가 반영 시점에 잴 수 없는 것이어도 false 가 되어 대상 파일을 전부 되돌렸다
//         (실측 11-19~11-23 반영 실패 35건 중 18건. 20261123000419_VISION 5회, 20261120183740_VISION, 20261121000456_SELF, 20261120005819_INC, 20261120115806_VISION_2)
//   지금: 항목마다 시점을 나눈다. apply = 반영할 때 실행, later = 반영 뒤 확인(다음 CheckList 실행, 창 다시 로드, 시간 경과, 사용자 실행), gate = VMO 게이트가 판정(run_all, 구문 검사, 정의 정합).
//         합격 판정은 apply 항목 결과만 쓴다. later 와 실행하지 못한 항목(blocked)은 반영 뒤 확인 목록으로 넘긴다. 실패(fail)가 1건이라도 있으면 종전처럼 되돌린다.
//   이 모듈은 파일을 읽거나 쓰지 않는다(글 분류와 판정만).
'use strict';

const CIRC = '①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳';
// 반영 시점에 잴 수 없는 항목. 근거 사례는 test/t_orch_verify.js 에 원문으로 있다
const LATER = [
  [/다음(?:\s+\S+){0,3}?\s+(?:CheckList|체인|실행|점검|진단|Overall Review)/, '다음 실행이 있어야 확인'],
  [/CheckList(?:\s*전체)?\s*(?:동시\s*)?(?:실행|시작|재수행|수행)\s*(?:뒤|후|에서)/, 'CheckList 실행이 있어야 확인'],
  [/(?:창|VS ?Code)\s*(?:창\s*)?다시\s*로드\s*(?:뒤|후|하면)/, '창 다시 로드 뒤 확인'],
  [/실가동|실제 가동/, '실가동 기록이 있어야 확인'],
  [/\d+\s*(?:시간|일)\s*(?:동안|이 지난 뒤|지난 뒤|경과 뒤)/, '시간이 지나야 확인'],
  [/(?:Source Backup|Download & Merge|업무 작업|작업 목록에서[^.]*)\s*(?:실행|시작)\s*(?:뒤|후)/, '사용자 실행이 있어야 확인'],
  [/사용자(?:가)?\s*(?:직접\s*)?(?:실행|확인)(?:한|하는|해야|\s*뒤|\s*후)/, '사용자 실행이 있어야 확인'],
];
// VMO 게이트가 반영 전후로 재는 항목. 게이트를 돌리는 안에서만 gate 로 분류한다
const GATE = [/run_all(?:\.js)?/, /구문 검사/, /정의 정합/];
const GATE_ONLY = /^(?:node\s+)?(?:tools\/VibeManager\/)?(?:test\/)?run_all(?:\.js)?(?:\s+\S+)?\s*(?:전체\s*)?(?:통과|PASS|FAIL 0|ALL PASS)?[\s.,]*$/;

const one = s => String(s == null ? '' : s).replace(/\s+/g, ' ').trim();

/** 문장으로 나눈다. 작은따옴표 인용 안에서 끝난 마침표에서는 나누지 않는다(예: '반영 실패. 검증 실패') */
function sentences(t) {
  const out = [];
  for (const p of String(t).split(/(?<=[^\d\s]\.)\s+(?=\S)/)) { const prev = out[out.length - 1]; if (prev != null && (prev.match(/'/g) || []).length % 2 === 1) out[out.length - 1] = `${prev} ${p}`; else out.push(p); }
  return out;
}

/** verify 글을 항목 글 배열로 나눈다. 번호(① · 1) · 단계 1:)가 있으면 번호로, 없으면 문장으로 나눈다 */
function splitText(verify) {
  const t = one(verify); if (!t) return [];
  let parts = null;
  if (new RegExp(`[${CIRC}]`).test(t)) parts = t.split(new RegExp(`\\s*(?=[${CIRC}])`));
  else if (/(?:^|[\s·,.])\(?\d{1,2}\)\s/.test(t) && /(?:^|[\s·,.])\(?2\)\s/.test(t)) parts = t.split(/(?:^|(?<=[\s·,.]))\s*(?=\(?\d{1,2}\)\s)/);
  else if (/단계\s*\d+\s*:/.test(t) && /단계\s*2\s*:/.test(t)) parts = t.split(/\s*(?=단계\s*\d+\s*:)/);
  else parts = sentences(t);
  const out = [];
  for (let p of parts) { p = one(p).replace(/^[·,]\s*/, '').replace(/\s*[·,]$/, ''); if (p.replace(/[^\w가-힣]/g, '').length < 2) continue; out.push(p); }
  // 번호로 나눴을 때 번호 앞 머리말(예: '반영 전 값: ...')이 따로 떨어지면 첫 항목에 붙인다
  if (out.length > 1 && !new RegExp(`^(?:[${CIRC}]|\\(?\\d{1,2}\\)|단계\\s*\\d+\\s*:)`).test(out[0]) && new RegExp(`^(?:[${CIRC}]|\\(?\\d{1,2}\\)|단계\\s*\\d+\\s*:)`).test(out[1])) { out[1] = `${out[0]} ${out[1]}`; out.shift(); }
  return out;
}

/** 항목 1개의 시점. 반환 { when: 'apply'|'later'|'gate', why } */
function classify(text, opt) {
  const t = one(text);
  for (const [re, why] of LATER) if (re.test(t)) return { when: 'later', why };
  if (opt && opt.gated) {
    const body = t.replace(new RegExp(`^(?:[${CIRC}]|\\(?\\d{1,2}\\)|단계\\s*\\d+\\s*:)\\s*`), '');
    if (GATE_ONLY.test(body) || (GATE.some(re => re.test(body)) && body.length <= 60 && !/t_[a-z0-9_]+\.js/i.test(body))) return { when: 'gate', why: 'VMO 게이트가 반영 전후로 판정' };
  }
  return { when: 'apply', why: '' };
}

/** verify 글 → 항목 배열 [{ n, text, when, why }]. opt.gated = 반영 뒤 VMO 게이트를 돌리는 안 */
function items(verify, opt) {
  const out = [];
  for (const part of splitText(verify)) for (const text of splitMixed(part)) out.push(text);
  return out.map((text, i) => Object.assign({ n: i + 1, text: text.slice(0, 600) }, classify(text, opt)));
}
const laterAt = t => { let at = -1; for (const [re] of LATER) { const m = re.exec(t); if (m && (at < 0 || m.index < at)) at = m.index; } return at; };
/** 한 항목 안에 지금 잴 수 있는 확인과 반영 뒤 확인이 섞여 있으면 나눈다(지금 잴 수 있는 부분을 반영 뒤 확인으로 넘기지 않으려고).
 *  예: '삭제 뒤 Test-Path 3개 모두 False, 다음 S10 점검에 세 key 없음' → 앞은 apply, 뒤는 later */
function splitMixed(part) {
  if (laterAt(part) < 0) return [part];
  const out = [];
  for (const sen of sentences(part)) {
    const at = laterAt(sen); if (at < 0) { out.push(sen); continue; }
    const head = sen.slice(0, at); const cut = Math.max(head.lastIndexOf(', '), head.lastIndexOf(' · '), head.lastIndexOf('. '));
    const a = cut > 0 ? one(sen.slice(0, cut)) : ''; const b = cut > 0 ? one(sen.slice(cut + 1).replace(/^[·,\s]+/, '')) : sen;
    if (a.replace(/^(?:[①-⑳]|\(?\d{1,2}\)|단계\s*\d+\s*:)\s*/, '').replace(/[^\w가-힣]/g, '').length >= 8) { out.push(a); out.push(b); } else out.push(sen);
  }
  return out.filter(x => one(x).replace(/[^\w가-힣]/g, '').length >= 2);
}

/** 반영 지시문에 넣는 줄. 항목이 없으면 빈 배열 */
function promptLines(list) {
  if (!list || !list.length) return [];
  const ko = { apply: '반영할 때 실행', later: '반영 뒤 확인(지금 실행하지 않음)', gate: 'VMO 게이트가 판정(지금 실행하지 않음)' };
  return [
    '[검증 항목] verify 를 항목으로 나눈 것이다. 합격 판정은 "반영할 때 실행" 항목만 쓴다. 나머지는 실행하지 않고 판정에서 뺀다.',
    ...list.map(x => `  v${x.n} (${ko[x.when]}${x.why ? `, ${x.why}` : ''}) ${x.text}`),
    '결과 JSON 의 verify_items 에 "반영할 때 실행" 항목마다 { "n": 번호, "result": "pass|fail|blocked", "note": "실행한 명령과 출력 요약" } 를 적는다.',
    'pass = 실행했고 기대와 맞음. fail = 실행했고 기대와 다름. blocked = 지금 실행할 수 없음(CheckList 실행, 창 다시 로드, 시간 경과, 사용자 실행, 권한 차단이 필요). blocked 는 note 에 사유를 적는다. 실행할 수 있는 항목을 blocked 로 내지 않는다.',
    'verified 는 "반영할 때 실행" 항목에 fail 이 없으면 true 로 낸다. 반영 뒤 확인 항목과 blocked 항목 때문에 false 로 내지 않는다.',
  ];
}

/** 반영 결과 판정. list = items() 결과, out = 반영한 AI 의 결과 JSON, opt.gated = 게이트를 돌리는 안.
 *  반환 { verified, legacy, pass, fails[], blocked[], later[], gate[], post[], why } post = 반영 뒤 확인 목록(later + blocked) */
function judge(list, out, opt) {
  const gated = !!(opt && opt.gated); const o = out || {};
  const later = (list || []).filter(x => x.when === 'later'); const gate = (list || []).filter(x => x.when === 'gate'); const apply = (list || []).filter(x => x.when === 'apply');
  const base = { legacy: false, pass: 0, fails: [], blocked: [], later, gate, post: later.map(x => ({ n: x.n, text: x.text, why: x.why })), why: '' };
  // 항목이 없거나(verify 빈 글) AI 가 항목 결과를 내지 않았으면 종전 판정(verified 값)
  if (!list || !list.length) return Object.assign(base, { legacy: true, verified: o.verified === true, why: 'verify 항목 없음' });
  const res = Array.isArray(o.verify_items) ? o.verify_items : null;
  if (!res) {
    if (!apply.length) return Object.assign(base, { verified: true, why: '반영할 때 실행할 항목 없음' });
    return Object.assign(base, { legacy: true, verified: o.verified === true, why: '항목 결과 없음, verified 값으로 판정' });
  }
  const by = new Map(); for (const r of res) { const n = Number(r && r.n); if (n) by.set(n, r); }
  const missing = [];
  for (const x of apply) {
    const r = by.get(x.n); const v = r ? String(r.result || '').toLowerCase() : '';
    if (v === 'pass') base.pass++;
    else if (v === 'fail') base.fails.push({ n: x.n, text: x.text, note: one(r.note).slice(0, 300) });
    else if (v === 'blocked') { base.blocked.push({ n: x.n, text: x.text, note: one(r.note).slice(0, 300) }); base.post.push({ n: x.n, text: x.text, why: one(r.note).slice(0, 200) || '반영할 때 실행하지 못함' }); }
    else missing.push(x.n);
  }
  if (base.fails.length) return Object.assign(base, { verified: false, why: `실행한 항목 실패 ${base.fails.length}건(v${base.fails.map(f => f.n).join(', v')})` });
  if (missing.length && o.verified !== true) return Object.assign(base, { verified: false, why: `결과가 없는 항목 v${missing.join(', v')}` });
  // 실행한 항목이 하나도 없으면 게이트가 있는 안만 합격(게이트가 없는 안은 확인된 것이 없음)
  if (apply.length && !base.pass && !missing.length && !gated) return Object.assign(base, { verified: false, why: `반영할 때 실행한 항목 0건(실행 못 함 ${base.blocked.length}건), 게이트 없음` });
  return Object.assign(base, { verified: true, why: '' });
}

/** 이력 한 줄에 넣는 요약 */
function summary(j) {
  if (!j) return '';
  const a = []; if (j.pass) a.push(`실행 통과 ${j.pass}건`); if (j.fails && j.fails.length) a.push(`실패 ${j.fails.length}건`); if (j.blocked && j.blocked.length) a.push(`실행 못 함 ${j.blocked.length}건`); if (j.later && j.later.length) a.push(`반영 뒤 확인 ${j.later.length}건`); if (j.gate && j.gate.length) a.push(`게이트 판정 ${j.gate.length}건`);
  return a.join(', ');
}

module.exports = { splitText, classify, items, promptLines, judge, summary, LATER };
