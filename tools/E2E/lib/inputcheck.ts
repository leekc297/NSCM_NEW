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

/** 2026-11-19 SCP0096 F6 빈값 저장 미검증('7'→'' 키보드 Delete·편집기 둘 다 '7' 유지 · 같은 증상 SCP0037·SCP0122·SCP0127):
 *  AS-IS 화면 원문에서 그 칸 값을 읽은 변수가 빈값이면 기본값으로 바뀌는 곳(빈값 = 그 값으로 저장)을 찾는다.
 *  예) string w = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.WORKING_TIME_DEFAULT)).ToString(); if (string.IsNullOrEmpty(w)) w = "0";
 *  반환 {line(1부터), lit} · 없으면 null */
export function asisBlankDefault(src: string, binding: string): { line: number; lit: string } | null {
  const lines = src.split(/\r?\n/); const esc = binding.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const colRe = new RegExp(`(?:[.]${esc}\\b|"${esc}")`);
  for (let i = 0; i < lines.length; i++) {
    const m = /\b(?:string|var)\s+(\w+)\s*=\s*(.*)$/.exec(lines[i]); if (!m || !colRe.test(m[2]) || !/Get(Value|Text)\s*\(/.test(m[2])) continue;
    const v = m[1].replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    for (let k = i; k < Math.min(lines.length, i + 4); k++) {
      const d = new RegExp(`IsNullOrEmpty\\s*\\(\\s*${v}\\s*\\)\\s*\\)\\s*\\{?\\s*${v}\\s*=\\s*"([^"]*)"`).exec(lines[k]); if (d) return { line: k + 1, lit: d[1] };
    }
  }
  return null;
}

/** 빈값 입력이 그리드에서 거부됨(입력 경로 실패 뒤 칸 설정 실측), AS-IS 같은 칸 저장 검증이 있으면 PASS(양쪽 빈값 불가) · AS-IS 가 빈값을 기본값으로 저장하면 FAIL · 근거 없으면 ERROR
 *  rejected = 키보드 Delete 와 편집기 '' 주입 모두 원값 유지 · req = Wijmo 칸 isRequired 값('null'·'true'·'false') · dataType 2 = 숫자 */
export function judgeBlankReject(s: { rejected: boolean; req: string; dataType: string; orig: string; asisGuard: string; asisDefault: string; pathOk?: string }): J {
  if (!s.rejected) return { result: 'ERROR', why: '[입력 경로 실패] 빈값 거부 여부 미확인' };
  const gridReq = s.req === 'true' || (s.req === 'null' && s.dataType !== '1');
  // 2026-11-19 라운드 5(SCP0096 isRequired=false 인데 빈값 거부): 같은 칸에 같은 키보드 경로로 다른 값이 들어갔으면 입력 경로는 정상, 빈값만 화면이 받지 않음(실측)
  if (!gridReq && !s.pathOk) return { result: 'ERROR', why: `[입력 경로 실패] 빈값이 안 들어감 · 칸 설정 isRequired=${s.req} · 거부 원인 미확인` };
  const base = `TO-BE 화면이 이 칸 빈값 입력을 받지 않음(isRequired=${s.req} · dataType=${s.dataType} · Delete·편집기 모두 '${s.orig}' 유지${s.pathOk ? ` · 같은 칸 같은 입력 경로 ${s.pathOk}` : ''})`;
  if (s.asisGuard) return { result: 'PASS', why: `${base} · AS-IS 같은 칸 저장 검증 ${s.asisGuard}(양쪽 빈값 저장 불가)` };
  if (s.asisDefault) return { result: 'FAIL', why: `${base} · AS-IS 는 빈값을 지울 수 있고 저장 때 ${s.asisDefault}` };
  return { result: 'ERROR', why: `${base} · [AS-IS 빈값 처리 근거 없음]` };
}
