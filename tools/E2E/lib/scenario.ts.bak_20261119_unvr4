// 문서 단건 시나리오 판정(2026-11-03 엔진 갭 EG094·EG120·EG150·EG155) — Doc/verify/scenario_expect.csv 한 줄 = 조작 단계 + 기대
//   표 열 user(선택): 'Div=81;DM Planner (W/S)' = 그 시나리오만 users.json 명부의 그 사업부·그룹 계정으로 로그인(끝나면 기본 계정 복귀 · EG083)
//   칸 토큰(type/paste/cell): @DYN = 이번 주 월요일 이후 첫 동적 기간 칸 · @DYNVAL = 그 중 그 행에 값이 있는 첫 칸(GAPSELF-12 값 있는 셀 편집 · EG107) · cell 의 @LAST = 마지막 type/paste 칸
//   단계(;): mockresp:버튼정규식|HTTP상태|응답JSON|문구정규식(데이터 변경 요청을 서버에 보내지 않고 지정 상태·본문으로 응답 → 버튼 클릭·확인창 OK → 화면 알림·토스트가 문구 정규식과 맞으면 PASS · 서버 실패/성공 응답에 대한 화면 표시 판정용 · 원장 무변경) · setcells:칸정규식=값(마지막 type 행 · 없으면 첫 행의 바인딩이 정규식에 맞는 칸 전부를 그리드 API 로 같은 값(빈값 허용)으로 설정 — 한 달 전체 비우기 등 · 바뀐 칸 수 기록 · 0칸이면 측정 실패) · viewport:너비(브라우저 창 너비 변경 · 높이 1080 — 고정 칸 폭이 FHD 가시 폭을 넘어 스크롤 칸이 안 그려지는 화면의 다른 규칙 측정용 · 창 폭 결함 자체는 H12 가 판정) · fiberprops:키,키[|칸@조건칸=정규식](진단 전용 · 판정 없음 — 그리드 호스트에서 React 컴포넌트 props 를 위로 훑어 키를 전부 가진 첫 props 값 기록 + 조건 행 그 칸의 편집 게이트 입력·병합 범위·startEditing 결과 기록) · colvis:칸=Y|N(현재 그리드에 그 바인딩 칸이 보이는지 · 불일치 FAIL · 사업부 전환 뒤 필수 칸 재표시 DM-P60) · copykeys:칸,칸[@조건칸=정규식](조건에 맞는 첫 기존 행의 칸 값들을 신규 행 전부에 그리드 API 로 복사 — 같은 키 신규 세트 · 저장 중복 검증 실측) · popcombo:라벨=옵션정규식(열린 팝업 안 그 라벨 칸 콤보를 열어 옵션 글자가 맞는 첫 항목 선택 · 선택 뒤 표시값 확인) · curprop:새통화@키,키|기준Measure|환산제외Measure|환율표(기준 행 CURRENCY 변경 → 바로 위 같은 키 묶음 행 통화 복사·수정 표시 + 이번 주 월요일 이후 W_ 칸을 AS-IS GetExchangeRate 공식(같은 통화=값·직접·역수 5자리·KRW 경유 · 환율표 DIVISION_ID/YYYYMMDD(월 01일)/CURRENCY/UNIT_CURRENCY/EXCHANGE_PRICE)으로 계산해 대조 · 과거 칸·제외 Measure 불변 · 저장 안 함) · weeksplit:수량[P]@칸=정규식[&칸=정규식][|BUCKET칸](주 W_ 칸 입력 → 같은 주 D_ 묶음(칼럼 순서 · 월 경계 Partial Week = 7일 미만 · P = Partial 필수) 배분을 AS-IS 규칙(행 요일 플래그 · 빈값 0000010 · 플래그 요일 없음 → 사업부 기본 요일 · 그 주에 없으면 마지막 날)으로 계산해 그리드 D_ 값과 저장 본문(가로채기 · 서버 미전송)에 대조) · upload:파일경로[|OK](열린 업로드 모달의 파일 입력에 넣고 검증·분류 결과 글자 기록 · |OK = OK 클릭 실저장(가로채기 해제 · 기록 시각 → 시나리오 끝 키 없는 복원)) · condval:라벨=정규식(조회조건 칸 입력값) · widen:N(조회조건 기간 칸 시작을 N개월 앞으로 — 입력 2개 이상·첫 값 yyyy.mm 형식 칸 전부) · lang:KO|EN|CN(머리글 언어 버튼으로 사용자 언어 변경 — 서버 저장 · 시나리오 끝(finally)에 시작 언어로 복원) · pagetext:정규식(보이는 화면 글자 전체에 정규식 일치 · 불일치 FAIL) · griddump:칸,칸[@칸=정규식](현재 그리드 행의 칸 값 조합을 중복 없이 결과 폴더 grid_<ID>.json 에 기록 · 진단용 · 판정 없음) · poprow:정규식(열린 팝업 그리드에서 보이는 글자가 정규식에 맞는 첫 행을 한 번 클릭해 선택 · 50행까지) · srvguard:버튼정규식|SQL|문구정규식(문구 앞 @resp: = 화면 알림 대신 서버 응답까지 포함해 판정 — 성공 경로용 · 데이터 변경 요청을 가로채 본문 값으로 SQL 의 @키 를 채워 DB 건수 조회 → 0건일 때만 서버 전송 · 버튼 클릭 뒤 확인창 OK 자동 · 응답·알림이 문구와 맞으면 PASS · 0건 아니면 서버 미전송·측정 실패 — 프로시저 원문에서 '건수 0 이면 DML 전 중단' 검사를 먼저 확인한 경우만) · srvblock:필드정규식>=한계|문구정규식(서버 검증 차단 실측 — 다음 저장 요청 본문에서 필드(^ 묶음·배열 포함) 값 중 |값|>=한계가 있을 때만 서버로 보내고 응답·알림이 문구와 맞으면 PASS · 본문에 그런 값 없으면 서버 미전송·측정 실패 · 복원 키 없는 화면의 DML 전 검증용 — 프로시저 원문에서 검증이 DML 앞임을 먼저 확인할 것) · rowhas:키칸=값|칸~정규식(그 키 행의 칸 값 단언 · 키 행 없으면 측정 실패) · rowcnt:=N · rowcnt:>=N · rowcnt:칸=값=N(현재 그리드 행 수 · 칸 값 일치 행 수 단언 · A1 표본 행 · EG001) · formsave(Excel Form 클릭 → 팝업이면 팝업 안 Download/확인 → 내려받은 양식을 결과 폴더 form_<ID>.xlsx 로 저장 · 머리글 기록 · 업로드 실저장 준비) · combohas:콤보ID정규식=값(마지막 realsave 뒤 수집된 그 콤보 응답의 CODE/NAME 에 값 있음 · 값 @new:칸 = realsave 신규 행의 그 칸 값 · B7/F1 저장 후 콤보 즉시 노출 · DM-10~12) · dbcount:SELECT COUNT(*) …|=N 또는 |>N(읽기 전용 DB 조회 첫 칸 단언 · 토큰 @user=현재 로그인 계정 · realsave 뒤 복원 전 상태 대조 · GAP-443) · savechk:식(저장 요청 본문 JSON 행 판정 — n=N · n>=N · sum:필드=값 · all:필드~정규식 · any:필드~정규식 · min:필드>=값 · 정규식 토큰 @thismon=이번 주 월요일 yyyymmdd · @colmon=마지막 입력 칸 주(W_yyyymmWW)의 ISO 월요일 yyyymmdd · @colym=칸 연월 · @val=마지막 입력값 · F9/F6 일자 분배 · EG228/EG243/EG198) · savedump(저장 요청 본문을 결과 파일 scn_save_<ID>.json 에 남김 · 구조 확인용 · 판정 없음) · realsave(실저장 — cleanup_spec keyset 화면만 · 저장 직전 수정 행 + 키가 모두 채워진 신규 행 기록(touched_rows) → 실제 저장 → 시나리오 끝에 restore_touched 로 복원(수정 = AS OF 값 · 신규 = AS OF 부재 + 시험 계정 생성 행 삭제 · 실패 = ERROR) · 신규 행 키 빈칸이면 측정 실패) · fill:라벨=값(조회조건 아닌 화면 입력칸 — 라벨로 시작하는 formItem 의 입력칸에 값 입력 · 패널 검색칸 등) · btnnth:N:이름(같은 이름 버튼 중 N번째(1부터) 클릭 — 패널 안 Search 등) · @row:N = 값 있는 기존 행 중 N번째 값 · idle[:초](로딩 스피너·progressbar 가 사라질 때까지 대기 · 기본 120초 · 넘으면 측정 실패) · nomsgre:정규식(여기까지 안내·토스트 중 정규식 일치가 있으면 FAIL — 정상 데이터 Validation 오탐 없음 · EG168) · 행 조건 확장: @조건칸=정규식&키칸=@last(마지막 type 행의 그 칸 값과 같은 행)&칸=정규식(추가 조건) · 칸 토큰 @LASTCOL = 마지막 type/paste 칸 · popcell:칸=검색어(팝업 셀: 셀 더블클릭 → 열린 팝업의 첫 입력칸에 검색어 → Enter/Search → 첫 결과 행 더블클릭 → 셀 값·연쇄 자동값 확인은 cell/dbcell · EG172/EG103) · download:버튼이름(클릭 → 다운로드 파일(xlsx) 데이터 행 수 = 현재(gridcols) 그리드 행 수 · 포커스 그리드 다운로드 H7 · EG347) · rail:W@set:키.칸 | rail:W@mon | rail:D@mon(현재기간 구분선 = 첫 행 동적 칸 중 왼쪽 테두리 2px 이상인 칸 1개 · 그 칸 키 = 기대(응답 부가셋 값 또는 이번 주 월요일 ISO 주 yyyymmWW / 월요일 yyyymmdd) · H2 · DM-133 · EG311) · dbcell:행,칸=SELECT … :v(DB 조회 첫 행 첫 칸 = 그 칸 값 · :v = 마지막 type/paste 값 · 자동 세팅 칸 원천 대조 · EG129/EG103) · cell 은 기대가 안 맞으면 3초까지 재확인(비동기 채움) · dynlock:칸=정규식:모드(그 조건 행의 동적 기간 칸(M_/W_/D_ · 6~8자리) 편집 가능 구간 · 모드 ALL=전부 편집 · NONE=전부 잠김 · M>@set:키.칸 = 마지막 조회 응답 부가셋 키의 칸 값(YYYY-MM)보다 큰 달만 편집(M+4 규칙 · AS-IS ds.Tables[1] MONTH_NAME) · M>@ym:N = 이번 달+N 보다 큰 달만 · D>@mon:N = 이번 주 월요일+N일 보다 큰 날(8자리 칸)만 · W>@mon:N = 월요일+N일이 속한 ISO 주(yyyymmWW)보다 큰 주만 · D2 · EG112/EG115) · paste:칸=값[@조건칸=정규식](클립보드에 값을 넣고 셀 선택 후 Ctrl+V · F3 · EG202) · 값 @cand:N = 그 칸 콤보 N번째 후보 표시명 · @row:N = 같은 칸 N행 값(type/paste 공통) · weekedge:D[:+N]@조건칸=정규식(일자 칸 D_YYYYMMDD 편집 잠금 경계 = 이번 주 월요일(오늘+(1−요일번호))+N일 · 경계 전 잠김·경계부터 편집 · GAP-38 · EG114) · nonehas:칸=값(그 값 행 없어야 함) · nomsg(여기까지 안내·토스트 0 이어야 함 · DM-234 중간 토스트) · 값 '~' = 마지막 dbl 행의 그 칸 값(anyhas/nonehas/savehas/dbl 의 =값 · EG217) · review:사유(결과 = 판정필요 · 관측값(문구·저장 요청)을 증거에 남김 — 업무 결정 대기 항목 · EG154) · setcell:칸=값[@조건칸=정규식](그리드 API 로 값 직접 설정 — 붙여넣기·팝업 입력 대체 · EG089) · clickrow:칸=정규식(현재 그리드에서 그 값 행의 칸 클릭 → 선택 연동 · EG011) · fmt:칸~정규식@행수(앞 N행 표시 글자(DOM) 전부 정규식 일치 · A2 표시 형식) · gridcands:칸*~정규식(후보 전부 일치) · insertat:N(N번째 행 첫 칸 클릭 → Insert → 신규 행이 N 위치(선택 행 바로 위)에 생겨야 함 · 세트형 그리드 D6 · EG141) · type:칸=값@조건칸=정규식(그 조건에 맞는 기존 행에 입력 · 행 번호 기억 · 입력 직후 안내가 뜨며 값이 바뀌면 실패 아님 — cell/문구로 판정) · cell:행,칸=값(행 = 번호 또는 ~ = 마지막 type 행 · 값 '' = 빈 칸 · ~정규식) · samekey:칸=값@키칸,키칸(같은 키 묶음의 한 행에 입력 → 묶음 전 행 같은 값·수정 표시 · EG204) · gridcands:칸=@combo:콤보ID(그리드 셀 콤보 후보 ⊆ 서버 콤보 응답 이름 · 편집기 열어 후보 필터 설치 뒤 dataMap 표시값) · gridcands:칸~정규식(후보에 있음) · gridcands:칸!~정규식(후보에 없음) · seek:칸=값(상단 행을 차례로 더블클릭해 하단 그리드에 그 값 행이 나올 때까지 · 최대 40행 · 찾으면 대상 그리드 재활성화 · gridcols 뒤) · gridcols:칸,칸(이후 단계가 볼 그리드 = 이 칸들이 있는 그리드 · 첫 칸 클릭으로 활성화) · tab:탭이름 · val:칸=값(신규 행 값 일치 — 신규 행 없으면 측정 실패 · EG127) · anyhas:칸=값(행 전제 — 없으면 측정 실패) · exists:선택자(화면 요소 있음 · EG413) · noload(조회 중 Loading 문구 토스트 없음 · EG302) · frozen:일수(신규 행 일자 칸 — 오늘~오늘+일수 잠김 · 그 뒤 편집 · EG118) · formdl(Excel Form 동작 — 팝업 기본 · 없으면 사용자 판정 · CR-095) · delrow(첫 행 선택 후 Delete · CRUD D 확인) · savehas:값(가로챈 저장 요청 본문에 값) · popopen:라벨(돋보기 팝업 열기) · labelorder:A>B(조회조건 B 가 A 바로 다음 · EG276) · btnhide:이름·btnshow:이름(공통 버튼 숨김·노출 판정) · search0(0행이어도 진행) · popedit(팝업 그리드 첫 숫자 칸 수정) · popsame(그 칸이 수정 전 값으로 돌아왔는지 · EG429·EG438) · req(직전 단계 뒤 읽기 요청 있어야 함) · iscombo:라벨(조회조건이 콤보) · reqhas:키=값(직전 단계 뒤 읽기 요청 본문에 그 값 · EG249) · dbl:@FIRST(첫 보이는 칸) · edit(첫 편집 가능 숫자 칸에 값 입력) · blank:칸(그 칸이 비어 있어야 함) · cond:라벨=값 · search · insert · type:칸=값 · dbl:칸 · dbl:칸=값@칸(값으로 행을 찾아 다른 칸 더블클릭 · @DYN = 첫 기간 칸) · save · btn:이름
//   저장 요청은 가짜 응답으로 막으므로 DB 는 바뀌지 않는다
export type Step = { kind: 'cond' | 'search' | 'insert' | 'type' | 'dbl' | 'save' | 'btn' | 'edit' | 'blank' | 'reqhas' | 'req' | 'iscombo' | 'popedit' | 'popsame' | 'search0' | 'btnhide' | 'btnshow' | 'labelorder' | 'popopen' | 'delrow' | 'savehas' | 'formdl' | 'frozen' | 'exists' | 'noload' | 'tab' | 'val' | 'anyhas' | 'gridcols' | 'seek' | 'gridcands' | 'cell' | 'samekey' | 'insertat' | 'clickrow' | 'fmt' | 'review' | 'setcell' | 'nonehas' | 'nomsg' | 'weekedge' | 'paste' | 'dynlock' | 'dbcell' | 'rail' | 'download' | 'popcell' | 'nomsgre' | 'idle' | 'btnnth' | 'fill' | 'realsave' | 'savedump' | 'savechk' | 'dbcount' | 'combohas' | 'formsave' | 'rowcnt' | 'rowhas' | 'srvblock' | 'poprow' | 'srvguard' | 'griddump' | 'lang' | 'pagetext' | 'widen' | 'upload' | 'condval' | 'weeksplit' | 'curprop' | 'popcombo' | 'copykeys' | 'colvis' | 'fiberprops' | 'viewport' | 'setcells' | 'mockresp'; a: string; b: string; c: string };
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | '판정필요'; why: string };

