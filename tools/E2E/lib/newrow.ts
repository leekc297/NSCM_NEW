// 신규행 저장 전 검증 판정(2026-10-31 엔진 갭 E05 · EG158 컬럼별 필수 공란 · EG162 키 중복) — 저장 요청은 가짜 응답으로 끊어 DB 무변경
//   판정은 순수 함수로 두어 newrow.selftest.js 로 FAIL 검출을 입증한다
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** 필수 컬럼 하나만 비우고 Save — 저장 요청이 나가면 안 되고 문구가 있어야 한다 */
export function judgeRequired(s: { calls: number; msg: string; label: string; col: string; fillFails: string[]; control: 'sent' | 'dup' | 'blocked' | 'none'; otherCol?: string }): J {
  const m = s.msg.trim(); const named = !!m && ((!!s.label && m.includes(s.label)) || m.includes(s.col));
  if (s.calls > 0) {
    // 다른 칸을 못 채웠는데도 요청이 나갔다면 그 칸의 공란까지 통과한 것 — 이 컬럼 공란이 원인임은 그대로 입증된다
    return { result: 'FAIL', why: `필수 '${s.label || s.col}' 공란인데 저장 요청 ${s.calls}건` };
  }
  if (!m) return { result: 'FAIL', why: `필수 '${s.label || s.col}' 공란 저장 — 요청은 없으나 안내 문구 없음` };
  if (named) return { result: 'PASS', why: `차단 · 문구에 컬럼명 있음 '${m.slice(0, 80)}'` };
  // 문구가 다른 컬럼을 가리키면 비운 컬럼의 증거가 아니다(허위 PASS 방지 · 2026-11-01 DMF0004)
  if (s.otherCol) return { result: 'ERROR', why: `[다른 컬럼이 차단] ${s.otherCol} 문구 '${m.slice(0, 80)}' — ${s.col} 공란 효과 측정 불가` };
  // 문구가 다른 칸을 가리키면 이 컬럼이 원인이라는 근거가 없다
  if (s.fillFails.length) return { result: 'ERROR', why: `[입력 경로 실패] ${s.fillFails.slice(0, 4).join(',')} 입력 실패 · 문구 '${m.slice(0, 80)}' — 이 컬럼이 차단 원인인지 판정 불가` };
  if (s.control === 'blocked') return { result: 'ERROR', why: `[대조군 실패] 전 칸을 채워도 저장이 막힘 · 문구 '${m.slice(0, 80)}' — 이 컬럼 공란이 원인인지 판정 불가` };
  return { result: 'PASS', why: `차단 · 문구에 컬럼명 없음 '${m.slice(0, 80)}'` };
}

/** 기존 행을 그대로 복사한 신규 행 Save — 키 중복이므로 저장 전 차단이 기대값. 요청이 나가면 서버 검증 실측 전까지 판정 불가 */
export function judgeDup(s: { calls: number; msg: string; fillFails: string[]; asisDup: string }): J {
  const m = s.msg.trim();
  if (s.fillFails.length && !s.calls) return { result: 'ERROR', why: `[입력 경로 실패] ${s.fillFails.slice(0, 4).join(',')} 입력 실패 — 같은 키를 만들지 못함 · 문구 '${m.slice(0, 80)}'` };
  if (s.calls > 0 && s.fillFails.length) return { result: 'ERROR', why: `[입력 경로 실패] ${s.fillFails.slice(0, 4).join(',')} 입력 실패 — 같은 키 재현 아님` };
  if (s.calls > 0) return s.asisDup ? { result: 'FAIL', why: `같은 키 신규 행인데 저장 요청 · AS-IS 저장 전 중복 검증 ${s.asisDup}` } : { result: 'ERROR', why: '[서버 검증 미측정] 저장 전 차단 없음 · AS-IS 화면 코드에도 없음 — 서버 차단은 실저장 측정 필요' };
  if (!m) return { result: 'FAIL', why: '같은 키 신규 행 — 요청은 없으나 안내 문구 없음' };
  if (/중복|duplicate|already|이미|존재/i.test(m)) return { result: 'PASS', why: `저장 전 차단 '${m.slice(0, 80)}'` };
  return { result: 'ERROR', why: `[차단 사유 확인 필요] 중복 문구가 아님 '${m.slice(0, 80)}'` };
}

/** AS-IS Insert 진입점에 실제 동작 문장이 없으면(빈 구현) TO-BE 무동작이 정상 — 신규 행 없음을 FAIL 로 내면 허위(2026-11-01 SCP0028 InsertRow 빈 구현) */
export function asisInsertNoop(acts: Record<string, string>[], ents: Record<string, string>[]): { noop: boolean; ref: string } {
  const ms = new Set(ents.filter(z => /insert/i.test(z.entry || '')).map(z => z.method)); if (!ms.size) return { noop: true, ref: 'AS-IS Insert 진입점 없음' };
  const body = acts.filter(z => ms.has(z.method) && !['CALL_LOCAL', 'RETURN', 'BRANCH', 'LOCAL'].includes(z.kind));
  return { noop: body.length === 0, ref: body.length ? `${body[0].method}:${body[0].line}` : `AS-IS ${[...ms].join(',')} 실행 문장 0` };
}
