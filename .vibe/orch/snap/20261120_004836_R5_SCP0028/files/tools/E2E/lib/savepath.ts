// 저장 경로 판정(2026-10-31 엔진 갭 E05 · EG188 실패 메시지 · EG303 취소 · EG308 저장 중 로딩 · EG194/EG200 붙여넣기) — 서버로 보내지 않는 가짜 응답으로 잰다(DB 무변경)
//   판정은 순수 함수로 두어 savepath.selftest.js 로 FAIL 검출을 입증한다
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };

/** 서버가 저장 실패를 돌려줬을 때 — 성공 문구 금지 · 실패를 알리는 문구 필수 */
export function judgeSaveFail(calls: number, msg: string): J {
  if (calls <= 0) return { result: 'ERROR', why: `[측정 경로 없음] 저장 요청 전에 막힘 · 메시지 '${msg.slice(0, 80)}'` };
  if (/성공|success|저장되었/i.test(msg)) return { result: 'FAIL', why: `서버 실패 응답인데 성공 문구 '${msg.slice(0, 80)}'` };
  if (!msg.trim()) return { result: 'FAIL', why: '서버 실패 응답인데 화면 메시지 없음' };
  return { result: 'PASS', why: `실패 문구 표시 '${msg.slice(0, 80)}'` };
}

/** 확인창에서 취소한 뒤 나간 저장 요청 수 */
export function judgeCancel(state: { dialogHasCancel: boolean; otherAlert: string; delta: number; asisConfirm: string }): J {
  if (state.dialogHasCancel) return state.delta === 0 ? { result: 'PASS', why: '확인창 취소 → 저장 요청 0' } : { result: 'FAIL', why: `확인창 취소인데 저장 요청 ${state.delta}건` };
  if (state.delta > 0) return state.asisConfirm ? { result: 'FAIL', why: `확인창 없이 저장 요청 · AS-IS 확인 ${state.asisConfirm}` } : { result: 'NA', why: '확인창 없음 · AS-IS 저장 경로에도 확인 코드 없음' };
  if (state.otherAlert) return { result: 'ERROR', why: `[측정 경로 없음] 취소 버튼 없는 알림 '${state.otherAlert.slice(0, 80)}'` };
  return { result: 'ERROR', why: '[사유 불명] 확인창도 저장 요청도 없음' };
}

/** 저장 요청 지연 구간의 로딩 표시 */
export function judgeSpinner(state: { baseline: boolean; calls: number; seen: number; stillAfter: boolean; control?: number }): J {
  if (state.baseline) return { result: 'ERROR', why: '[측정 불가] 저장 전부터 로딩 표시가 보임' };
  if (state.calls <= 0) return { result: 'ERROR', why: '[측정 경로 없음] 저장 요청이 나가지 않음' };
  // 대조군: 같은 선택자가 조회 지연 때 잡히지 않으면 선택자가 이 화면의 로딩 표시를 못 잡는 것일 수 있다 — FAIL 근거 없음
  if (!state.seen) return state.control === 0 ? { result: 'ERROR', why: '[대조군 실패] 조회 지연 때도 로딩 표시를 못 잡음 — 저장 중 로딩 판정 불가' } : { result: 'FAIL', why: `저장 요청 1.5초 지연 동안 로딩 표시 0회${state.control ? ` · 대조군 조회 지연 때는 ${state.control}회 관측` : ''}` };
  if (state.stillAfter) return { result: 'FAIL', why: '저장 응답 뒤에도 로딩 표시가 남음' };
  return { result: 'PASS', why: `로딩 표시 ${state.seen}회 관측 · 응답 뒤 소멸` };
}

/** 붙여넣은 값이 변경으로 인식돼 저장 요청이 나가는가 */
export function judgePaste(state: { pasted: boolean; calls: number; kind: string; msg: string; want: string; bodyHas: boolean | null }): J {
  if (!state.pasted) return { result: 'ERROR', why: `[입력 경로 실패] 붙여넣기 값이 셀에 안 들어감(기대 '${state.want}')` };
  if (state.calls > 0) return state.bodyHas === false ? { result: 'FAIL', why: `저장 요청 본문에 붙여넣은 값 '${state.want}' 없음` } : { result: 'PASS', why: `붙여넣기 → 저장 요청 ${state.calls}건${state.bodyHas ? ' · 본문에 값 있음' : ' · 본문 길어 값 미대조'}` };
  if (state.kind === 'NOCHANGE') return { result: 'FAIL', why: `붙여넣기가 변경으로 인식 안 됨 · 메시지 '${state.msg.slice(0, 80)}'` };
  return { result: 'ERROR', why: `[${state.kind === 'VALIDATION' ? '업무 검증 차단' : '사유 불명'}] 저장 요청 없음 · 메시지 '${state.msg.slice(0, 80)}'` };
}