export function parseSteps(s: string): Step[] {
  return s.split(';').map(x => x.trim()).filter(Boolean).map(x => {
    const i = x.indexOf(':'); const kind = (i < 0 ? x : x.slice(0, i)) as Step['kind']; const rest = i < 0 ? '' : x.slice(i + 1);
    const at = kind === 'dbl' ? rest.lastIndexOf('@') : -1; /* @칸 은 dbl 전용 — cond 의 @pop 값과 섞이지 않게 */ const head = at >= 0 ? rest.slice(0, at) : rest; const eq = head.indexOf('=');
    return { kind, a: eq >= 0 ? head.slice(0, eq) : head, b: eq >= 0 ? head.slice(eq + 1) : '', c: at >= 0 ? rest.slice(at + 1) : '' };
  });
}

/** failed = 단계 실패 문구(재료 없음) · msgs = 단계 중 나온 문구 전부 · saves = 저장 요청 수 · editor = 마지막 더블클릭 뒤 편집기 열림 */
export function judgeScenario(s: { failed: string; msgs: string[]; saves: number; editor: boolean | null; msgRe: string; noSave: boolean; noEditor: boolean; name: string; cellErr?: string; review?: string; entryBlocked?: string }): J {
  // 2026-11-17(SCP0104 SOP_DT): 없는 날짜를 넣으려 했는데 달력 편집기가 입력 단계에서 받지 않았으면(값이 그대로·다른 값) 저장 차단 메시지를 볼 대상이 없다 — 입력 단계 차단 = 기대 충족
  if (s.entryBlocked && /없는 날짜/.test(s.name)) return { result: 'PASS', why: `${s.name}: 입력 단계에서 차단 — ${s.entryBlocked.slice(0, 160)} · 없는 날짜가 칸에 들어가지 않아 저장 차단 메시지 대상 아님` };
  if (s.failed) return { result: 'ERROR', why: `[측정 경로 없음] ${s.name}: ${s.failed}` };
  if (s.review) return { result: '판정필요', why: `${s.review} · ${s.name}` };
  const all = s.msgs.join(' | '); const bad: string[] = [];
  // 앞선 필수 검사에 먼저 걸리면 시나리오 전제를 못 맞춘 것 — 기대 문구 자체를 잰 게 아니다(2026-11-03 DMF0072·DMF0049)
  if (s.msgRe && !new RegExp(s.msgRe, 'i').test(all) && /필수|required|mandatory/i.test(all) && !/필수|required/i.test(s.msgRe)) return { result: 'ERROR', why: `[확인 대상] ${s.name}: 앞선 필수 검사에 먼저 걸려 기대 문구를 못 잼 — '${all.slice(0, 140)}'` };
  const ora = /ORA-\d{5}[^|]{0,80}|SQLCODE=-?\d+[^|]{0,60}/.exec(all); if (ora) bad.push(`SQL 오류: ${ora[0]}`);
  if (s.msgRe && !new RegExp(s.msgRe, 'i').test(all)) bad.push(`문구 /${s.msgRe}/ 없음 — 실제 '${all.slice(0, 160)}'`);
  if (s.noSave && s.saves > 0) bad.push(`저장 요청 ${s.saves}건 나감`);
  if (s.noEditor && s.editor === true) bad.push('편집기가 열림');
  if (s.cellErr) bad.push(s.cellErr);
  return bad.length ? { result: 'FAIL', why: `${s.name}: ${bad.join(' · ')}` } : { result: 'PASS', why: `${s.name}: 기대대로${s.msgRe ? ` 문구 '${all.slice(0, 80)}'` : ''}${s.noSave ? ' · 저장 요청 0' : ''}${s.noEditor ? ' · 편집기 안 열림' : ''}` };
}

