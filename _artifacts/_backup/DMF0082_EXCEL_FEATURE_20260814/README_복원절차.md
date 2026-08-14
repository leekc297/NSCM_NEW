# DMF0082 — Excel Form / Excel Upload 기능 백업 (2026-08-14)

> **용도**: 클라우드에서 DMF0082 소스를 원복한 뒤, 이 폴더만으로 **Excel Form + Excel Upload 두 기능을 그대로 되살리기** 위한 자족 백업.
> 복원 요청 문구 예시 — *"DMF0082 Excel Form / Excel Upload 백업본으로 기능 복원해주세요"*

---

## 1. 이 백업이 담고 있는 기능 (복원 목표 상태)

| 기능 | 동작 |
|---|---|
| **Excel Form** | 모달을 열면 **화면 조회조건에 걸린 현재 데이터 전체**가 (키 조합 × 입력 가능 measure) 로 조회된다. 월 값 M4~M16 은 **빈칸(입력 전용)**. 다운로드 시 업로드 토큰 10개 + 정보성 컬럼 + M4~M16 평탄 1행 헤더. 조회조건은 **Div 하나만**(Bucket 없음) |
| **Excel Upload** | 파일 선택 = 1단계(검증·분류) / OK = 2단계(**실제 원장 적재**). 오류 0건일 때만 OK 활성 |

핵심 설계 3가지 (복원 시 반드시 유지):
1. **조회 SP 는 업로드 검증 SP 의 역함수** — 컬럼별로 코드/명칭 기대가 다르므로(아래 §5) 이 대응이 깨지면 양식→업로드 왕복이 무너진다.
2. **양식 SP 는 MAIN 조회 SP 를 내부 호출**해 스테이징(`GT_DMF0082_TEMP_FCST_N_PRICE`)을 재사용한다 — 16개 조회조건 필터를 복제하지 않는 것이 요점.
3. **적재는 화면 저장 본체를 재사용**한다 — `g_skip_parse` 로 `'^'` 파싱부만 건너뛰고 `GT_PRDM1_T_MAIN` 을 집합 적재한 뒤 본체를 **1회** 호출. MERGE·검증 게이트를 복제하지 않는다.

---

## 2. 폴더 구성

```
db/     CURRENT_PKG_DMF0082_{SPEC,BODY}.sql   ← 기능 포함 **사내 live 정본** (복원 목표 전문)
        BASE_PKG_DMF0082_{SPEC,BODY}_pre_feature.sql  ← 기능 적용 **직전** 원본 (차이 비교용)
db_delta/ D1_SPEC_GET_EXCEL_FORM_DATA.sql     ← 신규 SP 선언
          D2_BODY_GET_EXCEL_FORM_DATA.sql     ← 신규 SP 본문
          D3_patch_uploadsave.py              ← 적재분기·파싱분리·검증확장 패처(앵커 대조형)
          D4_DELTA_SNIPPETS.sql               ← 위 패치의 **삽입 조각 6종**(수동 재적용용)
meta/   M1_META_EXCELFORM.sql                 ← API/버튼/PROC_M/권한/MSG (전부 멱등)
fe/     ForecastPrice.tsx · forecast-price.constants.ts
        modals/ForecastTemplateModal.{tsx,module.scss}
        utils/forecast-price.{excelForm.ts,excelForm.test.ts,api.ts}
MANIFEST.txt                                   ← sha256(16)/경로/크기
```

---

## 3. 복원 절차

### 3-A. DB — 기반이 백업 시점과 **같을 때** (권장·빠름)
`db/BASE_*` 와 원복된 현재 본문이 동일하면 아래 2개를 그대로 적용한다.
```
1) db/CURRENT_PKG_DMF0082_SPEC.sql
2) db/CURRENT_PKG_DMF0082_BODY.sql
```
⚠ `ora.py exec` 는 `SET DEFINE OFF`+주석이 CREATE 와 한 문장으로 붙어 **spec 만 조용히 실패**하는 계보가 있다 → SPEC/BODY 를 **각각 단독 실행**하고 아래 VERIFY 로 둘 다 VALID 확인.

