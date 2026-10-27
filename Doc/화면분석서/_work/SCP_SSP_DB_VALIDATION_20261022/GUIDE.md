# AS-IS SP VALIDATION 판독 기준서 (모든 배치 공통)

원천: `C:\Projects\NSCM\Doc\asisfacts\db\modules\dbo.<SP>.sql` (AS-IS MSSQL LGCE_SCMDEV 2026-10-16 덤프). 라인번호 = 이 파일 기준(1부터).
SQL 단위(kind=SQL)는 `C:\Projects\NSCM\Doc\asisfacts\<path>` (FoxQuery 인라인 SQL).

## 절대 규칙
- 배정된 단위의 **본문을 처음부터 끝까지 전부 Read** 한다 (2000줄 넘으면 offset 으로 나눠 끝까지). grep 만으로 판정 금지.
- 추측 금지. 조건식·반환값·메시지는 원문 그대로 발췌(200자 이내, 길면 앞부분 + "…").
- 파일 수정 금지. 출력 JSONL 1개만 작성.
- 유사 SP 와 diff 로 Read 를 대체하지 않는다. lines_read 는 실제로 Read 한 줄 수만 적는다.

## 무엇이 VALIDATION 인가 (분류)
- **A 차단형**: 조건 불충족 시 처리를 중단/실패 처리. 예) `IF … BEGIN SELECT 'F' AS result_code; RETURN; END`, RAISERROR/THROW, RETURN, 실패코드/메시지 변수 세팅 후 반환, ROLLBACK, 오류 결과셋 반환, GOTO 오류 라벨.
  - BEGIN CATCH 의 일반 예외 처리(ROLLBACK + 로그)는 **1 SP 당 1행**으로만 기록(check_type=EXCEPTION).
- **B 보정형**: 검증 성격의 조건 판정 후 값을 대체/자동 보정하고 계속 진행. 예) SSP0002_SAVE_SHIPMENT_CONFIRM_NEW L284 `IF (@prj_cnt=0)` → SITE_ITEM 첫 PROJECT_CODE 로 대체, L380 `IF @p_project_code='' OR NULL → '-'`.
  - 제외: SELECT 목록·INSERT VALUES 안의 일상적 `ISNULL(x,'')`/`ISNULL(x,0)` 표기. (단, 저장 입력 파라미터를 IF 로 검사해 대체하는 것은 B)
- **C 필터형**: 검증 목적으로 불충족 행을 조용히 제외/삭제. 예) 저장 대상 #temp 에서 마스터 미존재 행 DELETE, `WHERE NOT EXISTS(마스터)` 로 INSERT 대상 제한, 오류 플래그 행 제외, 중복 행 제거 후 저장.
  - 제외: GET(조회) SP 의 일반 검색조건 WHERE(파라미터 필터, USE_YN='Y' 룩업, 기간 조건)은 검증 아님.
- **D 검증리포트형**: SP 의 목적 자체가 "잘못된 데이터 목록/오류 건수"를 돌려주는 것(예: SCP0039_GET_VALIDATION_*, *_CHECK_*, *_VALID_* 가 오류 목록을 SELECT). 검사 규칙(무엇을 오류로 보는가) 1개당 1행.

## 파일럿(b01) 후 추가 기준 — 반드시 적용
- 단순 빈값→NULL 정규화(`NULLIF(x,'')`, `CASE WHEN x='' THEN NULL`)는 **기록하지 않음**. 단 빈값일 때 다른 값/기존값 유지/센티널('-') 대입은 B.
- 빈 키 → 시퀀스 채번은 B·check_type=REQUIRED 로 기록하고 note 앞에 `[채번]`.
- 조회 SP 가 검증용 표시값(미등록/오류 문자열, 오류·체크 플래그, 건수)을 계산해 반환하면 D, note 앞에 `[조회표시]`. 단순 상태 컬럼 전달(편집 가능 여부를 UI 가 판단)은 0건으로 두고 summary 에 기재.
- 원문상 결함·부작용(ROLLBACK 없음, 자식 실패 미전파, 마지막 행 값 참조 등)은 note 앞에 `[원문이슈]`.
- 자식 SP 실패가 부모로 전파되지 않으면 부모 summary.returns_to_ui 에 명시.

