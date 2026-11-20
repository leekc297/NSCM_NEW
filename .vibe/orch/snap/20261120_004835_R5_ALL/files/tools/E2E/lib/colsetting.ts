// 컬럼 설정 팝업의 필수 컬럼 판정(2026-11-02 엔진 갭 EG392·EG021). 순수 함수 — colsetting.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };
const norm = (s: string) => s.replace(/[*\s]/g, '').toLowerCase();

/** required 메타 필수(USER_SELECTABLE_FLAG=N) 라벨 · left·right 팝업 목록 라벨 — 목록 어디에도 없는 라벨은 측정 불가(폭 0 등 목록 제외) */
export function judgeRequiredShown(s: { required: string[]; left: string[]; right: string[] }): J {
  if (!s.required.length) return { result: 'ERROR', why: '[측정 경로 없음] 메타 필수 컬럼 0' };
  if (!s.left.length && !s.right.length) return { result: 'ERROR', why: '[측정 경로 없음] 팝업 목록을 읽지 못함' };
  const L = new Set(s.left.map(norm)), R = new Set(s.right.map(norm));
  const inLeft = s.required.filter(x => L.has(norm(x)) && !R.has(norm(x)));
  const none = s.required.filter(x => !L.has(norm(x)) && !R.has(norm(x)));
  if (inLeft.length) return { result: 'FAIL', why: `필수 컬럼이 Invisible 목록에 있음 ${inLeft.length}건: ${inLeft.slice(0, 8).join(', ')}` };
  return { result: 'PASS', why: `필수 ${s.required.length - none.length}건 전부 Visible${none.length ? ` · 목록 제외 ${none.length}건(${none.slice(0, 5).join(', ')})` : ''}` };
}

/** red 빨간 라벨로 표시된 라벨 · right Visible 목록 */
export function judgeRequiredRed(s: { required: string[]; right: string[]; red: string[] }): J {
  const R = new Set(s.right.map(norm)), C = new Set(s.red.map(norm));
  const tgt = s.required.filter(x => R.has(norm(x)));
  if (!tgt.length) return { result: 'ERROR', why: '[측정 경로 없음] Visible 목록에 필수 컬럼 없음' };
  const notRed = tgt.filter(x => !C.has(norm(x)));
  const req = new Set(s.required.map(norm)); const extra = s.red.filter(x => !req.has(norm(x)));
  if (notRed.length) return { result: 'FAIL', why: `필수 컬럼 빨간 표시 없음 ${notRed.length}건: ${notRed.slice(0, 8).join(', ')}` };
  if (extra.length) return { result: 'FAIL', why: `필수 아닌 컬럼이 빨간 표시 ${extra.length}건: ${extra.slice(0, 8).join(', ')}` };
  return { result: 'PASS', why: `필수 ${tgt.length}건 빨간 표시 · 그 외 0` };
}

/** 필수 컬럼을 Invisible 로 옮기려 할 때 — stayed 그대로 Visible · msg 안내 문구 / ctlMoved 대조군(필수 아닌 컬럼)은 이동됨 */
export function judgeRequiredLocked(s: { col: string; stayed: boolean | null; msg: string; ctl: string; ctlMoved: boolean | null }): J {
  if (s.stayed == null) return { result: 'ERROR', why: `[측정 경로 없음] 필수 컬럼 ${s.col} 이동 시도 실패` };
  if (!s.stayed) return { result: 'FAIL', why: `필수 컬럼 ${s.col} 이 Invisible 로 이동됨` };
  if (s.ctl && s.ctlMoved === false) return { result: 'ERROR', why: `[측정 경로 없음] 대조군 ${s.ctl} 도 이동 안 됨 — 이동 조작이 동작하지 않았을 수 있음` };
  if (!s.msg.trim()) return { result: 'FAIL', why: `필수 컬럼 ${s.col} 이동 차단 안내 문구 없음` };
  return { result: 'PASS', why: `필수 ${s.col} 이동 차단 · 안내 '${s.msg.slice(0, 60)}'${s.ctl ? ` · 대조군 ${s.ctl} 이동됨` : ' · 대조군 없음'}` };
}

/** Default 버튼 — 대조군을 옮긴 뒤 Default 로 초기 Visible 목록 복원 */
export function judgeDefaultBtn(s: { moved: boolean; before: string[]; after: string[]; ctl: string; ctlDefault?: boolean | null }): J {
  if (!s.moved) return { result: 'ERROR', why: `[측정 경로 없음] 대조군 ${s.ctl} 이동 안 됨` };
  // 2026-11-04 T52 — Default = 메타 DEFAULT_FLAG 기준 배치. 대조군이 DEFAULT_FLAG='N' 이면 Default 뒤 Invisible 이 정답(종전엔 무조건 Visible 기대 → 허위 FAIL)
  if (s.ctlDefault === null) return { result: 'ERROR', why: `[측정 경로 없음] 대조군 ${s.ctl} 의 메타 DEFAULT_FLAG 미확인` };
  const shown = s.after.some(x => norm(x) === norm(s.ctl));
  if (s.ctlDefault === false) return shown ? { result: 'FAIL', why: `Default 뒤 ${s.ctl}(DEFAULT_FLAG=N) 이 Visible 에 남음` } : { result: 'PASS', why: `Default 로 ${s.ctl}(DEFAULT_FLAG=N) Invisible 배치(Visible ${s.before.length}→${s.after.length})` };
  if (!shown) return { result: 'FAIL', why: `Default 뒤 ${s.ctl} 이 Visible 로 안 돌아옴` };
  return { result: 'PASS', why: `Default 로 ${s.ctl} 복원(Visible ${s.before.length}→${s.after.length})` };
}

/** 변경 없이 OK — calls 저장·재조회 요청 수 · closed 팝업 닫힘 */
export function judgeNoChangeOk(s: { calls: number; closed: boolean }): J {
  if (!s.closed) return { result: 'ERROR', why: '[측정 경로 없음] Save 뒤 팝업이 안 닫힘' };
  return s.calls ? { result: 'FAIL', why: `변경 없는데 요청 ${s.calls}건` } : { result: 'PASS', why: '변경 없는 Save — 요청 0·팝업 닫힘' };
}

/** 컬럼을 뺀 뒤 Save — 그리드에서 바로 빠졌는지 */
export function judgeApplied(s: { col: string; before: boolean; after: boolean; restored: boolean | null }): J {
  if (!s.before) return { result: 'ERROR', why: `[측정 경로 없음] Save 전 그리드에 ${s.col} 없음` };
  if (s.after) return { result: 'FAIL', why: `Save 뒤에도 그리드에 ${s.col} 남음` };
  return { result: 'PASS', why: `Save 즉시 그리드에서 ${s.col} 제거 · Default+Save 뒤 그리드 ${s.restored === true ? `${s.col} 다시 표시` : s.restored === false ? `${s.col} 미표시(DEFAULT_FLAG=N 이면 정상 · 개인화 원복은 백업 복원이 담당)` : '미확인'}` };
}