### 3-B. DB — 기반이 **다를 때** (타 세션 변경분 보존)
통짜 덮어쓰기 금지. `db_delta/D4_DELTA_SNIPPETS.sql` 의 조각 6종을 앵커에 삽입한다.
| 조각 | 대상 | 앵커 |
|---|---|---|
| E1 | BODY 선두 | 첫 `PROCEDURE` 앞 (패키지 전역 `g_skip_parse`) |
| E2 | `P_DMF0082_SAVE_MAIN_DATA` 선언부 | `v_p_as_from_site_raw` 선언 뒤 |
| E3 | 〃 본문 | `DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;` 1줄을 교체 |
| E4 | 〃 본문 | `'^'` 파싱 블록을 `IF v_skip_parse = 'N' THEN … END IF;` 로 감쌈 |
| E5 | `P_DMF0082_EXCEL_UPLOAD` | 검증분기 `END IF;` 직전에 `ELSE` 블록 + 선언부에 지역변수 8개 |
| E6 | 〃 검증 3블록 | M12 항 뒤에 M13~M16(`ATTRIBUTE20~23`) 추가 |

그리고 신규 SP 는 `db_delta/D1`(SPEC 의 `END PKG_DMF0082;` 앞) + `D2`(BODY 의 `END PKG_DMF0082;` 앞)를 삽입.

### 3-C. 메타
```
meta/M1_META_EXCELFORM.sql   -- 멱등(MERGE/NOT EXISTS). 재실행 안전
```
포함: API `DMF0082_GET_EXCEL_FORM` / 버튼 `FcstNPrice × FORM_DATA` / PROC_M 18행 / 권한그룹(UPLOAD_DATA 보유 그룹 복제) / **MSG00718 3언어**.

### 3-D. FE
`fe/` 파일을 아래 경로로 덮어쓴다 (`nscm-fe/features/demand/src/pages/forecast-price/`).
```
ForecastPrice.tsx · forecast-price.constants.ts
components/modals/ForecastTemplateModal.tsx · .module.scss
utils/forecast-price.excelForm.ts · .test.ts · forecast-price.api.ts
```
이어서 **`node scripts/sync-i18n.mjs`** 로 locales 재생성(MSG00718 반영). 로컬 BE 가 떠 있어야 한다.
⚠ `ForecastPrice.tsx` / `forecast-price.constants.ts` / `forecast-price.api.ts` 는 **Excel 외 기능도 들어 있는 파일**이다. 그 사이 다른 변경이 있었다면 통짜 덮어쓰기 대신 아래 지점만 이식:
- `ForecastPrice.tsx` — `hasButton('FORM_DATA')`/`hasButton('UPLOAD')` 게이트, `<ForecastTemplateModal … filters staticColumns>` props
- `forecast-price.constants.ts` — `MSG.EXCEL_FORM_EMPTY = 'MSG00718'`
- `forecast-price.api.ts` — `fetchExcelFormData()`

---

## 4. 복원 검증 (VERIFY)

```sql
-- 1) 컴파일
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082';           -- 둘 다 VALID

-- 2) 신규 SP + 마커
SELECT COUNT(*) FROM ALL_PROCEDURES
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'
   AND PROCEDURE_NAME='P_DMF0082_GET_EXCEL_FORM_DATA';           -- 1
SELECT COUNT(*) FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND TEXT LIKE '%E20260813-UPLOADSAVE%';                       -- 10 (백업 시점 기준)

-- 3) 메타
SELECT API_ID FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='DMF0082_GET_EXCEL_FORM';
SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM='PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA';      -- 18
SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MSG00718';  -- 3
```

