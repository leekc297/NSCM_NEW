# 화면 VALIDATION 판독 기준서 (UI(C#) + TO-BE FE 대조) — 모든 배치 공통

작업 폴더: `C:\Projects\NSCM\Doc\화면분석서\_work\SCP_SSP_UI_VALIDATION_20261022\`
- 배치 입력: `batch_in/<배치ID>.json` (화면 목록·파일·TO-BE 폴더·직접 호출 SP·DB 검증 요약)
- 프레임워크 기준: `FRAMEWORK_REF.md` (DataUtil/DateUtil/BaseForm 등 공통 메서드가 띄우는 검증 — **먼저 Read**)
- 출력: `out/<배치ID>.jsonl` (한 줄 = JSON 1개, UTF-8). 이 파일 1개만 작성. 다른 파일 수정 금지(소스·DB·FE 모두 조회만).
- 완성 예시(3화면 샘플): `C:\Projects\NSCM\Doc\화면분석서\SCP_VALIDATION_SAMPLE_3화면_20261022.xlsx` — 문체·세분도·REMARK 수준을 이 예시에 맞춘다. 필요하면 openpyxl 로 읽어 본다.

## 0. 절대 규칙 (anti-simplification)
- 화면의 **로직 .cs 파일(logic_files)을 처음부터 끝까지 전부 Read** 한다(2000줄 넘으면 offset 으로 끝까지). grep 만으로 판정 금지. summary 의 lines_read 는 실제 Read 한 줄 수.
- 경로: logic_files 의 상대경로는 `C:\Projects\NSCM\GSCM\` 기준. `:숫자` 는 줄수, `[shared]` 등 꼬리표는 경로가 아님.
- Designer(.Designer.cs): 조회조건 라벨의 필수 표시 `*`(예: `layoutControlItem1.Text = "Division*"`), 컨트롤 이름↔라벨, Visible/Enabled 를 확인한다. 1,500줄 이하면 전부 Read, 초과면 `Text = "...*"`, `.Visible`, `.Enabled`, `ControlName`/`Control = ` 를 grep 하고 summary 에 "Designer grep" 으로 명시.
- 그리드 필수 컬럼: `C:\Projects\NSCM\Doc\asisfacts\screens\<화면ID>\grid_effective.csv` 의 label 끝 `*` (sheet 별). checkRequiredOfSpread 는 컬럼 라벨 `*` 로 판정.
- 추측 금지. 메시지·조건은 원문 근거(파일:라인).
- **주석 처리된 코드(// , /* */ 안)는 어디에도 싣지 않는다**(excl 에도 X).
- **실행되지 않는 경로**(숨김 시트·Visible=false 로 진입 불가한 탭, 항상 거짓 분기, 화면이 쓰지 않는 결과셋, 호출처 없는 메서드 등)는 `excl` 로만 기록하고 사유를 쓴다. 판단 근거(라인)를 반드시 적는다.

## 1. 무엇을 싣나
### 1-1. 차단 시트(`t:"ui"`) — 사용자가 인지하는 A 차단형 / D 검증리포트형 (화면 C# 측)
- A 차단형: 조건 불충족 시 메시지를 띄우고 진행을 막음(`MessageHelper.GMessageBox(...)` 후 return, 프레임워크 검증 메서드의 false, 셀 값 거부+메시지 등).
  - 메시지 후 값을 자동으로 바꾸고 진행하는 경우(예: 범위 밖 → 0.01 로 교체 + MSG00203)는 차단 시트에 A 로 싣고(사용자가 메시지를 봄), 자동 교체 동작은 ref 에 B 로도 싣는다(샘플 SCP0020 방식).
- D 검증리포트형: 화면이 **스스로 판정해서** 문제를 표시(화면 코드가 값을 비교해 오류 행 색칠, 화면 계산 검증 결과 표시 등)하는 경우만 ui D 행. **DB(SP)가 돌려준 플래그·표시값을 화면이 색칠·표시만 하는 경우는 ui 행을 만들지 말고 해당 `sp` 행의 `display_note` 에 적는다**(DB D 행으로 빌더가 생성).
- 판정 일관성: AS-IS 와 TO-BE 의 **검사 대상 행 범위가 다르면(예: AS-IS 전체 행 vs TO-BE 변경 행만) 부분적용**. 검사 시점·트리거가 달라 실제 사용 경로에서 검사가 일어나지 않으면 미적용.
- `GMessageBoxForException`(예외 내용 표시)은 검증이 아니며 msgcall 대상도 아니다.
- (배치 판독 중 확인) `06.UIL/GSCM.SystemMgmt.UIL/BaseFormAsync.cs` 의 `ExecuteSQL`(L454·L535 부근)이 `checkRequiredOfSearch` 를 다시 호출한다 — 화면이 BaseFormAsync 를 상속하고 ExecuteSQL 로 조회/저장하면 그 이벤트에도 조회조건 검사(MSG00097/MSG00002)가 실행된다. 해당 구간을 Read 해 확인하고 행/remark 에 반영.
- Division 컨트롤이 `UsrCheckedList2` 이거나 컨트롤 이름이 cboDivision/clbDivision 이 아니면 프레임워크 권한 Division 검사(MSG00097) 대상이 아니다(DataUtil L390-416).
- 코드상 위험(0 나누기 미처리, try/catch 없음 등)은 검증 행이 아니라 summary.notes 에 "[위험]" 으로 적는다.
- 같은 검사가 한 이벤트에서 두 번 실행되면(예: 두 메서드가 각각 checkRequiredOfSearch 호출) remark 에 "메시지가 두 번 표시됨" 을 적고 행은 한 번만.
- **화면이 명시 호출하는** 프레임워크 메서드(FRAMEWORK_REF §1-B: `DataUtil.checkRequiredOfSearch`, `checkRequired`, `checkRequiredOfSpread`, `SetDivisionAuthCheck`, `DateUtil.Check_PeriodDate*`, CExcel/ExcelUploadForm 등)는 FRAMEWORK_REF 의 동작대로 **화면 행으로 펼쳐서** 싣는다(예: checkRequiredOfSearch → 권한 Division 없음 MSG00097(cboDivision/clbDivision 가 HidePanel 안에 있을 때) + 라벨 `*` 필수 MSG00002(`*` 라벨이 있고 컨트롤 종류가 검사 대상일 때만)).
- **BaseForm 이 버튼마다 자동으로 하는 검사(FRAMEWORK_REF §1-A: 권한 MSG00096, MSG00007/00008/00009/00010, 수정 내용 없음 MSG00133, 정렬 MSG00140 등)는 화면 행으로 싣지 않는다** — 빌더가 '공통_프레임워크' 시트에 한 번만 싣는다. 단 화면이 그 버튼 흐름을 우회(자체 버튼 이벤트로 직접 저장 등)하거나 base 와 다른 자체 검사를 하면 그 자체 검사는 화면 행으로 싣고, 우회 사실은 summary.notes 에 적는다.
- 정보·확인 메시지(저장 성공 n건, "저장하시겠습니까?" Yes/No, 조회 결과 없음 안내, 예외 내용 표시만 하는 catch 등)는 검증이 아니다 → `msgcall` 로만 기록(verdict "정보·확인"). 단 "변경 내용이 있습니다. 계속?" 처럼 진행 여부를 묻고 No 면 중단하는 것은 정보·확인으로 본다.

### 1-2. 보정_필터 시트(`t:"ref"`) — 참고
- B 보정(값을 자동으로 바꾸고 계속), C 필터(조건 불충족 행을 조용히 제외), **편집 제어**(메시지 없는 잠금·콤보 후보 제한·셀 숫자 범위·팝업 전용 입력·신규 행만 삭제·조건부 컬럼 표시·시트 조회 전용 등).
- 단순 화면 초기화(조회조건 변경 시 그리드 비움, 레이아웃 토글), 조회 파라미터 조립, 색상/정렬 같은 표시 설정은 싣지 않는다.

### 1-3. DB(SP) 검증 — 직접 행을 만들지 말 것
- DB 검증 행은 기존 판독 결과(DB 취합)로 빌더가 자동 생성한다. 에이전트는 대신 **SP 별 화면 처리(`t:"sp"`)** 를 반드시 쓴다: batch_in 의 `entry_sps` **전부**에 대해 1줄씩.
  - `event`: 이 SP 를 부르는 사용자 이벤트(아래 이벤트명). 여러 이벤트면 주 이벤트 + `other_events`.
  - `fail_business`: DB 업무 검증 실패(결과코드 F/N/E 등, THROW 업무 오류) 시 화면이 보여주는 것. `{"msg_id":"MSG00006","msg_args":[]}` 또는 `{"msg_text":"Error!\nMsg : {DB메시지}"}` (DB 메시지를 그대로 보여주면 `{DB메시지}` 자리표시자 사용). 화면이 실패를 확인하지 않으면 `{"msg_text":"(화면 표시 없음 — 결과 미확인)"}` 와 근거.
  - `fail_exception`: DB 일반 예외(CATCH) 시 화면 표시. 같은 형식.
    - ⚠️ **SP 의 CATCH 가 결과셋(result_code 'F' + 오류 메시지 SELECT)을 돌려주고 끝나면 C# 에는 예외가 아니라 정상 응답**이다 → C# 의 결과코드 분기(예: `Rows[0][0] != "S"` 의 else → MSG00006)가 fail_exception 이다. C# 의 `catch(Exception)`/`GMessageBoxForException` 은 SP 가 RAISERROR/THROW 로 다시 던지거나 통신·서비스 오류일 때만 해당한다. batch_in 의 db_validation_brief.on_fail(EXCEPTION 행)에서 SP CATCH 가 SELECT 로 끝나는지 THROW 로 끝나는지 확인하고, 필요하면 `C:\Projects\NSCM\Doc\asisfacts\db\modules\dbo.<SP>.sql` 의 CATCH 블록을 Read 해 판단한다.
  - ⚠️ `tran.Success`/`t.Success`(TheOne.ServiceModel FoxDataClient — 외부 DLL, 소스 없음)가 SP 의 'F' 결과셋을 실패로 보는지는 **원문 확인 불가**(확인 2026-10-23: 01.Framework 의 PseudoFoxClient 는 FP 전용·SaveDataTable 은 null 반환 껍데기). 화면이 결과코드를 보지 않고 Success 만 보는 경우 fail_business/fail_exception 의 msg_text 는 정확히 `"(결과코드 미판정 — 서비스 Success 기준, 실패해도 성공 메시지가 뜰 수 있음·원문 확인 불가)"` 로 통일하고, 근거 라인을 asis_loc 에 적는다.
  - `unreachable`: 이 SP 가 실행되지 않는 경로(숨김 시트 전용 등)에서만 호출되면 true + `unreachable_reason`. (빌더가 그 SP 의 DB 검증을 제외_미실행으로 보낸다.) event 에 "(미실행)" 같은 꼬리표는 붙이지 말 것.
  - `display_note`: 조회 SP 의 D 형(오류/등록필요 표시값)을 화면이 어떻게 보여주는지(색칠·컬럼·없음). 해당 없으면 "".
  - `asis_loc`: C# 처리 근거 파일:라인.
  - TO-BE FE 가 있으면 `fe_note`: TO-BE 가 이 SP 실패를 어떻게 처리하는지(공통 useProcMutation 은 결과커서 코드를 FE 에서 판정하지 않음 → BE 판정 의존이라는 점 등, 파일:라인). `fe_downgrade`: DB 는 일치해도 TO-BE 화면에서 사용자가 AS-IS 와 같은 결과를 볼 수 없으면 true + 이유(예: 오류코드 미반환으로 행 색칠 불가).
- batch_in 의 `db_validation_brief` 는 SP 측 검증 요약(참고용). 화면 처리 매핑 판단에 쓴다.

## 2. 이벤트명 (고정)
`화면 열기(OPEN)` · `조회(SEARCH)` · `편집(EDIT)` · `행추가(INSERT)` · `삭제(DELETE)` · `저장(SAVE)` · `셀 입력(CHANGE)` · `셀 클릭(CLICK)` · `붙여넣기(PASTE)` · `엑셀 업로드(UPLOAD)` · `엑셀 다운로드(EXCEL)` · `실행(RUN)`(계획 실행·배치 실행·확정 등 별도 버튼) · `팝업(POPUP)` · `기타(ETC)`
- 시트/그리드/팝업이 여럿이면 뒤에 ` — <시트·그리드·버튼·팝업명>` (예: `저장(SAVE) — Packer`, `실행(RUN) — Confirm 버튼`, `저장(SAVE) — SCP0005_DistributionRoutePopup`).
- SEQ = 이벤트(접미 포함) 안에서 실제 검사 순서(1부터).

## 3. 항목(item) — 집계 키. 아래 표준 이름을 우선 사용(정확히 같은 문자열)
### 차단(ui) 표준 항목 → `item` / `check_type`
| item | check_type | 의미 |
|---|---|---|
| 권한을 가진 Division 없음 | AUTH | MSG00097 |
| 필수값 누락 | REQUIRED | 조회조건·그리드·입력값 비어 있음(MSG00002 등) |
| 선행 입력값 미선택 | REQUIRED | "{0}을(를) 선택하십시오"(MSG00093) 등 앞 단계 값 없음 |
| 읽기 전용 시트 편집 시도 | STATUS | MSG00109 |
| 다른 그리드 작업 중 | STATUS | 다른 그리드 미저장 상태에서 편집 차단 |
| 상위(기준) 행 미선택 | REQUIRED | 기준 행 선택 없이 하위 작업 |
| 선택된 행 없음 | COUNT | 대상 행 미선택 |
| 저장(처리) 대상 없음 | COUNT | 변경 행 0건 등 |
| 0 초과 값만 허용 | QTY | |
| 0 이상 값만 허용 | QTY | |
| 하한값 미만 | RANGE | |
| 상한값 초과 | RANGE | |
| 허용 범위 밖 값 → 메시지 후 자동 교체 | RANGE | |
| 기간 시작일 > 종료일 | RANGE | |
| 기간 중첩 | RANGE | |
| 조회 기간 범위 초과 | RANGE | 최대 조회 기간 제한 등 |
| 날짜 형식 오류 | FORMAT | |
| 숫자 형식 오류 | FORMAT | |
| DB 처리 불가 날짜(1753-01-01 이전) | RANGE | |
| 화면 내 키 중복 | DUP | |
| 참조 마스터 데이터 없음 | EXISTS | 화면이 마스터/목록에서 찾아 없으면 차단 |
| 상태·버전 제약(확정/마감/진행중) | STATUS | |
| 사용자 권한·담당자 제약 | AUTH | |
| 동시 실행·진행 중 작업 존재 | RUNNING | |
| 엑셀 업로드 데이터 오류 | FORMAT | 업로드 파일 검증 |
| [조회표시] 등록 필요 데이터 표시 | EXISTS | D |
| [조회표시] 오류·상태 색상 표시 | STATUS | D |
- 표준에 맞는 것이 없으면 `item` 을 `NEW:<간결한 이름>` 으로 쓰고 check_type 은 EXISTS/DUP/REQUIRED/RANGE/STATUS/QTY/AUTH/FORMAT/COUNT/CONSISTENCY/RUNNING/OTHER 중 선택.
### 보정_필터(ref) 표준 항목 → `item`
편집 가능 컬럼 제한(키·감사 컬럼 잠금) · 신규 행 전용 입력(기존 행 키 수정 불가) · 조건부 행 전체 잠금 · 입력 후보 제한(콤보 후보 좁힘) · 셀 입력 형식·범위 제한(메시지 없음) · 팝업 전용 입력(키보드 입력 차단) · 기존 행 삭제 불가(신규 행만 삭제, 메시지 없음) · 조회 전용 시트(행추가·삭제·저장 무반응) · 조건부 컬럼 표시 · 조건부 버튼 활성화 · 자동 계산(파생값) · 허용 범위 밖 값 자동 교체 · 선택값 연동 자동 입력 · 상위값 변경 시 하위값 초기화 · 붙여넣기 값 후보 검증(없으면 공란) · 신규 행 기본값 자동 입력 · 저장 전 상태값 보정 · 빈 값 0 간주 · 빈 값 기본값 대체 · 조건 불충족 행 저장 제외(화면) · 중복 행 자동 제거(화면)
- 없으면 `NEW:<이름>`.

## 4. TO-BE 대조 (tobe_folders 가 있을 때)
- tobe_folders 의 **테스트 제외 전 파일을 Read**(`__tests__`, `*.test.ts(x)`, `*.spec.ts` 제외). `__asis-mapping__.md` 도 참고하되 판정 근거는 실제 코드.
- 공통 동작(직접 확인한 사실):
  - `@shared/hooks` `useSaveWithValidation`(`C:\Projects\NSCM\nscm-fe\packages\shared\src\hooks\useSaveWithValidation.ts`): 컬럼 메타 INPUT_TP_CD=M/IM 또는 라벨 `*` 인 필수 컬럼 중 편집 가능하고 visible 인 셀이 비면 MSG00429 계열 알림 후 저장 중단(첫 1건). 메타 실등록값은 이번 범위에서 대조하지 않음 → "메타 기준" 이라고만 적는다.
  - `useProcMutation`/`useTabProcQuery`(`packages/shared/src/hooks/useCustomQueryClient.ts`): 응답 code !== '0' 이면 서버 message 알림. 결과커서의 RESULT_CODE(F/N 등)는 FE 에서 판정하지 않음.
  - TO-BE 메시지 번호 체계가 다르다(SCM_ADM_MSG_M 재매핑, 예: MSG00002→MSG00429, MSG00193→MSG01035, MSG00072→MSG01036, MSG00049→MSG00611, MSG00093→MSG01122, MSG00060→MSG01092). 번호가 달라도 의미가 같으면 적용.
- `tobe_apply`: `적용`(같은 조건으로 막음 — 메시지 번호·문구·시점 차이는 basis 에) / `부분적용`(검사는 있으나 대상 행·경로·표시·조건 일부 다름) / `미적용`(해당 검사 없음) / tobe_folders 가 비면 `TO-BE 미개발`.
- `tobe_basis`: 파일:라인 + 차이 설명(쉬운 한국어). 상대경로는 `nscm-fe/` 기준(예: `features/supply/src/pages/tact-time/TactTime.tsx L120-123`).
- ref 행은 `tobe` 에 "-"(대조 대상 아님). 대조 중 명백한 차이를 봤으면 짧게 적어도 된다.

## 5. 출력 JSONL 스키마
```
{"t":"ui","screen":"SCP0020","event":"저장(SAVE) — Packer","seq":1,"cls":"A","item":"필수값 누락","check_type":"REQUIRED","target":"Packer 그리드 필수 컬럼 8개","msg_id":"MSG00002","msg_args":["항목명"],"msg_text":"","remark":"쉬운 한국어 상세 설명(무엇을 언제 왜 막는지, 사용자가 무엇을 해야 하는지)","asis_loc":"SCP0020_TactTime.cs L1472 / DataUtil.cs L23-65","tobe_apply":"적용","tobe_basis":"..."}
{"t":"ref","screen":"SCP0020","event":"편집(EDIT) — Packer","gubun":"편집 제어|B 보정|C 필터","item":"조건부 행 전체 잠금","content":"쉬운 설명","loc":"파일 L..","tobe":"-"}
{"t":"excl","screen":"SCP0020","event":"저장(SAVE) — Plant","kind":"UI","what":"[MSG00002] ...","loc":"파일 L..","reason":"Plant 시트 숨김(L442) → 실행 불가"}
{"t":"sp","screen":"SCP0037","sp":"SCP0037_SAVE_OPERATION_LT","event":"저장(SAVE)","other_events":[],"fail_business":{"msg_text":"Error!\nMsg : {DB메시지}"},"fail_exception":{"msg_id":"MSG00006","msg_args":[]},"display_note":"","asis_loc":"SCP0037_OperationLT.cs L501-523","fe_note":"...","fe_downgrade":false,"fe_downgrade_reason":""}
{"t":"msgcall","screen":"SCP0020","file":"SCP0020_TactTime.cs","line":1472,"msg_id":"MSG00002","verdict":"차단|보정|정보·확인|미실행","ref":"저장(SAVE) — Packer#1"}
{"t":"summary","screen":"SCP0020","files_read":[{"file":"...cs","lines_total":2909,"lines_read":2909}],"designer":"전부 Read|grep","fe_files_read":[{"file":"...","lines":301}],"msgcall_total":0,"notes":"실행 범위 판단(숨김 시트 등)·추출 한계"}
```
- `msg_args` 는 `{0}`,`{1}` 에 들어가는 값(화면이 넘기는 값 그대로, 동적이면 의미를 짧게: "항목명", "조회 MAX"). MSG ID 가 아니라 하드코딩 문자열이면 `msg_id:""` + `msg_text` 에 원문.
- **msgcall 은 로직 파일의 GMessageBox(및 MessageBox.Show / XtraMessageBox.Show) 호출 전부(주석 제외)** 에 대해 1줄씩. 프레임워크 메서드 호출로 생긴 ui 행은 msgcall 대상 아님.
- `remark`/`content` 는 업무 담당자가 읽고 이해할 수 있게: 무엇을 확인하고, 걸리면 어떻게 되고, 무엇을 해야 하는지. 컬럼 ID 대신 화면 라벨(필요시 괄호에 ID).
- 화면마다 summary 1줄 필수(마지막). 배치 끝에 `{"t":"batch_done","batch":"uNN","screens":[...]}`.

## 6. 최종 응답(부모에게)
배치ID, 화면별 ui/ref/excl/sp/msgcall 건수, 읽은 줄 수 합, 판단이 애매했던 점 3개 이내. 산출물 내용 전체를 응답에 붙이지 말 것.