/** 요청 본문들에 키=값이 있는지(대소문자 무시 키) — bodies 는 JSON 문자열 */
export function reqHas(bodies: string[], key: string, val: string): boolean {
  const walk = (o: unknown): boolean => { if (Array.isArray(o)) return o.some(walk); if (o && typeof o === 'object') return Object.entries(o as Record<string, unknown>).some(([k, v]) => (k.toLowerCase() === key.toLowerCase() && String(v ?? '') === val) || walk(v)); return false; };
  return bodies.some(b => { try { return walk(JSON.parse(b)); } catch { return false; } });
}

/** 조회조건 라벨 순서(EG276) — labels 는 화면 순서 · a 바로 뒤가 b 인지 */
export function labelNext(labels: string[], a: string, b: string): string {
  const nz = (t: string) => t.replace(/[*\s.]/g, '').toLowerCase(); const v = labels.map(nz); const i = v.indexOf(nz(a));
  if (i < 0) return `조건 ${a} 없음(화면 ${labels.slice(0, 8).join(',')})`;
  return v[i + 1] === nz(b) ? '' : `${a} 다음이 ${labels[i + 1] ?? '없음'} — 문서는 ${b}`;
}

/** Excel Form 동작(CR-095) — 팝업 = 기본(ok) · 팝업 없이 다운로드/자동 조회 = 사용자 판정(review) · 아무 동작 없음 = 오류(bad) */
export const FORM_REVIEW_TAG = '[Excel Form 팝업 없음 → 판정필요]';
export function judgeFormAction(s: { button: boolean; dialog: boolean; download: boolean; reads: number }): { kind: 'ok' | 'review' | 'bad' | 'none'; why: string } {
  if (!s.button) return { kind: 'none', why: 'Excel Form 버튼 없음' };
  if (s.dialog) return { kind: 'ok', why: 'Excel Form 팝업 열림(기본 동작)' };
  if (s.download) return { kind: 'review', why: `${FORM_REVIEW_TAG} 팝업 없이 양식 다운로드 — 사용자 요구로 바꾼 동작일 수 있어 사용자가 판정(CR-095)` };
  if (s.reads > 0) return { kind: 'review', why: `${FORM_REVIEW_TAG} 팝업 없이 자동 조회 ${s.reads}건 — 사용자 요구로 바꾼 동작일 수 있어 사용자가 판정(CR-095)` };
  return { kind: 'bad', why: 'Excel Form 을 눌러도 팝업·다운로드·조회 모두 없음' };
}

