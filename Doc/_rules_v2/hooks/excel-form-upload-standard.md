# Hook #135 — excel-form-upload-standard ⭐⭐⭐ (사용자 명시 2026-08-14)

> **트리거**: 화면에 **Excel Upload 기능이 있는 경우 전부** (신규 T01 / 보완 T01M).
> **한 줄**: Excel Form·Excel Upload 는 **DMF0082(Fcst&Price MGMT) 구현을 기본 정본**으로 하고,
> **Excel Upload 는 예외 없이 2단(2-Step)** 으로 처리한다.
> **연관**: #98(메타 배선) · #125(완료 전 셀프 검증) · #130(메타 실소비) · #133(UI 공통 축)

---

## §0 사용자 요구 원문 (2026-08-14)

> "EXCEL UPLOAD 기능이 있는 경우에는 DMF0082 의 EXCEL FORM, EXCEL UPLOAD 에서 사용한 양식을
>  기본 RULE 로 설정해주세요. … 기존에 EXCEL UPLOAD 는 **2단으로 처리**되어야 합니다. 이것도 RULE 로."

## §1 정본 (Reference Implementation)

| 축 | 정본 | 비고 |
|---|---|---|
| Excel Form 모달 | `forecast-price/components/modals/ForecastTemplateModal.tsx` | SearchArea(Div 고정) + 미리보기 Grid + [Excel Download 아이콘][Close] |
| 양식 컬럼 순수함수 | `forecast-price/utils/forecast-price.excelForm.ts` | 토큰/헤더/행 생성 계약 — **화면 독립**이라 그대로 이식 가능 |
| Excel Upload 모달 | **공용** `features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx` | 1-Step/2-Step 겸용 — `onSave` 제공 = 2-Step |
| Form SP | `PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA` | IN = **메인 조회 SP 와 동일 축·동일 이름** / OUT = `O_RC1` + `O_RESULT_CURSOR` |
| Upload SP | `PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD` (**5-arg**) | `P_MODE`(0=검증 / >0=적재) · `P_PROGRAM_ID` · `P_SHEET_NAME` · `P_CREATED_BY` · `O_RESULT_CURSOR` |

## §2 ⭐ Excel Upload = **2단 처리 의무** (예외 없음)

| 단계 | 버튼 | 동작 | SP |
|---|---|---|---|
| ① | **[Upload]** | 파일 업로드 → 스테이징 적재 → **검증·분류만** (Success/Error 건수 + Error Detail 그리드) | `${STORAGE_SQL_ID}` **`P_MODE=0`** |
| ② | **[OK]** | ①에서 **Error=0** 인 검증 통과분만 **원장 적재** | 같은 SP **`P_MODE=1`** (call-proc) |

- ⛔ **1-Step 금지** — [OK] 가 곧 업로드였던 구 방식은 검증 결과를 보기 전에 원장이 바뀐다.
- FE 계약 = `FcstUploadModal` 의 **`onSave` prop 제공**(= 2-Step opt-in). 미제공 시 구 1-Step 으로 동작하므로
  **`onSave` 누락 = 룰 위반**이다.
- ②는 `hasButton('UPLOAD_SAVE')` 배선(`{MENU_ID}/{SHEET}/UPLOAD_SAVE/call-proc`)이 있어야 한다.
- ⚠ **이중발사 가드 필수** — `disabled={state}` 는 리렌더 후에야 반영돼 같은 tick 더블클릭이 통과한다.
  `useRef` 동기 가드를 쓴다(2026-07-08 실사고: 스테이징 2배 적재 → 전량 'Duplication Key' 실패).

## §3 Excel Form (양식 다운로드) 계약

1. **양식 = 현재 화면 조회조건에 걸린 데이터** — 빈 템플릿이 아니다.
   모달은 메인 `store.filters` 를 **가공 없이** SP 로 전달한다(축·이름이 메인 GET 과 동일해야 성립).
2. 1행 = 키 조합 × 입력 가능 measure 1종. 화면 measure 개인화와 무관하게 **SP 가 LOOKUP 으로 확장**한다.
3. 값은 **업로드 검증이 기대하는 표기**로 SP 가 이미 변환해 내려준다 → **FE 콤보 변환 금지**
   (미리보기 그리드에 `cellCboDataTp` 를 달면 화면과 엑셀이 어긋난다).
4. 값 입력 컬럼(월/주차 토큰)은 **빈칸**으로 내린다(입력 전용).
5. 조회 0건 = 안내 메시지(정본 `MSG00718`). ⚠ `MSG00705`('업로드분 없음')는 **의미가 반대라 재사용 금지**.
6. ⭐ **모달 오픈 시 자동조회 없음 — [Search] 명시 게이트**(사용자 지시 2026-08-14, AS-IS 팝업류 표준).
   모달을 닫으면 rows 를 초기화해 다음 오픈은 항상 빈 양식에서 시작한다.
   ⚠ 이전 구현(오픈 시 silent 자동조회)은 **폐기** — DMF0082·DMF0014 동시 전환 완료.
