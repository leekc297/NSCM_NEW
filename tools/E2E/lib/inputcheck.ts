// 잘못된 입력의 저장 차단 판정(2026-11-01 엔진 갭 E05 · EG145 소수 보존 · EG147 음수 · EG152 없는 날짜 · EG171 붙여넣기 후보 밖 · EG173·EG177 키인 후보 밖)
//   저장 요청은 가짜 응답으로 끊어 DB 무변경. 판정은 순수 함수 — inputcheck.selftest.js 로 FAIL 검출 입증
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** 규칙 밖 값 — 저장 요청 본문에 그 값이 실리면 FAIL. 요청이 없거나(저장 전 차단) 값이 빠졌으면(입력 거부·초기화) PASS */
export function judgeBadInput(s: { typed: boolean; bad: string; shown: string; calls: number; body: string; msg: string; truncated: boolean }): J {
  if (!s.typed) return { result: 'ERROR', why: `[입력 경로 실패] '${s.bad}' 입력 불가` };
  if (s.calls <= 0) return { result: 'PASS', why: `'${s.bad}' 입력 뒤 칸 '${s.shown}' · 저장 요청 없음${s.msg ? ` · 문구 '${s.msg.slice(0, 60)}'` : ''}` };
  if (s.truncated) return { result: 'ERROR', why: `[측정 불가] 저장 요청 본문이 길어 값 대조 불가 · 칸 '${s.shown}'` };
  if (s.body.includes(s.bad)) return { result: 'FAIL', why: `규칙 밖 값 '${s.bad}' 이 저장 요청에 실림 · 칸 '${s.shown}'` };
  return { result: 'PASS', why: `'${s.bad}' 입력 거부 · 칸 '${s.shown}' · 저장 요청 본문에 값 없음` };
}

/** 소수 허용 컬럼 — 소수값이 잘리지 않고 저장 요청에 실려야 한다 */
export function judgeDecimal(s: { typed: boolean; val: string; shown: string; calls: number; body: string; msg: string; truncated: boolean }): J {
  if (!s.typed) return { result: 'ERROR', why: `[입력 경로 실패] '${s.val}' 입력 불가` };
  if (s.calls <= 0) return { result: 'ERROR', why: `[업무 검증 차단] 저장 요청 없음 · 문구 '${s.msg.slice(0, 60)}' · 칸 '${s.shown}'` };
  if (s.truncated) return { result: 'ERROR', why: '[측정 불가] 저장 요청 본문이 길어 값 대조 불가' };
  return s.body.includes(s.val) ? { result: 'PASS', why: `'${s.val}' 저장 요청에 그대로 실림 · 칸 '${s.shown}'` } : { result: 'FAIL', why: `소수 '${s.val}' 입력했는데 저장 요청에 없음(잘림 의심) · 칸 '${s.shown}'` };
}
