// Excel 양식·업로드 판정(2026-11-01 엔진 갭 EG420 양식 즉시 다운로드 · EG421 잘못된 파일 업로드 차단). 순수 함수 — excelcheck.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };
export type Sheet = { name: string; rows: number; cols: number; header: string[] };

/** 양식 버튼 → 팝업 없이 파일 · 머리글 있음 */
export function judgeForm(s: { button: boolean; asisHas: string; download: boolean; dialog: string; bytes: number; sheets: Sheet[]; parseErr: string }): J {
  if (!s.button) return s.asisHas ? { result: 'FAIL', why: `Excel Form 버튼 없음 · AS-IS ${s.asisHas}` } : { result: 'NA', why: 'Excel Form 버튼 없음 · AS-IS 진입점에도 없음' };
  if (!s.download) return s.dialog ? { result: 'ERROR', why: `[측정 경로 없음] 다운로드 없이 대화상자 '${s.dialog.slice(0, 80)}' — 입력 후 받는 화면일 수 있음` } : { result: 'FAIL', why: '버튼을 눌러도 파일이 내려오지 않음(60초)' };
  if (s.bytes <= 0) return { result: 'FAIL', why: '내려받은 파일 0바이트' };
  if (s.parseErr) return { result: 'FAIL', why: `xlsx 로 열리지 않음: ${s.parseErr.slice(0, 80)}` };
  const main = s.sheets.find(x => x.cols > 0); if (!main) return { result: 'FAIL', why: `시트 ${s.sheets.length}개 모두 빈 시트 — 머리글 없음` };
  return { result: 'PASS', why: `파일 ${s.bytes}바이트 · 시트 '${main.name}' 머리글 ${main.cols}칸 · 데이터 ${Math.max(main.rows - 1, 0)}행 · 앞 칸 ${main.header.slice(0, 4).join(',')}${s.dialog ? ` · 대화상자 '${s.dialog.slice(0, 40)}'` : ''}` };
}

/** 머리글이 틀린 파일 업로드 → 저장 요청 없이 안내. 저장 요청 전 차단이 기대값 */
export function judgeBadUpload(s: { button: boolean; fileInput: boolean; calls: number; msg: string }): J {
  if (!s.button) return { result: 'NA', why: 'Excel Upload 버튼 없음' };
  if (!s.fileInput) return { result: 'ERROR', why: '[측정 경로 없음] 업로드 버튼을 눌러도 파일 입력을 찾지 못함' };
  if (s.calls > 0) return { result: 'FAIL', why: `머리글 틀린 파일인데 저장 요청 ${s.calls}건 · 문구 '${s.msg.slice(0, 60)}'` };
  const flat = s.msg.replace(/\s+/g, ' ').trim(); const head = flat.replace(/Upload Result[\s\S]*/i, ''); /* 업로드 창의 'Upload Result Success Error Total' 은 고정 머리글 — 성공 문구가 아니다(2026-11-02 허위 FAIL) */
  if (/성공|success|저장되었/i.test(head)) return { result: 'FAIL', why: `머리글 틀린 파일인데 성공 문구 '${flat.slice(0, 200)}'` };
  if (!s.msg.trim()) return { result: 'FAIL', why: '머리글 틀린 파일 — 요청은 없으나 안내 문구 없음' };
  if (/Upload Result/i.test(flat) && !/error\s*excel|invalid|오류|없습니다|header title/i.test(head)) return { result: 'ERROR', why: `[확인 대상] 머리글 틀린 파일 — 업로드 창만 남고 안내 문구 없음('${head.slice(0, 70)}') · 저장 요청 없음` };
  return { result: 'PASS', why: `차단 · 문구 '${s.msg.slice(0, 80)}'` };
}