/** 신규 행 Frozen 구간(EG118·EG131) — cells: 칸 날짜(YYYYMMDD)·편집 가능 · limit = 오늘+N일(YYYYMMDD) */
export function judgeFrozen(s: { cells: { d: string; editable: boolean | null }[]; limit: string }): { kind: 'ok' | 'bad' | 'none'; why: string } {
  const c = s.cells.filter(x => x.editable !== null);
  if (!c.length) return { kind: 'none', why: '신규 행 일자 칸 편집 여부를 못 읽음' };
  const inF = c.filter(x => x.d < s.limit), out = c.filter(x => x.d > s.limit); /* 경계일은 문서가 모호해(+10일 이후 입력 · 오늘~+10일 잠김) 판정에서 뺀다 */
  if (!inF.length || !out.length) return { kind: 'none', why: `경계 양쪽 표본 부족 — ${s.limit} 이하 ${inF.length}칸 · 이후 ${out.length}칸` };
  const open = inF.filter(x => x.editable), lock = out.filter(x => !x.editable);
  if (open.length) return { kind: 'bad', why: `Frozen 구간(~${s.limit}) ${inF.length}칸 중 편집 가능 ${open.length}칸: ${open.slice(0, 3).map(x => x.d).join(',')}` };
  if (lock.length === out.length) return { kind: 'bad', why: `Frozen 뒤 ${out.length}칸이 전부 잠김` };
  return { kind: 'ok', why: `Frozen ~${s.limit} ${inF.length}칸 잠김 · 뒤 ${out.length - lock.length}칸 편집` };
}

