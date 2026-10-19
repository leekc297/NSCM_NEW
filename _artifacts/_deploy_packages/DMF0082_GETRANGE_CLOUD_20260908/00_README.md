# DMF0082 — 50주 이후 구간 조회/저장 개방 (클라우드 이관, 2026-09-08)

마커 **`[E20260908-GETRANGE]`** · 사내 적용 완료(2026-09-08 13:26, VALID/에러 0) · 사용자 저장 확인 완료

## 1. 이관 대상 — **DB 1건뿐**

| # | 파일 | 대상 객체 | 유형 |
|---|---|---|---|
| 1 | `A_DB/01_PKG_DMF0082_BODY.sql` | `SCM_MGR.PKG_DMF0082` **PACKAGE BODY** | CREATE OR REPLACE (전체본) |

- **PACKAGE SPEC 이관 불필요** — 시그니처 무변경(LAST_DDL 2026-08-25 그대로).
- **FE 변경 없음** · **메타(MSG/LBL/MNU/EXCEL_COLUMNS 등) 변경 없음** · **GTT/TYPE/GRANT 변경 없음**.
- 조회기간 2년 제한은 **차후 UI 에서 처리**(사용자 지시 2026-09-08) — 본 패키지 범위 밖.

## 2. 변경 내용 (2줄)

`P_DMF0082_GET_MAIN_DATA` L437 · `P_DMF0082_GET_MAIN_DATA_CURRENT` L7371 의 `V_EXP_YYYYMMDD` 대입:

```sql
-- 구: 조회시작일 + 50주 에서 D_(일자) 버킷이 잘림
V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd,'YYYYMMDD') + (50*7), 'YYYYMMDD');
-- 신: 조회종료일까지 확장 (GREATEST 로 구 하한 보존 = 짧은 구간 비회귀)
V_EXP_YYYYMMDD := GREATEST(TO_CHAR(TO_DATE(p_from_yyyymmdd,'YYYYMMDD') + (50*7),'YYYYMMDD')
                         , p_to_yyyymmdd);
```

원인: `C_BUCKET` 커서에서 `W_`(주차)·`M_`(월)은 `p_to_yyyymmdd` 전 구간을 만드는데 **`D_`(일자)만 50주 상한**이었다
(데이터 스테이징 L3886 도 동일 상한). → 50주 이후는 **헤더는 생기는데 값이 안 내려오고**, 그 구간에 LOC 를 입력하면
일자 셀이 0 으로 남아 저장 SP 의 부분주 합계 판정이 `ACTION='D'` 로 뒤집혀 검증 #18 이 발동 → 저장 차단.

⭐ **52주 저장 RULE(#1 판가수집 / #10 52주 판가 필수 / #18 삭제 시 52주 FCST 확인)은 무변경** — AS-IS 와 1:1 유지.

## 3. 사내 실측 (2026-09-08)

| 조회구간 | 총 PIVOT 컬럼 | D_ | D_ 최대일자 | 결과 |
|---|---:|---:|---|---|
| 6개월 (~20270302) | 415 | 351 | 20270817 (=from+50주) | 종전과 동일 — **비회귀 확인** |
| 1년 (~20270901) | 468 | 366 | **20270901** | 구 상한 초과 D_ 15컬럼에 **값 5,842셀 / 2,380행** 실재 |
| 2년 (~20280831) | 905 | 731 | **20280831** | 정상 |
| 3년 (~20290831) | — | — | — | ⛔ **실패** (아래) |

## 4. ⚠️ 3년 구간 한계 (실측)

```
ORA-20001: [PKG_DMF0082] ORA-22828: input pattern or replacement parameters
           exceed the 32K size limit of SQL function
```
동적 PIVOT SQL 문자열이 32K 한계를 넘어 **조회 자체가 실패**한다(예상했던 ORA-01792(컬럼 1000)보다 먼저 걸린다).
**2년까지는 정상**이므로, 차후 UI 기간 제한은 **2년**이 실측 근거를 갖는다.

성능 참고(사내, 세션 재사용): 6개월 13.0s / 1년 37.8~183.7s / 2년 50.4s — 구간이 길수록 느려지고 편차도 크다.

## 5. 적용 절차

1. `A_DB/01_PKG_DMF0082_BODY.sql` 실행 (CREATE OR REPLACE PACKAGE BODY)
2. `04_VERIFY/01_verify.sql` 로 STATUS=VALID · ALL_ERRORS 0행 · 마커 2행 확인

## 6. ⚠️ 전체본 교체이므로 반드시 확인할 것

본 파일은 **사내 PKG_DMF0082 BODY 전체**다. 클라우드가 사내보다 뒤처져 있으면 그 사이의 사내 선행 변경이 **함께** 적용된다.
사내 BODY 에 실재하는 최근 마커(2026-08 이후, 실측):

```
E20260805-AFS(14) E20260806-DS2 E20260812-DS2(4) E20260812-PERF(6) E20260812-PERF-NOSTATS(15)
E20260813-EXCELFORM E20260813-UPLOADSAVE(10) E20260814-CURMEASURE E20260814-FCSTNAME(2)
E20260815-PERF(2) E20260815-PERF2 E20260815-SPLIT2GTT(4) E20260818-PRICECHK1 E20260818-UPLOADBATCH
E20260819-LIMITMEAS(5) E20260819-MULTIJOIN(10) E20260819-PJTNAME(4) E20260819-SENDERJOIN(5)
E20260819-XLS81LOC(16) E20260820-AFSNULL(11) E20260820-MEASRULE E20260820-SENTINELDDL(11)
E20260820-XLSSAVEPERF(2) E20260820-XLSWEEKLY(8) E20260822-DIV81DEL(2) E20260822-KEYCOL(2)
E20260822-LOCWEEKSUM E20260825-81AUTH(5)
```

이관 전 클라우드에서 아래로 대조해 **미적용 마커가 있으면 그 변경의 동반 메타/의존 객체도 함께 이관**해야 한다
(예: `E20260820-SENTINELDDL` 은 DDL 동반, `E20260819-XLS81LOC`/`E20260820-XLSWEEKLY` 는 `SCM_ADM_EXCEL_COLUMNS` 메타 동반).

```sql
SELECT MARKER, COUNT(*) FROM (
  SELECT REGEXP_SUBSTR(TEXT,'E20[0-9]{6}-[A-Z0-9-]+') MARKER FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY')
WHERE MARKER IS NOT NULL GROUP BY MARKER ORDER BY MARKER;
```

## 7. 원복

`_artifacts/_apply_corporate/DMF0082_GETRANGE_20260908/BACKUP_PKG_DMF0082_BODY_20260908_131150.sql` 를 그대로 실행.