## ⭐ 기준 통일 (표본검수 후 확정 2026-10-22) — "검증 아님" 으로 본다
1. **계산 방어식**: 산식 안의 0 나눗셈 회피(분모 0/NULL → 0·1·100·NULL 대체), 음수→0 같은 계산 결과 보정, NULL 계산값의 기본값(ISNULL(x,1) 등). 단, 그 판정으로 **저장을 막거나 행을 제외**하면 검증(A/C).
2. **화면 표시 설정 기본값**: 사용자 Measure/컬럼/타이틀 설정이 없을 때 기본 설정으로 대체·자동 생성.
3. **UI 편집 경계값 전달**: CONFIRM_DAY·SHIP_FROZEN·EDIT_START_DATE 등 경계일자/상태값을 계산·전달만 하고 판정은 UI 가 하는 것. 단 SP 가 그 경계로 **행을 제외하거나 저장을 막으면** 검증(C/A), SP 가 편집가능 Y/N 플래그를 판정해 돌려주면 D.
4. **일반 범위·조인**: 업무 범위 필터(룩업 기반 집계 범위, 사업부/공정 구분), 값 조회용 일반 조인, 단순 UNION 적재, 계산 로직 분기.
5. **미도달 판정**: 반드시 해당 SP 의 **모든 호출처**(db_module_refs.csv 의 EXEC 참조 전수 + 화면 직접 호출 여부)를 확인한 뒤에만. 화면이 직접 호출하는 SP 는 파라미터가 임의값이므로 파라미터 기반 미도달 불가.

## check_type (고정 어휘 — 하나 선택)
EXISTS(참조 마스터/데이터 존재) · DUP(중복/유일성) · REQUIRED(필수값·NULL·빈값) · RANGE(날짜·기간·주차 범위/순서) · STATUS(상태·버전·확정/마감/잠금 여부) · QTY(수량·금액 음수/0/초과/합계) · AUTH(권한·사용자·담당자) · FORMAT(형식·형변환·길이) · COUNT(건수 0/초과) · CONSISTENCY(항목 간 정합·조합 규칙) · RUNNING(동시 실행/진행 중 작업) · EXCEPTION(CATCH 일반 예외) · OTHER

## reach (도달성)
- `실행`: 실제 실행 경로.
- `미도달`: 항상 거짓인 분기, 호출 파라미터로 막히는 분기(근거를 note 에), 고정값으로 죽은 코드.
- `주석`: 주석 처리된 검증 (`--` 또는 `/* */` 안). 기록은 하되 reach=주석.

## 출력 (JSONL — 한 줄 = JSON 1개, UTF-8)
검증 1건당:
```
{"unit":"SP명","kind":"SP","line_from":284,"line_to":292,"class":"B","check_type":"EXISTS","target":"SCM_MST_SITE_ITEM.PROJECT_CODE","condition":"IF (@prj_cnt=0)  -- DIVISION_ID=@p_division_id AND SCM_SITE_ID=@p_to_site AND ITEM_ID=@p_item_id AND PROJECT_CODE=@p_project_code 건수","on_fail":"SELECT top 1 @p_project_code = project_code FROM SCM_MST_SITE_ITEM (같은 사이트·품목 첫 값으로 대체)","message":"","division":"40","reach":"실행","desc_ko":"Project Code 가 Site-Item 마스터에 없으면 해당 Site·Item 의 첫 Project Code 로 대체","note":""}
```
- `division`: 사업부 분기 안에 있으면 그 값(40/81/82/EE 등, 복수는 콤마), 아니면 "전체".
- `message`: 사용자에게 돌아가는 메시지/코드 원문(없으면 "").
- `on_fail`: 실패 시 반환 원문(예: `SELECT 'F' AS result_code; RETURN`) / 보정 내용 / 제외 방식.

단위 1개당 마지막에 요약 1줄(필수, 검증 0건이어도):
```
{"unit":"SP명","kind":"SP","_summary":true,"lines_total":512,"lines_read":512,"validation_count":3,"no_validation_reason":"","exec_calls":"하위 EXEC SP 목록(호출 가드 조건 포함, 예: PR_X (IF @p_plan_id<>'CALL' 안))","returns_to_ui":"결과코드/메시지를 UI 로 돌려주는 방식 요약(예: result_code S/F/N 결과셋)","purpose":"SP 목적 한 줄"}
```
- 원문 파일이 없으면 요약 1줄만, `"lines_total":0,"no_validation_reason":"원문 없음"`.
- 검증 0건이면 `no_validation_reason` 에 이유(예: "단순 조회 — 파라미터 필터만", "INSERT/DELETE 만, 조건 판정 없음").