// 기준일 경계(GAP-38): 경계 전 일자 칸은 잠김, 경계(포함)부터 편집 가능 — 경계 = 이번 주 월요일(+N) (2026-11-03 · EG114)
export function judgeWeekEdge(s: { cells: { d: string; editable: boolean | null }[]; boundary: string }): { kind: 'ok' | 'bad' | 'none'; why: string } {
  const c = s.cells.filter(x => x.editable !== null);
  if (!c.length) return { kind: 'none', why: '일자 칸 편집 여부를 못 읽음' };
  const before = c.filter(x => x.d < s.boundary), after = c.filter(x => x.d >= s.boundary);
  if (!before.length || !after.length) return { kind: 'none', why: `경계 ${s.boundary} 양쪽 표본 부족 — 전 ${before.length}칸 · 후 ${after.length}칸` };
  const open = before.filter(x => x.editable), lock = after.filter(x => !x.editable);
  if (open.length) return { kind: 'bad', why: `경계(${s.boundary}) 전 ${before.length}칸 중 편집 가능 ${open.length}칸: ${open.slice(0, 3).map(x => x.d).join(',')}` };
  if (lock.length) return { kind: 'bad', why: `경계(${s.boundary})부터 ${after.length}칸 중 잠김 ${lock.length}칸: ${lock.slice(0, 3).map(x => x.d).join(',')}` };
  return { kind: 'ok', why: `경계 ${s.boundary} 전 ${before.length}칸 잠김 · 후 ${after.length}칸 편집` };
}

