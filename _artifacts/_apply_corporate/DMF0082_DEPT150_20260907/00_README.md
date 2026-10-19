# DMF0082 보완 (2026-09-07) — ① DEPT_ID 기준(hook #150) 적용 ② LOC 일괄 변경 삭제 오인식 정정

- 베이스: **클라우드 최신** `C:\TRANFILE\RECEIVE\PKG_DMF0082_BODY_20260907.sql` (사용자 확인 — "클라우드가 최신")
- 대상 DB: AJS `175.211.29.206:2521` (SCM_MGR)
- 사용자 요청(2026-09-07): "DEPT_ID 관련 작업과 LOC 일괄 변경 시 삭제로 인식되어 오류 메세지 발생한 부분 둘다 보완"

---

## 1. 결론 요약

| # | 항목 | 원인 위치 | 이번 조치 |
|---|---|---|---|
| ① | DEPT_ID 산출 기준 (hook #150) | `PKG_DMF0082` | **PKG 보완** — 클라우드 베이스에 DEPT_ID 편집 6블록 이식 |
| ② | LOC 일괄 변경이 **삭제로 오인식** | **FE 2곳** | **FE 보완** — PKG 는 AS-IS 파리티로 **변경 없음**(근거 §3) |

---

## 2. ① DEPT_ID (hook #150)

클라우드 원본에는 hook#150 마커가 **0건** — DEPT_ID 룰 미적용 상태였다.
로컬(2026-09-06 적용본)과 클라우드의 기능 차이는 실측상 **아래 둘뿐**이었다(그 외 diff 는 전부 trailing whitespace, `diff -w` 확인).

| 방향 | 내용 | 병합 결과 |
|---|---|---|
| local 에만 | hook#150 DEPT_ID 편집 **6블록** | 이식 |
| cloud 에만 | `[E20260902-81SCMFCST]` SCM_FCST 추가 **4곳** + 헤더 | 유지 |

병합 후 마커 실측 (DB `USER_SOURCE`):

```
hook#150 = 46 / E20260902-81SCMFCST = 4 / E20260901-STATELESS = 6
PACKAGE / PACKAGE BODY = VALID · USER_ERRORS 0 · 신규 INVALID 0
```

**신규 MAX 룰 게이트** (hook #150 §3 — (DIV,SITE) grain 은 `MAX(DEPT_ID)` 로 키당 1건):

```
python _artifacts/_diagnostics/dept_id_join_grain_scan.py PKG_DMF0082
  대상 1 · LIVE 참조 23 — PARTIAL=12 / PK=11
  G150-3 : PASS (VIOLATION 0)
```

→ PKG_DMF0082 의 DEPT 산출 지점은 전부 PK(4키) 또는 등가 grain 이라 MAX 대상 지점이 없다.

## 3. ② LOC 일괄 변경 삭제 오인식 — **PKG 변경 없음** (근거)

### 신고 증상 (재현 완료)
```
MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.
● Sales Site : ABS_US_LRP / ● Model : MCCM348018A3
```
재현 스크립트로 문구까지 동일하게 재현했다(§5).

### SP 는 AS-IS 파리티다 — 그래서 건드리지 않는다
`P_DMF0082_SAVE_MAIN_DATA` 의 ACTION 판정(클라우드 L13150~13163)은
`PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME` 으로 **부분주 단위 합계 0 = 삭제**로 본다.
이는 AS-IS 그리드 버킷이 **월경계로 쪼갠 부분주**(`W_`+yyyymm+주차, 팝업은 `'W_'||MIN(BASIS_START_DATE)`
= 부분주 자체 시작일 — 실측 W40A=20260928 / W40B=20261001)인 것과 정확히 일치한다.
**여기를 바꾸면 정상 삭제가 동작하지 않는다** → 변경하지 않는다.

### 진짜 원인 = FE 2곳 (둘 다 AS-IS 에 없는 TO-BE 단독 결함)

**D1. `allocateLoc` — 월요일 없는 부분주를 전 일자 0 으로 (주원인)**
`features/demand/src/pages/forecast-price/components/ForecastPriceGridUtils.ts`
`weekMap` 은 부분주 단위로 D_ 를 담는데, 구 코드는 `dow === MON_IDX` 인 셀에만 값을 넣었다.
뒷쪽 부분주(W40B 등)에는 월요일이 없어 **전 일자가 0** → SP 가 'D' 로 뒤집음.
실측: 52주 구간에 월요일 없는 부분주 **10개**(W40B/W44B/W49B/W53B/W13B/W17B/W22B/W26B/W30B/W35B).
→ **`locWeekAnchor`** 신설: 월요일, 없으면 그 부분주 첫 일자. `W_`/`M_` 양쪽 적용.
   동일 폴백이 `@shared` `distributeWeekToDays`(수량 축)에는 이미 있었다 — 단가 축에만 빠져 있었다.

**D2. `SavePricePeriodModal` — AS-IS 사문(dead code)을 살려 'D' 전송**
`.../components/modals/SavePricePeriodModal.tsx`
구 코드 `activeFlag = qty === '0' ? 'D' : 'M'` 은 AS-IS `stempAction` 을 "의도" 로 읽어 살린 것.
AS-IS 원문 실측(`DMF0082_SaveSalesFuturePrice_Popup.cs`):

| 라인 | 내용 |
|---|---|
| 1752 | `stempAction` 선언 |
| 1756 | `stempAction = "D"` 대입 |
| — | **이후 읽는 곳 없음** |
| 1763 | 실제 전송 = `param_active_flag` (그리드 Action 원본) |
| 1930 | `stempAction` 을 전송에 쓰는 유일한 코드 — **주석 블록 안** |

→ **항상 `'M'`** 으로 정정. 'D' 재판정은 SP 가 한다(해당 파일의 기존 주석 규약과 동일). hook #138.

## 4. 적용 순서

```bash
# 적용
python _artifacts/_diagnostics/ora.py exec _artifacts/_apply_corporate/DMF0082_DEPT150_20260907/01_APPLY/01_PKG_DMF0082.sql
python _artifacts/_diagnostics/ora.py errors PKG_DMF0082      # 0 행
python _artifacts/_diagnostics/ora.py invalid                  # 신규 0

# 게이트
python _artifacts/_diagnostics/dept_id_join_grain_scan.py PKG_DMF0082           # G150-3 PASS
python _artifacts/_diagnostics/dept_id_join_grain_scan.py --file 01_APPLY/01_PKG_DMF0082.sql   # 배포 전 파일 검사
```

**원복**: `00_BACKUP_ASIS/01_PKG_DMF0082.CLOUD_ASIS.sql` (클라우드 수신 원본 그대로 + `/`) 을 동일 방법으로 실행.

## 5. 재현·검증 산출물
- 재현: `90_VERIFY/repro_locweek.py` (GTT 세션 스코프 — 원장 무영향, rollback)
- 부분주 실측: `90_VERIFY/02_PARTIAL_WEEK.txt`
- grain 스캔: `90_VERIFY/03_GRAIN_SCAN.txt`

## 6. ⚠ 이번 변경과 무관한 **기존 결함** (보고만)
`P_DMF0082_GET_MAIN_DATA` / `_CURRENT` 가 합성 파라미터 호출 시 **`ORA-00904: "SORT_KEY"`** 로 실패한다.
**클라우드 원본에도 동일**하며 2026-09-06 하네스에서도 같은 증상이 기록되어 있다(= 이번 적용으로 생긴 회귀 아님).
개인화 컬럼셋(`DEFAULT_FLAG=' '` 조건, L7111~7112 주석 참조) 조건에 따라 `V_COLUMN` 에 `SORT_KEY` 가
빠지면 `ORDER BY SORT_KEY` 가 깨지는 구조로 보인다. **실화면 파라미터에서의 재현은 미확인** — 별도 지시 시 착수.