기능 스모크 (사내 실측 기준값 — div40 / 20261101~20270131):
- 조회 SP 직접 호출 → **5,478행 / 40컬럼 / 약 10초**, `RESULT_CODE='0'`
- measure 분포 = `Unit Price(LOC)` 2,559 · `MKT FCST[R+P]` 2,559 · `VMI-In Request[R+P]` 360
- `FORM_WARN` 비어있지 않은 행 = 6 (마스터 결핍 예고 — 정상)
- HTTP `POST /DMF0082/FcstNPrice/FORM_DATA/call-proc` → 200
- 적재 게이트: 스테이징 없는 사용자로 mode=1 → `NOT_SAVABLE (SUCCESS=0, ERROR=0)`
- 화면 저장 회귀: 저장 SP 평소 호출 시 `GT_PRDM1_T_MAIN` 에 행이 쌓이고 검증까지 도달해야 한다(파싱부가 살아있다는 증거)

FE: `npx tsc -p features/demand --noEmit` = 0 / `npx vitest run --root features/demand excelForm` = 13 PASS

---

## 5. 절대 깨뜨리면 안 되는 계약

**5-1. 업로드 검증이 기대하는 표기** (양식 SP 가 이 역함수 — 어긋나면 업로드 전량 실패)

| 엑셀 토큰 | 넣어야 할 값 |
|---|---|
| Div / Sales Site / Model / Incoterms / Customs Handbook / Currency | **코드 그대로** |
| End Customer | **명칭** = `NVL(END_CUSTOMER lookup SEGMENT3, SITE_ITEM.PROJECT_CODE)` |
| FCST Type | **명칭** = `SALES_TYPE_CODE` SEGMENT2 (예 `MPS`→`Mass`) |
| Cell Prod Site | **명칭** = `SP_CELL_PROD_SITE` **ATTRIBUTE1** (예 `NJ01-A`→`남경A`) |
| Measure | **표시명** = `DM_UI_EDITABLE_MEASURE` SEGMENT4 |

**5-2. 엑셀 헤더** — BE(`FileServiceImpl.cvtListUploadRows`)가 `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 토큰명으로 **이름 조회**한다.
- 토큰 10개 + `M4`~`M16` 은 **원형 그대로**(1바이트만 달라도 그 열 전량 탈락)
- HEADER_CONTENT 에 없는 정보성 컬럼은 무시되므로 자유롭게 덧붙여도 된다. **파일 내 컬럼 순서도 무관**
- **헤더명 중복만 치명적**(HashMap 키라 뒤가 앞을 덮음) → `Team`/`Team` 같은 중복은 유일화 필수

**5-3. 적재 분기**
- DAILY 전개 직후 **COMMIT 필수** — 저장 본체가 검증 실패 시 `ROLLBACK` 하면 GTT 적재분까지 사라진다
- 빈칸 제외 = `MONTHLY_QTY <> 0` (일자 단위로 거르면 배분 나머지 0인 정상 일자를 버려 총량이 깨진다)
- `VMI_In_Req` 는 **배분 없이 월 1일**(사용자 확정) — 기존 배분 파이프라인은 `MKT_FCST`/`LOC` 만 처리
- `PLANT_SITE_ID` 는 양식 토큰에 없다(추가하면 중복키 검사가 전량 ERROR) → 원장 역참조 `NVL(…, '-')`
- 0 입력은 **거부 유지**(사용자 확정. 0 은 원장에서 삭제로 해석될 수 있음)

**5-4. 모달 레이아웃** — 조회조건 래퍼에 `flex: 0 0 auto` 필수. 없으면 조회 후 그리드가 커지며 조회조건을 0 높이로 눌러 덮는다(2026-08-14 실사고).

---

## 6. 미완료 (복원 후에도 남는 것)

- 실화면 왕복 E2E(양식 → 값 입력 → 업로드 → OK → **원장 증분 직접 확인** → 원복)
- 대사표(`__asis-mapping__.md`) XF 항목 갱신 + `COMMON:UC-01~06` 축 신설
- 클라우드 이관 패키지(`_deploy_packages/`) 반영 — 현재 **클라우드 미적용**