7. 모달은 메인 조회 전에 열려도 동작해야 한다 — 버튼 액션에서 `filters` 미확정이면 **먼저 확정**한 뒤 연다
   (payload 는 화면에서 재조립하지 말고 **store 단일 출처**를 쓴다). DMF0014 실사고: 메인 미조회 상태에서
   Excel Form 을 열면 조회조건이 없어 아무것도 못 부르고 "조회가 되지 않습니다" 로 보였다.

## §4 ⭐ 엑셀 헤더 문자열 계약 (가장 깨지기 쉬운 지점)

BE `FileServiceImpl.cvtListUploadRows` 가 `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 토큰명으로
엑셀 헤더를 **이름 조회**한다. 따라서:

| # | 규칙 |
|---:|---|
| 1 | 토큰 문자열은 **원형 그대로** — 1바이트라도 다르면 그 열 전량 탈락(무증상 유실) |
| 2 | 토큰은 **`HEADER_CONTENT` 실측값이 유일한 정답**이다. `*` 를 떼는지 붙이는지를 **화면 간 일반화하지 말 것** — 실측 2026-08-14: DMF0082 토큰은 `*` **없음**(`Div`/`Model`)이라 라벨에서 `*` 를 떼야 맞고(`stripStar`), **DMF0014 토큰은 `*` 를 포함**(`Division*`/`Sales Site*`)해 라벨과 **문자 그대로 동일**하다. 구현 전 `SELECT HEADER_CONTENT` 로 확인한다 |
| 3 | **헤더명 중복 금지** — `ExcelUtils` 가 헤더를 HashMap 키로 써서 뒤 컬럼이 앞을 덮는다 (`dedupeHeader`) |
| 4 | `HEADER_CONTENT` 에 없는 **정보성 컬럼은 무시**되므로 자유롭게 덧붙일 수 있다 |
| 5 | 파일 내 **컬럼 순서는 무관** — ATTRIBUTE 위치는 `HEADER_CONTENT` 순서가 결정한다 |
| 6 | `HEADER_CONTENT` 토큰 n번째 ↔ 스테이징 `SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE{n}` **1:1** |

**실측 대조표 (2026-08-14)**

| 화면 | SHEET_NAME | STORAGE_SQL_ID | HEADER_CONTENT |
|---|---|---|---|
| DMF0082 | `FcstNPrice` | `PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD` | 토큰 10 + **M4~M16**(월 상대 오프셋 13) |
| DMF0014 | `FCST Upload` | `PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD` | 토큰 13(**`*` 포함** — SHEET_COLUMNS 라벨과 문자 동일) + **W27~W31**(주차 **고정 문자열** 5, 사용자 확정 2026-08-14 = 현행 호환 유지) |
| DMF0074 | `Metal Link Price` | `PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD` | 토큰 다수(금속 Key/Period 계열) |

## §5 메타 배선 5축 (하나라도 빠지면 버튼이 안 뜨거나 조용히 실패)

| # | 테이블 | 내용 |
|---:|---|---|
| 1 | `SCM_ADM_EXCEL_COLUMNS` | `PROGRAM_ID`/`SHEET_NAME`/`STORAGE_SQL_ID`(**PKG.PROC 표기**)/`HEADER_CONTENT` |
| 2 | `SCM_ADM_MNU_BTN_MPG_M` | `FORM_DATA` · `UPLOAD` · `UPLOAD_SAVE` (+선택 `UPLOAD_DATA`) ↔ API_ID |
| 3 | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 위 버튼 **권한 행** — 배선만 있고 권한이 없으면 버튼이 안 뜬다 |
| 4 | `SCM_ADM_API_M` | `{MENU}_GET_EXCEL_FORM` 등 — `API_URL` = SP 전체 표기 |
| 5 | `SCM_ADM_PROC_M` | Form SP 의 IN/OUT positional 전수 (`PROC_NM` = `PKG_x.P_x`) |

> ⚠ 2026-08-14 실사고 — 이관 패키지에서 2·3번(버튼 배선/권한)을 빠뜨려 **40 division 에서 Excel Form
> 버튼이 아예 보이지 않았다.** FE 게이트가 `division && hasButton('FORM_DATA')` 이기 때문.

## §6 버튼 배치 (hook #120 아이콘 순서와 함께)

정본 DMF0082 순서 = **Excel Form → Excel Upload → (화면 고유 버튼) → 환율 → Grid → Measure**.
Excel 2종은 `customButtons` 로 배치한다(표준 `upload` 슬롯은 customButtons **뒤**에 렌더되어 순서가 깨진다).

## §7 자기 점검 (완료 선언 전 — hook #125 연계)

```bash
# ① 2-Step 실배선 — onSave 없으면 1-Step 위반
grep -n "FcstUploadModal" -A 12 <페이지>/*.tsx | grep -c "onSave"     # 1 이상
# ② 헤더 토큰 원형 — 메타 HEADER_CONTENT ↔ FE 토큰 상수 문자열 일치
# ③ 버튼 5축 (배선/권한/API/PROC/EXCEL_COLUMNS) 존재
```
```sql
SELECT MNU_BTN_CD, API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{화면}';
SELECT MNU_BTN_CD, COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='{화면}' GROUP BY MNU_BTN_CD;          -- FORM_DATA/UPLOAD/UPLOAD_SAVE 각 1행 이상
SELECT STORAGE_SQL_ID, HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='{화면}';
```

## §7.5 ⭐ 업로드 값 검증 3종 (2026-08-18 DMF0014 실사고 계기 신설)

### (1) 입력 불가(회색) 칸에 값이 들어오면 **반려**한다
화면이 회색으로 잠근 칸은 **마스터가 잠근 것**이다(DMF0014 = `DM_MST_CUSTOMER_FCST.VALID_YN`,
주차 = `SUMMARY_BUCKET_VALUE`). Excel Form 은 `VALID_YN='Y'` 칸만 색칠하는데,
**업로드 검증에 그 대조가 없으면 회색 칸 값이 그대로 저장된다**(2026-08-18 사용자 보고).

- 검증 SP 는 헤더의 값 컬럼을 **행으로 전개**해, 값이 있는 칸이 마스터에서 허용('Y')인지 대조한다.
- 위반은 **ERROR 로 반려**(사용자 확정 A안). 조용히 버리는 무시 처리는 허위 성공이라 금지.
- 빈칸은 통과. 정본 문구 = `Invalid Upload Week. (not editable in Customer Master)`.
- ⚠ 정정 후 **오탐 회귀 검증 의무** — 허용 칸에만 값을 넣은 파일이 `Error=0` 으로 통과하는지 실측.

### (2) 숫자 칸은 **텍스트로** 내려주고, 텍스트로 입력받는다
엑셀 **숫자 셀**은 BE 파서가 `6` → **`6.0`** 으로 변환한다. 정수 검증(`INSTR(값,'.')>0` 류)이
이를 오류로 보아 **정상 입력이 반려**된다(2026-08-18 DMF0074 실측 재현: `Invalid INTEGER 0 ~ 12.`).

- Excel Form 이 만드는 양식의 해당 칸은 **문자열로 기록**한다.
- 사용자 안내(README 시트)에 "셀 서식을 숫자로 바꾸지 말 것" 을 명시한다.
- 근본 정정(BE `ExcelUtils` 정수 변환 / SP 판정 완화)은 별도 판단 항목.

### (3) 이력 표 identity 시퀀스 **재시드 확인**
이력 표를 **명시 키값으로 이관**하고 identity 시퀀스를 재시드하지 않으면, 채번값이 이미 점유된
값과 부딪혀 **다건 업로드가 항상 `ORA-00001`** 로 실패한다(2026-08-18 DMF0074:
`DM_BPS_METAL_LINK_PRICE_H` MAX 1,564 vs 시퀀스 61).

```sql
-- 진단: SEQ_LAST_NUMBER <= MAX(키) 면 결함
-- 조치: ALTER TABLE t MODIFY (col GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE));
```
클라우드 이관 패키지에는 이 **진단+재시드 SQL 을 동봉**한다(같은 이관 계보면 동일 상태일 확률이 높다).

## §7.6 재업로드(같은 파일 2회) 는 **멱등**해야 한다

| 증상 | 원인 | 조치 |
|---|---|---|
| 2회차에 `Duplication Key.` / HTTP 500 | 스테이징 배치 식별자가 **CREATION_DATE(초 단위)** 라 같은 초 업로드가 한 배치로 병합. 기존 정리 로직이 **먼저 올린 행을 남기고 새 행을 지워** 후속 조회가 `NO_DATA_FOUND` | 정리 기준을 **마지막 타이틀행 앞**으로 = 최신 업로드분만 남긴다 |
| 2회차 저장이 `ORA-00001` | 1회차가 남긴 원장 행과 이번 분이 같은 키인데 **생성시각만 달라** DISTINCT 가 못 접음 | #137 §2 — PK 기준 dedup(최신 1건 채택) |

> 완료 판정 = 같은 파일로 **업로드+저장 3회 이상 연속 성공 + 원장 행수 불변**(멱등) 실측.

## §8 적용 범위

- **Excel Upload 가 있는 전 화면**에 상시 적용. 현재 보유 = DMF0082(정본) · DMF0014 · DMF0074.
- 소급 일괄 작업은 하지 않는다 — **화면별 실제 작업 시점 적용**(hook #124 소급 정책 동일).
- ⚠ AS-IS 에 Excel Form 이 없던 화면(예: DMF0014 — AS-IS `ExcelButton()` 은 단순 그리드 export)은
  **AS-IS 파리티가 아니라 본 룰(TO-BE 표준)이 계약 원천**이다.