// 동적 기간 칸 편집 구간(D2 Bucket×Measure): 경계(YYYYMM, 포함 안 함) 이하 잠김 · 초과 편집 — 2026-11-03 EG112
export function judgeDynLock(s: { cells: { d: string; editable: boolean | null }[]; mode: 'ALL' | 'NONE' | 'GT'; boundary?: string }): { kind: 'ok' | 'bad' | 'none'; why: string } {
  const c = s.cells.filter(x => x.editable !== null);
  if (!c.length) return { kind: 'none', why: '동적 기간 칸 편집 여부를 못 읽음(칸 미렌더 — 고정 칸 폭이 그리드 가시 폭 이상이면 스크롤 칸이 안 그려짐 · T54)' };
  if (s.mode === 'ALL') { const lock = c.filter(x => !x.editable); return lock.length ? { kind: 'bad', why: `전부 편집 기대인데 잠김 ${lock.length}/${c.length}: ${lock.slice(0, 3).map(x => x.d).join(',')}` } : { kind: 'ok', why: `${c.length}칸 전부 편집` }; }
  if (s.mode === 'NONE') { const open = c.filter(x => x.editable); return open.length ? { kind: 'bad', why: `전부 잠김 기대인데 편집 ${open.length}/${c.length}: ${open.slice(0, 3).map(x => x.d).join(',')}` } : { kind: 'ok', why: `${c.length}칸 전부 잠김` }; }
  const b = s.boundary || ''; if (!b) return { kind: 'none', why: '경계 값 없음' };
  /* 표본 전부 잠김 = 경계 규칙이 아니라 행 단위 잠금(권한·행 상태·버전)일 수 있다 — 경계 판정 불가(확인 대상) · 2026-11-03 DMF0082 행 3 */
  if (c.every(x => !x.editable)) return { kind: 'none', why: `[확인 대상] 표본 ${c.length}칸 전부 잠김 — 행 단위 잠금(권한·행 상태) 여부 먼저 확인 필요 · 경계 ${b} 판정 불가` };
  const le = c.filter(x => x.d.slice(0, b.length) <= b), gt = c.filter(x => x.d.slice(0, b.length) > b);
  if (!le.length || !gt.length) return { kind: 'none', why: `경계 ${b} 양쪽 표본 부족 — 이하 ${le.length}칸 · 초과 ${gt.length}칸` };
  const open = le.filter(x => x.editable), lock = gt.filter(x => !x.editable);
  if (open.length) return { kind: 'bad', why: `경계(${b}) 이하 ${le.length}칸 중 편집 가능 ${open.length}: ${open.slice(0, 3).map(x => x.d).join(',')}` };
  if (lock.length) return { kind: 'bad', why: `경계(${b}) 초과 ${gt.length}칸 중 잠김 ${lock.length}: ${lock.slice(0, 3).map(x => x.d).join(',')}` };
  return { kind: 'ok', why: `경계 ${b} 이하 ${le.length}칸 잠김 · 초과 ${gt.length}칸 편집` };
}

