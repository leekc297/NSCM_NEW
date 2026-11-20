# To-Be PKG 이식 — Claude Code 작업 지시 (하네스 v1)

대상: `Doc/gen/<ID>/<ID>_PKG.sql` (gen-pkg.js 골격). 각 프로시저 끝의 `/* ===== ASIS … ===== */` 원문(T-SQL)을 Oracle PL/SQL 로 옮기고 그 블록을 지운다. 시그니처(IN/OUT)·헤더·EXCEPTION 골격은 바꾸지 않는다(O_RC 수가 틀리면 수를 맞추되 `e2e_plan.json` procs 와 `__asis-mapping__.md` §4 도 같이 고친다).

## 입력 (전부 Read)
1. `Doc/gen/<ID>/<ID>_PKG_NOTES.md` — 프로시저별 특이사항(임시테이블·동적SQL·하위 SP·결과셋 컬럼)
2. **이관 Oracle 룰** `tools/VibeManager/rules/10_RULES_KEEP.md §H`(H1~H13: MSSQL 키워드 0, **센티널 '/'(2026-10-15 개정 — 아래 §센티널)**, NVL(x,NULL)·NVL(x,'-') 금지, NLS 마스크, dual cursor, 예외 전파, GTT DELETE, 성능 순서, 가짜 구현 금지) — check-pkg P01~P38 이 이를 판정한다.
2-1. 변환 규칙: `Doc/_dev_rules/` 의 DB 변환 규칙 문서(ISNULL→NVL, GETDATE→SYSDATE, TOP→FETCH FIRST, +→||, CONVERT→TO_CHAR/TO_DATE, #temp→GTT(03_GTT)/WITH, @@ROWCOUNT→SQL%ROWCOUNT, 커서→FOR LOOP, sp_executesql→EXECUTE IMMEDIATE)
3. 선례: `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0004.sql`(GET/SAVE 표준형), `PKG_DMF0003.sql`(다중 O_RC), `03_GTT/`(임시테이블 대체), `05_Functions/`(FN_SPLITSTRING 등 공통 함수)
3-1. (SCP·SSP) VALIDATION 취합 화면 파일 `Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<최신>/<ID>.md` — DB 검증 대조 원천(아래 '해야 할 것' 3-2)
4. 분할 파라미터(콤마 리스트)는 `TABLE(SCM_MGR.FN_SPLITSTRING(P_X, ','))`, 'ALL' 처리는 `(P_X = 'ALL' OR col IN (…))` 선례대로

## 해야 할 것
1. 결과셋 컬럼명·순서는 As-is 와 **동일**(FE 그리드 바인딩이 컬럼명으로 붙는다). 별칭 대소문자는 대문자.
2. SAVE 류: `P_DATA` JSON 배열을 `JSON_TABLE` 로 전개(컬럼 키는 camelCase — FE sendRows), `rowStatus` I/U/D 분기, `V_ROW_CNT` 누적.
3. 하위 SP 호출은 해당 To-Be PKG.PROC 로. 공통 SP(UP_FX_*, SCM0001_GET_*)는 PKG_COM0000/PKG_DM0000 에서 찾고 없으면 NOTES 에 "공통 PKG 필요" 로 남긴다(임의 구현 금지).
3-1. **SP 가 돌려주는 메시지 ID(결과 커서 MSG·RAISE 메시지 코드 등)는 AS-IS ID 를 그대로 쓰지 않는다**(룰 E5 · 사용자 지시 2026-10-22) — AS-IS ID → `Doc/asisfacts/db/meta/dbo.TB_FX_MessageInfo.csv` 문구 → `Doc/tobefacts/db/msg_master.csv` 에서 같은 문구(KO, 없으면 EN)의 TO-BE ID. 같은 문구가 없으면 NOTES 에 신규 등록 요청(MSG01001+). check-pkg **P41** 이 AS-IS ID 그대로 사용을 BLOCK 한다.
3-2. **VALIDATION 취합 대조**(SCP·SSP 화면 — 사용자 지시 2026-10-23): `Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<최신>/<ID>.md` 의 `UI / DB = DB` 행(차단 시트)과 `UI별VALIDATION_보정_필터` 의 DB 행(B 보정·C 필터)이 이 화면 SP 체인의 AS-IS DB 검증 전수다(판정 기준 = 전체본 "작성기준" 시트). 이식한 PROC 마다 해당 행의 조건·실패 반환(코드·메시지)·보정값·제외 조건이 빠짐없이 있는지 대조한다. `TO-BE 적용여부 = 미적용` 은 이식 누락, `[판정 결과 차이]`·`[예외 전파 변경]`·`[반환값 상실·영향 없음]` 은 `(참고) TO-BE 근거` 의 `[적용 TAG 사유]` 를 읽고 AS-IS 와 같게 맞추거나 의도된 변경이면 NOTES 에 근거, `[AS-IS 결함 교정]` 은 AS-IS 결함으로 되돌리지 않는다. check-pkg **VR3** 이 이 화면의 DB 미적용 행 수를 WARN 으로 알려 준다.
4. 끝나면 `node tools/Harness/check-pkg.js <ID>` 를 실행해 BLOCK 0 을 만든다(T-SQL 잔재·TODO·ASIS 블록·메시지 ID 검사).
5. 사내 Oracle 적용은 **`python tools/DbConn/meta_apply.py <ID> --commit` 로만** 한다(2026-10-22 — `@<ID>_PKG.sql` 직접 실행 금지). 이 명령이 ① PKG 를 사내 `ALL_SOURCE` 와 비교해 덮어써도 되는지 판정(사내에 없음 → 컴파일 · 같음 → 생략 · 사내 = 이 파일로 마지막 적용한 상태 → 컴파일)하고 컴파일 후 `USER_ERRORS` 를 보여 준 뒤 ② `<ID>_registration.sql` 을 커밋한다(PROC_M 확정). 적용 전 `--check` 로 판정만 볼 수 있다.
   - **exit 2(중단)** = 사내에 이미 다른 PKG(다른 작업자·사내 현행본·직접 수정)가 있다 → 덮어쓰지 말고: 사내 `ALL_SOURCE` 를 새로 조회해 사내에만 있는 변경분을 `<ID>_PKG.sql` 에 병합(룰 H14)하고 NOTES 에 근거를 남긴 뒤 다시 실행. `--force-pkg` 는 사용자가 명시 승인한 경우에만.
   - 공용 PKG(PKG_COM0000 등) 멤버를 고쳐야 하면 그 PKG 전체를 다시 만들지 말고 해당 멤버만 패치하고 `Doc/gen/<ID>/<공용PKG>_<멤버>_<ID>.sql` 로 남긴다.

## 센티널 규칙 (⭐ 사용자 상시 지시 2026-10-15 — 별도 개정 대상이 아니라 이식과 동시에 적용)
- MSSQL `ISNULL(x,'')` 의 빈값 초기값·비교 정규화는 **`NVL(x,'/')`** 로 쓴다. `NVL(x,'-')`·`DEFAULT '-'` 는 check-pkg **P39 BLOCK**.
- 원래 데이터가 `'-'` 로 들어 있던 값은 `'-'` 그대로 둔다(`'/'` 는 NULL 을 채우는 초기값 전용). AS-IS 가 `'-'` 를 **실값**으로 쓰는 컬럼의 `= '-'` 비교는 유지한다 — 그 외 `'-'` 단독 비교는 **P40 WARN**(사유를 NOTES 에 남긴다).
- 과도기(이관 빈값 `'-'` + 신규 빈값 `'/'` 공존): 빈값 술어는 `IN ('-','/')`, 센티널 키 조인은 **센티널이 실제 쓰이는 컬럼만** 양변 `DECODE(a,'-','/',NVL(a,'/')) = DECODE(b,'-','/',NVL(b,'/'))`. 실값 키(ITEM_ID·PROJECT_CODE 등)는 raw 로 두어 PK 인덱스를 탄다. MERGE 원천도 같은 정규화로 GROUP BY (ORA-30926 방지).
- 숫자 `NVL(x,0)` / DATE `SYSDATE` 는 종전과 같다. 전문: `Doc/_rules_v2/hooks/oracle-null-sentinel-and-notnull-default.md` §0.5.

## 하지 말 것
- As-is 에 없는 로직 추가/"개선" — 차이가 필요하면 NOTES 에 사유. 주석 처리된 As-is 코드 이식 금지.
- 결과셋 컬럼 생략/이름 변경, O_RESULT_CURSOR 규약(CODE/MSG/EVENT) 변경.

## 정렬(ORDER BY) — CR-075 (사용자 판정 2026-10-28, check-pkg P42)
- 그리드에 표시되는 조회 PROC(PROC_M 의 sheet 가 SHEET_COLUMNS 메타를 가진 시트)는 **반드시 ORDER BY** 를 가진다. AS-IS SP 에 ORDER BY 가 없었더라도(테이블 순) TO-BE 는 화면 키 컬럼 순으로 결정적 순서를 만든다.
- AS-IS SP 의 ORDER BY 키·분기(가드)는 그대로 옮긴다(`Doc/asisfacts/screens/<ID>/sort_rules.csv`). 그리드/코드 정렬(SmartColMerge·SetSort)이 있으면 같은 키를 SQL ORDER BY 로 옮긴다.
- 빈 값 정렬 위치: MSSQL 은 `''` 를 맨 앞, Oracle 은 NULL 을 맨 뒤(NULLS LAST)에 둔다 → ORDER BY 의 문자 키마다 `NULLS FIRST`(또는 `NVL(col,'/')`)를 붙여 AS-IS 와 같은 순서를 만든다. (SCP0007 CUSTOMER 빈 값 110행 실측 2026-10-28)
- 룩업·집계·저장 PROC(비그리드 시트, 결과 1행)은 대상이 아니다 — PKG_NOTES 에 사유를 적는다.

## 감·예측 답변 금지 (사용자 상시 지시 2026-10-31 · hook #126 §0-1)

수치·진행율·소요 시간·원인·결과를 감이나 예측으로 답하지 않는다. 답은 이번에 실행한 측정·로그·파일·DB 조회 결과만 인용하고 그 출처와 시각을 함께 적는다. 측정하지 못했으면 '미측정'이라고 쓰고 측정 방법을 제시한다. '~할 것으로 기대', '약 N분', 'N% 쯤' 같은 추정 표현과, 원인을 확인하지 않은 단정을 금지한다. 진행율은 분모·분자를 명시한 실측값만 쓴다(정합검증 = tools/Harness/verify/doc_proof.py 출력).
