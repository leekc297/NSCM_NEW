// 병합 셀 입력·붙여넣기·Delete 범위·입력 중 병합 해제·계층 병합·원값 복원 판정(2026-11-02 엔진 갭 EG099·EG203·EG215·EG317·EG314·EG318·EG219). 순수 함수 — mergecheck.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };
const norm = (v: string) => String(v ?? '').replace(/,/g, '').trim();

/** 앞 병합 컬럼이 합쳐진 두 행에서 뒤 병합 컬럼이 같은 값인데 안 합쳐진 건수 — checked 대조한 행 쌍 · bad 위반 예시 */
export function judgeHierMerge(s: { checked: number; bad: string[] }): J {
  if (!s.checked) return { result: 'NA', why: '병합된 행 쌍 없음 — 현재 조회 결과로 계층 병합 재현 불가' };
  if (s.bad.length) return { result: 'FAIL', why: `행 쌍 ${s.checked}건 중 중간 미병합 ${s.bad.length}건: ${s.bad.slice(0, 3).join(' / ')}` };
  return { result: 'PASS', why: `병합 행 쌍 ${s.checked}건 · 중간 미병합 0` };
}

/** 병합 칸에 입력·붙여넣기한 뒤 — opened 입력 수단 실행 여부 · want 넣은 값 · after 뒤 표시값 · span0/span1 전후 병합 행 수 */
export function judgeMergeInput(s: { how: string; b: string; opened: boolean; want: string; before: string; after: string; span0: number; span1: number; ctrlOk?: boolean; ctrlName?: string; note?: string; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (s.span0 <= 1) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 병합 범위가 아님(행 ${s.span0})` };
  if (!s.opened) return { result: 'FAIL', why: `${s.b} 병합 칸(${s.span0}행) ${s.how} 불가 — 편집기가 열리지 않음` };
  // 대조군 — 편집기로 직접 넣어도 안 들어가면 그 칸이 값을 거부하는 것이라 입력 경로 결함으로 단정 못 함(T29)
  if (norm(s.after) !== norm(s.want)) return s.ctrlOk ? { result: 'FAIL', why: `${s.b} 병합 칸 ${s.how} 값 미반영 — '${s.before}' → '${s.after}'(넣은 값 '${s.want}') · ${s.ctrlName || '대조군'} 은 반영됨${s.note ? ` · ${s.note}` : ''}` } : { result: 'ERROR', why: `[확인 대상] ${s.b} 병합 칸 ${s.how} 값 미반영이나 ${s.ctrlName || '대조군'} 도 안 들어감 — 값 거부·경로 문제인지 확인('${s.before}' → 넣은 값 '${s.want}')${s.note ? ` · ${s.note}` : ''}` };
  if (s.span1 < s.span0) return { result: 'FAIL', why: `${s.b} 병합 칸 ${s.how} 뒤 병합 풀림 — ${s.span0}행 → ${s.span1}행` };
  return { result: 'PASS', why: `${s.b} 병합 ${s.span0}행 유지 · ${s.how} 값 '${s.after}' 반영` };
}

/** 병합 칸 선택 후 Delete — cruds 범위 안 행 상태 · outD 범위 밖 D 수 · posts Delete 클릭만으로 나간 서버 요청 · toggled 값이 바뀐 행 수(토글형) */
/** AS-IS 화면 소스에서 BaseForm 버튼 메서드를 본문 없이 재정의한 위치(줄 번호 · 없으면 0) — menu_auth_sync.empty_overrides 와 같은 기준(주석·공백만 = 빈 본문) */
export function emptyOverrideLine(src: string, method: string): number {
  const m = new RegExp(`override\\s+void\\s+${method}\\s*\\(\\s*\\)\\s*\\{((?:\\s|//[^\\n]*\\n)*)\\}`).exec(String(src ?? ''));
  return m ? String(src).slice(0, m.index).split('\n').length : 0;
}

export function judgeMergeDelete(s: { b: string; cruds: string[]; outD: number; posts: number; toggled?: number; keys?: string[]; alert?: string; asisNoDelete?: string; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  const d = s.cruds.filter(c => c === 'D').length, n = s.cruds.length;
  if (s.posts) return { result: 'ERROR', why: `[확인 대상] Delete 클릭만으로 서버 요청 ${s.posts}건 — 시험이 차단함(즉시 삭제 화면인지 확인)` };
  if (!d && s.toggled && s.toggled === n) return { result: 'PASS', why: `${s.b} 병합 ${n}행 전부 값 토글(${(s.keys || []).join(',')}) — D 표시 없는 토글형 Delete(CR-057)` };
  if (!d && s.toggled) return { result: 'FAIL', why: `${s.b} 병합 ${n}행 중 ${s.toggled}행만 값 토글(${(s.keys || []).join(',')})` };
  // 2026-11-19 T341(SCP0111 V-23d0a714): AS-IS Delete 버튼 본문이 비어 있으면(기존 행 삭제 기능 없음) TO-BE 가 기존 행 Delete 를 알림으로 막는 것은
  //   AS-IS 와 같은 동작이다 — 병합 범위 D 표시 판정 대상 아님(원문 근거 NA). 알림 없이 무반응이면 그대로 확인 대상
  if (!d && s.asisNoDelete && s.alert) return { result: 'NA', why: `${s.b} 병합 ${n}행 Delete 뒤 D 표시 0 · 알림 '${s.alert}' · AS-IS 기존 행 삭제 기능 없음(${s.asisNoDelete} 본문 없음) — 병합 범위 D 표시 대상 아님` };
  if (!d) return { result: 'ERROR', why: `[확인 대상] ${s.b} 병합 ${n}행 Delete 뒤 D 표시 0${s.alert ? ` · 알림 '${s.alert}'` : ''} — 토글형·차단 여부 확인` };
  if (d < n) return { result: 'FAIL', why: `${s.b} 병합 ${n}행 중 D 표시 ${d}행 — 병합 전체 행이 D 여야 함` };
  if (s.outD) return { result: 'FAIL', why: `${s.b} 병합 범위 밖 ${s.outD}행까지 D 표시` };
  return { result: 'PASS', why: `${s.b} 병합 ${n}행 전부 D · 범위 밖 0 (저장 없음 — 서버 삭제 응답 시간은 미측정)` };
}

/** 신규 행에 옆 행과 같은 값을 넣은 뒤 — span 신규 행 병합 행 수 · same 실제로 같은 값이 됐는지 */
export function judgeNewRowMerge(s: { b: string; same: boolean; span: number; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.same) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 신규 행에 옆 행과 같은 값을 넣지 못함` };
  if (s.span > 1) return { result: 'FAIL', why: `${s.b} 입력 중 신규 행이 기존 데이터와 병합됨(${s.span}행)` };
  return { result: 'PASS', why: `${s.b} 옆 행과 같은 값이어도 입력 중 행은 병합 안 됨` };
}

/** 값 수정 뒤 원값 복원 — crud1 수정 뒤 상태 · crud2 복원 뒤 상태 */
export function judgeRestore(s: { b: string; v0: string; v1: string; v2: string; crud1: string; crud2: string; diff?: string[]; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (norm(s.v1) === norm(s.v0)) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 값 변경이 안 됨('${s.v0}')` };
  if (norm(s.v2) !== norm(s.v0)) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 원값 복원이 안 됨('${s.v0}' → '${s.v2}')` };
  if (!/^(U|M)$/.test(s.crud1)) return { result: 'ERROR', why: `[확인 대상] ${s.b} 수정 뒤 상태 '${s.crud1}' — 수정 표시가 없어 해제를 판정 못 함` };
  // 표시값은 같아도 코드 값이 다르면 복원이 아니다 — 수정 표시가 남는 게 맞다
  if (s.crud2 && s.diff && s.diff.length) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 표시값은 복원됐으나 데이터가 다름: ${s.diff.slice(0, 4).join(', ')} — 복원 경로 확인` };
  if (s.crud2) return { result: 'FAIL', why: `${s.b} 원값 복원 뒤에도 상태 '${s.crud2}' — 수정 표시 해제 안 됨(데이터 전 칸 원값과 같음)` };
  return { result: 'PASS', why: `${s.b} 수정 '${s.crud1}' → 원값 복원 뒤 상태 해제` };
}