/** 필수 칸('*' 머리글)을 비운 파일 업로드 — 저장 요청은 시험이 가로채 서버에 가지 않는다 (EG153) */
// 2026-11-25 T601(SCP0005 E3 V-087d756b): rows = 업로드 응답 행 상태(m1upload.uploadStatuses) + AS-IS 기대 상태(필수 검사 문구와 그 뒤 덮어쓰는 문구 · m1upload.overwriteChain).
//   AS-IS ExcelUploadForm2 는 필수 칸이 비면 팝업 없이 결과 그리드 행 상태로 알린다(Validation_Check_<ID>) · 같은 파일의 다른 칸 값('E2E')이 뒤 검사(요일·숫자)에서 상태를 덮는다 → 그 문구도 AS-IS 기대 상태.
export function judgeBlankUpload(s: { hasForm: boolean; button: boolean; req: string[]; fileInput: boolean; calls: number; msg: string; rows?: { statuses: string[]; total: number | null; ok: number | null; err: number | null; allowed: string[]; ref: string } }): J {
  if (!s.button) return { result: 'NA', why: 'Excel Upload 버튼 없음' };
  if (!s.hasForm) return { result: 'ERROR', why: '[측정 경로 없음] 양식을 못 받아 필수 칸 비운 파일을 못 만듦' };
  if (!s.req.length) return { result: 'NA', why: "양식 머리글에 '*' 필수 표시 없음" };
  if (!s.fileInput) return { result: 'ERROR', why: '[측정 경로 없음] 업로드 버튼을 눌러도 파일 입력을 찾지 못함' };
  const ora = /ORA-\d{5}[^"/]{0,80}/.exec(s.msg);
  if (ora && !/ORA-20\d{3}[^/]*필수/.test(s.msg)) { const all = s.msg.match(/ORA-\d{5}/g) || []; const pos = /"(?:SCM_MGR\.)?(PKG_\w+)", (\d+)행/.exec(s.msg); return { result: 'FAIL', why: `필수 ${s.req.length}칸 빈 파일에 필수 안내 대신 SQL 오류 — ${[...new Set(all)].join(', ')}${pos ? ` · ${pos[1]} ${pos[2]}행` : ''}` }; }
  const R = s.rows; if (R && R.statuses.length && R.allowed.length && s.calls === 0) {
    const out = R.statuses.filter(x => !R.allowed.includes(x)); const ev = `업로드 결과 행 상태 [${[...new Set(R.statuses)].join(', ')}] · ERROR_COUNT ${R.err ?? '?'} · SUCCESS_COUNT ${R.ok ?? '?'} · TOTAL_COUNT ${R.total ?? '?'} · AS-IS 기대 상태 [${R.allowed.join(', ')}](${R.ref}) · 적재 요청 0건`;
    if (out.length) return { result: 'FAIL', why: `필수 ${s.req.length}칸 빈 파일 — 행 상태 '${out.join(', ')}' 가 AS-IS 기대 상태 밖 · ${ev}` };
    if ((R.ok ?? 0) > 0) return { result: 'FAIL', why: `필수 ${s.req.length}칸 빈 파일인데 성공 행 ${R.ok}건 · ${ev}` };
    if (R.total != null && R.err === R.total && R.total > 0) return { result: 'PASS', why: `필수 ${s.req.length}칸 빈 파일 → 행 상태로 오류 표시·적재 차단 · ${ev} · 화면 문구 '${s.msg.replace(/\s+/g, ' ').trim().slice(0, 80)}'` };
  }
  if (/필수|required|입력.*(하세요|주세요)|mandatory|값은/i.test(s.msg)) return { result: 'PASS', why: `필수 ${s.req.length}칸 빈 파일 차단 · 문구 '${s.msg.slice(0, 80)}'` };
  if (s.calls > 0) return { result: 'ERROR', why: `[확인 대상] 필수 ${s.req.length}칸 빈 파일 저장 호출 ${s.calls}건 · 필수 안내 없음 — 업무 테이블 잔존 확인 · 문구 '${s.msg.replace(/\s+/g, ' ').trim().slice(0, 160)}'` };
  return { result: 'FAIL', why: `필수 ${s.req.length}칸 빈 파일 — 저장 요청도 필수 안내도 없음 · 문구 '${s.msg.replace(/\s+/g, ' ').trim().slice(0, 200)}'` };
}

/** 양식 입력 버킷 ↔ 메인 기간 — buckets YYYYMM[DD] · from·to 메인 기간 숫자 (EG283) */
//   2026-11-10 T206(SSP0023 G5 허위 FAIL '메인 기간 202610~202609'): 종전 호출부가 조회조건의 날짜 입력값 앞 2개를 시작·끝으로 썼다 —
//   Plan Date(단일 날짜 칸)와 Period(시작·끝 2칸)의 시작이 짝지어졌다. 이제 ranges = '날짜 입력 2개를 가진 조회조건 칸'(PeriodField 1칸 = FormItem 1개) 목록.
//   1개면 그 칸 · 여러 개면 버킷이 모두 들어가는 칸이 있으면 그 칸(이름 기록) · 어느 칸에도 안 들어가면 FAIL(전 칸 나열) · 0개면 ERROR.
export function judgeFormBucket(s: { download: boolean; buckets: string[]; from?: string; to?: string; ranges?: { label: string; from: string; to: string }[] }): J {
  if (!s.download) return { result: 'NA', why: '양식 파일 없음' };
  if (!s.buckets.length) return { result: 'NA', why: '양식에 날짜형 버킷 칸 없음' };
  const rg = (s.ranges || (s.from && s.to ? [{ label: '', from: s.from, to: s.to }] : [])).filter(r => r.from && r.to);
  if (!rg.length) return { result: 'ERROR', why: `[측정 경로 없음] 메인 기간(시작·끝 2칸 조회조건)을 못 읽음 · 버킷 ${s.buckets.length}개` };
  if (rg.length > 1) {
    const ymx = (v: string) => v.slice(0, 6); const inside = rg.filter(r => s.buckets.every(x => ymx(x) >= ymx(r.from) && ymx(x) <= ymx(r.to)));
    const bs = [...s.buckets].sort(); const pick = inside.find(r => ymx(bs[0]) === ymx(r.from) || ymx(bs[bs.length - 1]) === ymx(r.to)) || inside[0] || null; /* 양 끝이 맞는 칸 우선 */ const all = rg.map(r => `${r.label || '?'} ${ymx(r.from)}~${ymx(r.to)}`).join(' · ');
    if (!pick) return { result: 'FAIL', why: `양식 버킷 ${s.buckets.length}개(${[...s.buckets].sort()[0]}~${[...s.buckets].sort().slice(-1)[0]})가 화면 기간 조건 ${rg.length}개 어디에도 안 들어감: ${all}` };
    const j = judgeFormBucket({ download: true, buckets: s.buckets, ranges: [pick] }); return { ...j, why: `${j.why} · 기간 조건 ${rg.length}개 중 '${pick.label}' 기준(${all})` };
  }
  s = { ...s, from: rg[0].from, to: rg[0].to };
  if (!s.from || !s.to) return { result: 'ERROR', why: `[측정 경로 없음] 메인 기간을 못 읽음 · 버킷 ${s.buckets.length}개` };
  const ym = (v: string) => v.slice(0, 6); const b = [...s.buckets].sort(); const lo = ym(s.from), hi = ym(s.to);
  const out = b.filter(x => ym(x) < lo || ym(x) > hi);
  if (out.length) return { result: 'FAIL', why: `양식 버킷 ${b.length}개 중 메인 기간 ${lo}~${hi} 밖 ${out.length}개: ${out.slice(0, 4).join(', ')}` };
  if (ym(b[0]) !== lo && ym(b[b.length - 1]) !== hi) return { result: 'ERROR', why: `[확인 대상] 버킷 ${b[0]}~${b[b.length - 1]} 이 메인 기간 ${lo}~${hi} 양 끝과 안 맞음` };
  return { result: 'PASS', why: `양식 버킷 ${b[0]}~${b[b.length - 1]} ${b.length}개 = 메인 기간 ${lo}~${hi} 안` };
}

/** 양식 2단 머리글 — 문서가 2단을 정한 화면만 (EG344) */
export function judgeFormTwoRow(s: { expect: boolean; download: boolean; merged: number; row2: string[] }): J {
  if (!s.expect) return { result: 'NA', why: '문서가 2단 머리글을 정하지 않은 화면' };
  if (!s.download) return { result: 'ERROR', why: '[측정 경로 없음] 양식 파일을 못 받음' };
  if (!s.merged) return { result: 'FAIL', why: `양식에 병합 셀 없음 — 2단(병합) 머리글이어야 함 · 2행 앞칸 ${s.row2.slice(0, 3).join(',')}` };
  return { result: 'PASS', why: `양식 병합 ${s.merged}개 · 2행 앞칸 ${s.row2.slice(0, 3).join(',')}` };
}

/** 업로드 2단계(EG423·EG165) — 오류 있는 파일: 검사 결과에 오류 표시 · OK 눌러도 저장 요청 없음 · 차단 문구 */
export function judgeUploadBlock(s: { fileInput: boolean; validated: boolean; resultText: string; okBtn: boolean; saves: number; msg: string }): J {
  if (!s.fileInput) return { result: 'ERROR', why: '[측정 경로 없음] 파일 입력을 찾지 못함' };
  if (!s.validated) return { result: 'ERROR', why: `[측정 경로 없음] 업로드 검사 응답 없음 · 문구 '${s.msg.slice(0, 120)}'` };
  const sqlErr = /SQLCODE=-?\d+[^·]{0,80}|ORA-(?!20\d{3})\d{5}[^·]{0,80}/.exec(`${s.resultText} ${s.msg}`); if (sqlErr) return { result: 'FAIL', why: `검사 단계 SQL 오류: ${sqlErr[0].slice(0, 200)}` };
  if (!s.okBtn) return { result: 'NA', why: `2단계 저장 버튼 없는 창 — 검사 단계에서 끝남 · 문구 '${s.msg.slice(0, 120)}'` };
  if (s.saves > 0) return { result: 'FAIL', why: `오류 행이 있는데 OK 로 저장 요청 ${s.saves}건 · 문구 '${s.msg.slice(0, 120)}'` };
  if (/오류 행|error row|수정 후 다시|cannot be saved|저장할 수 없/i.test(s.msg)) return { result: 'PASS', why: `오류 행 파일 OK → 저장 요청 0 · 차단 문구 '${s.msg.slice(0, 100)}'` };
  return { result: 'ERROR', why: `[확인 대상] 저장 요청 0 · 차단 문구 없음 · 결과 '${s.resultText.slice(0, 100)}' · 문구 '${s.msg.slice(0, 100)}'` };
}
