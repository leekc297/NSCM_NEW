// 정렬·필터 상태 Insert · 붙여넣기 후보 외 값 판정(2026-11-02 엔진 갭 EG100·EG139·EG388·EG201). 순수 함수 — rowstate.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** Insert 전 조건 state 정렬|필터 · 뒤 상태 유지 여부 · 신규행 생겼는지 · 편집 가능 칸 수 */
export function judgeInsertInState(s: { state: string; kept: boolean; newRow: boolean; editable: number; why?: string; guard?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  // 2026-11-10 T197: AS-IS Insert 가 전제 guard(편집 잠금 해제·활성 시트·최신 Plan 등) 안에서만 행을 만들면 신규 행 없음 = 전제 미충족 측정 실패(FAIL 아님)
  if (!s.newRow) return s.guard ? { result: 'ERROR', why: `[측정 경로 없음] ${s.state} 상태에서 Insert 뒤 신규 행 없음 — AS-IS Insert 전제(${s.guard}) 미충족 가능` } : { result: 'FAIL', why: `${s.state} 상태에서 Insert 뒤 신규 행 없음` };
  if (!s.editable) return { result: 'FAIL', why: `${s.state} 상태 Insert 행 편집 가능 칸 0` };
  if (!s.kept) return { result: 'FAIL', why: `Insert 뒤 ${s.state} 상태가 풀림` };
  return { result: 'PASS', why: `${s.state} 유지 · Insert 행 편집 가능 칸 ${s.editable}` };
}

/** 콤보 칸에 후보 밖 값을 붙여넣은 뒤 — before 전 값 · after 뒤 값 · bad 넣은 값 */
export function judgePasteBad(s: { b: string; bad: string; before: string; after: string; pasted: boolean; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.pasted) return { result: 'ERROR', why: `[측정 경로 없음] 클립보드 붙여넣기를 실행하지 못함` };
  if (s.after === s.bad) return { result: 'FAIL', why: `${s.b} 후보 밖 값 '${s.bad}' 이 그대로 들어감` };
  return { result: 'PASS', why: `${s.b} 후보 밖 값 거부 — '${s.before}' → '${s.after}'` };
}

/** 텍스트 조건 부분 문자열 조회 — full 원래 값 · part 입력 · vals 결과 칸 값 · sent 요청 여부 · inBody 부분 문자열이 조회 요청 본문에 실렸는지.
 *  기대 = 요건 EG245(문서 DM-181·GAP-75·GAP-419·SSP45-6 — 텍스트 조건 부분일치). AS-IS SP 가 정확 일치(IN)여도 TO-BE 요건이 우선한다.
 *  0행: 본문에 부분 문자열이 실렸으면 FAIL(조건은 전달됐는데 부분일치 안 됨) · 안 실렸거나 모르면 입력 조작 실패일 수 있어 ERROR
 *  (2026-11-10 T177 — SSP0024 Material 'PCAN0506' 0행이 'AS-IS Like 여부 확인 필요' ERROR 로 미검증에 묻혀 조치필요 누락 · 사용자 판정 오류) */
export function judgeLike(s: { b: string; full: string; part: string; vals: string[]; sent: boolean; inBody?: boolean }): J {
  const ci = (v: string) => v.toLowerCase();
  if (!s.sent) return { result: 'ERROR', why: `[측정 경로 없음] 조회 요청 없음` };
  if (!s.vals.length) return s.inBody
    ? { result: 'FAIL', why: `'${s.part}'(값 '${s.full}' 일부) 이 조회 요청 본문에 실렸는데 0행 — 텍스트 조건 부분일치(Like) 안 됨 · 기대 근거 요건 EG245(DM-181·GAP-75·GAP-419·SSP45-6)` }
    : { result: 'ERROR', why: `[확인 대상] '${s.part}'(값 '${s.full}' 일부) 조회 0행 · 조회 요청 본문에 부분 문자열 ${s.inBody === false ? '없음' : '확인 안 함'} — 입력 조작 실패일 수 있어 판정 보류` };
  const out = [...new Set(s.vals.filter(v => !ci(v).includes(ci(s.part))))];
  if (!s.vals.some(v => ci(v) === ci(s.full))) return { result: 'FAIL', why: `'${s.part}' 조회 ${s.vals.length}행에 원래 값 '${s.full}' 없음` };
  if (out.length) return { result: 'ERROR', why: `[확인 대상] '${s.part}' 조회 ${s.vals.length}행 중 ${s.b} 에 그 문자열 없는 값 ${out.length}종: ${out.slice(0, 4).join(', ')}(ID·명칭 등 다른 칸 검색일 수 있음)` };
  return { result: 'PASS', why: `'${s.part}' 부분일치 ${s.vals.length}행 · 원래 값 포함` };
}

/** 선택 조회 — want 고른 값 · vals 결과 칸 값 · 복수면 고른 값이 전부 결과에 있어야 한다 */
export function judgeSelected(s: { name: string; want: string[]; vals: string[]; sent: boolean }): J {
  if (!s.sent) return { result: 'ERROR', why: `[측정 경로 없음] ${s.name} 조회 요청 없음` };
  if (!s.vals.length) return { result: 'FAIL', why: `${s.name} '${s.want.join(',')}' 조회 0행 — 기본 조회에 있던 값` };
  const set = new Set(s.want); const out = [...new Set(s.vals.filter(v => !set.has(v)))]; const miss = s.want.filter(w => !s.vals.includes(w));
  if (out.length) return { result: 'FAIL', why: `${s.name} '${s.want.join(',')}' 조회에 조건 밖 값 ${out.length}종: ${out.slice(0, 4).join(', ')}` };
  if (miss.length) return { result: 'FAIL', why: `${s.name} 고른 값 중 결과에 없음: ${miss.join(', ')}` };
  return { result: 'PASS', why: `${s.name} '${s.want.join(',')}' 조회 ${s.vals.length}행 · 조건 밖 0` };
}

/** 전체 → 선택 → 전체 왕복 — n0 처음 행 · n1 선택 뒤 · n2 다시 전체 */
export function judgeAllRound(s: { name: string; n0: number; n1: number; n2: number }): J {
  if (s.n1 >= s.n0) return { result: 'ERROR', why: `[측정 경로 없음] ${s.name} 선택이 행을 줄이지 못함 ${s.n0}→${s.n1}` };
  return s.n2 === s.n0 ? { result: 'PASS', why: `${s.name} 전체 ${s.n0}→선택 ${s.n1}→전체 ${s.n2}` } : { result: 'FAIL', why: `${s.name} 다시 전체 선택 뒤 ${s.n2}행 — 처음 ${s.n0}행으로 안 돌아옴` };
}

/** 입력칸 값 일부를 선택하고 지운 뒤 — full 원래 값 · want 기대 값 · got 뒤 값 (EG174) */
export function judgeTextDelete(s: { where: string; key: string; full: string; want: string; got: string; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (s.got !== s.want) return { result: 'FAIL', why: `${s.where} 드래그 선택 후 ${s.key} — '${s.full}' → '${s.got}'(기대 '${s.want}')` };
  return { result: 'PASS', why: `${s.where} 선택 부분만 ${s.key} 로 지워짐 '${s.full}' → '${s.got}'` };
}

/** Insert 행 Division 변경 전후 콤보 후보 — divs 시험한 Div 값 · changed 후보가 바뀐 칸 · same 그대로인 칸 (EG108) */
export function judgeDivCands(s: { divEditable: boolean; divs: string[]; changed: string[]; same: string[]; why?: string; asis?: { editable: boolean; by: string } | null }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  // 2026-11-18 SCP0111 V-625fadbe: AS-IS 신규행 Division 편집 기대(edit_expect · 계정 그룹으로 계산)가 있으면 그것과 대조한다 — 둘 다 잠금이면 변경 시나리오 자체가 없음(같음)
  if (!s.divEditable && s.asis) return s.asis.editable ? { result: 'FAIL', why: `Insert 행 Division 칸 편집 불가 ↔ AS-IS 편집 가능(${s.asis.by})` } : { result: 'PASS', why: `Insert 행 Division 칸 편집 불가 = AS-IS 신규행 Division 잠금(${s.asis.by}) — Division 변경 후보 재구성 시나리오 대상 아님` };
  if (!s.divEditable) return { result: 'ERROR', why: `[확인 대상] Insert 행 Division 칸 편집 불가 — AS-IS 편집 여부와 대조 필요(문서는 SCP·SSP 사례)` };
  if (s.divs.length < 2) return { result: 'ERROR', why: `[측정 경로 없음] Division 후보 ${s.divs.length}건 — 변경 시험 불가` };
  if (!s.changed.length) return { result: 'ERROR', why: `[확인 대상] Div ${s.divs.join('→')} 변경 뒤 콤보 칸 ${s.same.length}개 후보 변화 없음(${s.same.slice(0, 5).join(',')}) — 하위 후보 재구성 여부 확인` };
  return { result: 'PASS', why: `Div ${s.divs.join('→')} 변경 뒤 후보 재구성 ${s.changed.slice(0, 5).join(',')} · 변화 없는 칸 ${s.same.length}개` };
}

/** 콤보 칸에 표시 이름을 붙여넣은 뒤 — raw 저장 값 · disp 표시값 · 이름이 곧 코드인 칸은 keyEqName (EG405) */
export function judgePasteCode(s: { b: string; good: string; raw: string; disp: string; keyEqName: boolean }): J {
  if (s.disp.trim() !== s.good.trim()) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 붙여넣기 미반영('${s.good}' → '${s.disp}')` };
  if (!s.raw.trim()) return { result: 'FAIL', why: `${s.b} 이름 '${s.good}' 붙여넣기 뒤 코드 값 비어 있음` };
  if (s.raw.trim() === s.good.trim() && !s.keyEqName) return { result: 'FAIL', why: `${s.b} 이름 '${s.good}' 붙여넣기 뒤 코드 자리에 이름이 그대로 들어감` };
  return { result: 'PASS', why: `${s.b} 이름 '${s.good}' 붙여넣기 → 코드 '${s.raw}' 동반` };
}

/** 수정 저장형 화면 필수 칸을 비우고 Save — posts Save 로 나간 저장 요청(시험이 전부 차단) · msg 안내 (E3) */
export function judgeBlankExisting(s: { b: string; cleared: boolean; posts: number; msg: string; v0: string; crud?: string }): J {
  if (!s.cleared) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 값 '${s.v0}' 을 비우지 못함` };
  // '수정 없음' 안내면 빈 값이 수정으로 잡히지 않은 것 — 필수 차단을 잰 게 아니다(2026-11-02 허위 PASS)
  if (/수정한 내용|변경.*없|no change|nothing to save/i.test(s.msg) || (s.crud !== undefined && !/^(U|M)$/.test(s.crud))) return { result: 'ERROR', why: `[측정 경로 없음] ${s.b} 빈 값이 수정으로 잡히지 않음(상태 '${s.crud ?? ''}' · 안내 '${s.msg}')` };
  if (s.posts > 0) return { result: 'FAIL', why: `${s.b} 필수 칸을 비웠는데 저장 요청이 나감(${s.posts}건 · 시험이 차단)${s.msg ? ` · 안내 '${s.msg}'` : ''}` };
  if (!s.msg) return { result: 'ERROR', why: `[확인 대상] ${s.b} 빈 값 Save — 저장 요청·안내 모두 없음` };
  // 2026-11-20 T374: 저장 실패·검증 불가 알림은 필수 칸 차단 안내가 아니다(시험이 막은 검증 호출의 실패 알림 · SSP0014 USER_CHECK)
  if (/(fail|실패|unavailable|오류|error|exception)/i.test(s.msg) && !/(필수|required|mandatory)/i.test(s.msg)) return { result: 'ERROR', why: `[확인 대상] ${s.b} 빈 값 Save — 저장 요청 없음 · 안내가 필수 안내가 아닌 실패 알림 '${s.msg}'` };
  return { result: 'PASS', why: `${s.b} 빈 값 Save 차단 · 안내 '${s.msg}'` };
}

/** Insert 행 Division — cond 조회조건 표시값 · cell 신규 행 표시값 · newAfter 조건 Div 변경 뒤 남은 신규 행 수 (EG128·EG028) */
export function judgeInsertDiv(s: { cond: string; cell: string; changed: boolean; newAfter: number; asisClears?: boolean; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  const c = s.cond.trim(), v = s.cell.trim();
  if (!c) return { result: 'ERROR', why: '[측정 경로 없음] 조회조건 Division 값을 못 읽음' };
  if (v && c && !c.startsWith(v) && !v.startsWith(c)) return { result: 'FAIL', why: `Insert 행 Division '${v}' ≠ 조회조건 '${c}'` };
  if (!s.changed) return { result: 'ERROR', why: `[측정 경로 없음] 조회조건 Division 변경 못 함 — 신규 행 '${v}' 만 대조` };
  // 초기화 기대는 AS-IS 근거가 있을 때만 — 문서 사례는 DMF0004 · SCP0007 은 초기화 문장 없음(2026-11-02 허위 FAIL)
  if (s.newAfter > 0 && s.asisClears) return { result: 'FAIL', why: `조회조건 Division 변경 뒤 미저장 신규 행 ${s.newAfter}개 잔존 — AS-IS 는 변경 핸들러에서 그리드 초기화` };
  if (s.newAfter > 0) return { result: 'PASS', why: `Insert 행 Division '${v || '(빈 값)'}' = 조건 '${c}' · Division 변경 뒤 신규 행 ${s.newAfter}개 유지(AS-IS 초기화 문장 없음)` };
  return { result: 'PASS', why: `Insert 행 Division '${v || '(빈 값)'}' = 조건 '${c}' · Division 변경 뒤 신규 행 0` };
}