// 저장 본문 행 판정(2026-11-03 · 일자 분배) — rows: 저장 요청 JSON 의 행 객체들
/** '^' 로 묶인 다중 값 행(DMF0082 월 입력 yyyymmdd=20270301^20270308… · qty=700^700…)을 같은 순번끼리 행으로 펼친다(2026-11-03 T44) */
export function expandPacked(rows: Record<string, unknown>[]): Record<string, unknown>[] {
  const out: Record<string, unknown>[] = [];
  for (const r of rows) { const packed = Object.entries(r).filter(([, v]) => typeof v === 'string' && v.includes('^')); if (!packed.length) { out.push(r); continue; } const n = Math.max(...packed.map(([, v]) => String(v).split('^').length)); for (let i = 0; i < n; i++) { const x: Record<string, unknown> = { ...r }; for (const [k, v] of packed) { const parts = String(v).split('^'); x[k] = parts.length === n ? parts[i] : parts[Math.min(i, parts.length - 1)]; } out.push(x); } }
  return out;
}
export function judgeSaveRows(rows0: Record<string, unknown>[], expr: string): { ok: boolean | null; why: string } {
  const rows = expandPacked(rows0);
  if (!rows.length) return { ok: null, why: '저장 본문 행 0' };
  let m: RegExpMatchArray | null;
  if ((m = expr.match(/^n(>=|=)(\d+)$/))) { const n = rows.length, want = Number(m[2]); const ok = m[1] === '=' ? n === want : n >= want; return { ok, why: `행 ${n}건 ${m[1]} ${want}` }; }
  if ((m = expr.match(/^sum:([^=]+)=(-?[\d.]+)$/))) { const f = m[1]; const tot = rows.reduce((a, r) => a + (Number(String(r[f] ?? '').replace(/,/g, '')) || 0), 0); const want = Number(m[2]); return { ok: Math.abs(tot - want) < 1e-6, why: `${f} 합계 ${tot} (기대 ${want})` }; }
  if ((m = expr.match(/^min:([^>]+)>=(\S+)$/))) { const f = m[1]; const vals = rows.map(r => String(r[f] ?? '')).filter(Boolean).sort(); const lo = vals[0] || ''; return { ok: lo >= m[2], why: `${f} 최소 ${lo} >= ${m[2]}` }; }
  if ((m = expr.match(/^(all|any):([^~]+)~(.*)$/))) { const re = new RegExp(m[3]); const vals = rows.map(r => String(r[m![2]] ?? '')); const hit = vals.filter(v => re.test(v)); const ok = m[1] === 'all' ? hit.length === vals.length : hit.length > 0; return { ok, why: `${m[2]} ${m[1]} /${m[3]}/ ${hit.length}/${vals.length}(값 ${[...new Set(vals)].slice(0, 6).join(',')})` }; }
  return { ok: null, why: `savechk 식 해석 불가 ${expr}` };
}
/** W_yyyymmWW / M_yyyymm / D_yyyymmdd 칸 → { mon: ISO 주 월요일 yyyymmdd, ym: 연월 } */
export function colDates(binding: string): { mon: string; ym: string } {
  const pad = (n: number) => String(n).padStart(2, '0'); const b = binding.replace(/^[WMD]_?/, '');
  const fmt = (d: Date) => `${d.getUTCFullYear()}${pad(d.getUTCMonth() + 1)}${pad(d.getUTCDate())}`;
  if (/^W/.test(binding) && /^\d{8}$/.test(b)) { const y = Number(b.slice(0, 4)), wk = Number(b.slice(6, 8)); const j4 = new Date(Date.UTC(y, 0, 4)); const dw = j4.getUTCDay() || 7; const mon = new Date(j4.getTime() + ((wk - 1) * 7 - (dw - 1)) * 86400000); return { mon: fmt(mon), ym: b.slice(0, 6) }; }
  if (/^\d{8}$/.test(b)) return { mon: b, ym: b.slice(0, 6) };
  return { mon: '', ym: b.slice(0, 6) };
}

