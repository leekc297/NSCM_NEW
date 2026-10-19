# DMF0082 SCM_FCST 편집 — 사내 정상 / 클라우드 불가 : 원인 분석

## 신고 (2026-09-09)

> DMF0082 UI 의 SCM_FCST 수정가능 일시를 **WED, 10:00 ~ 19:00** 으로 설정하고,
> 40 DIVISION 의 **SCP Planner** 인 **dodae** 로 로그인.
> 사내는 SCM_FCST 수정 가능 확인 / 클라우드는 동일 LOOKUP 수정 후에도 **수정 불가**.

## 1. 편집 게이트 동작 원리 (사내 SP 실측)

`PKG_DMF0082` BODY — `P_DMF0082_GET_MAIN_DATA` L3541~3610 (동형 로직이 `_CURRENT` L8917~9007 에 대칭 존재)

```sql
-- ① 룩업 → GTT 적재 : 요일·시간창을 통과한 행만 남는다
INSERT INTO GTT_TEMP_INTO_GROUP_MEASURE ...
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
 WHERE A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE' AND A.VALID_YN='Y'
   AND (A.SEGMENT1 = p_user_group                       -- 세션 그룹
     OR A.SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M
                        WHERE USER_ID IN (p_user_group, p_created_by) AND USE_YN='Y'))  -- [AUTHUNION] 보유그룹 합집합
   AND A.SEGMENT2 = VA_PROGRAM_ID      -- 'DMF0082'
   AND A.SEGMENT3 = p_division_id      -- '40'
   ...
   AND (REPLACE(DAYS,' ','') IS NULL OR DAYS      = TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH'))
   AND (REPLACE(FROM_TIME,' ','') IS NULL OR FROM_TIME <= TO_CHAR(SYSDATE,'HH24MI'))
   AND (REPLACE(TO_TIME,' ','')   IS NULL OR TO_TIME   >= TO_CHAR(SYSDATE,'HH24MI'));

-- ② 그 GTT 에 메저가 있으면 'Y', 정의는 있는데 창 밖이면 'T'(잠금), 아니면 'N'
INSERT INTO GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE (MEASURE, EDIT_AUTH_YN, ...)
SELECT A.SEGMENT4
     , CASE WHEN EXISTS (SELECT 1 FROM GTT_TEMP_INTO_GROUP_MEASURE B WHERE B.MEASURE = A.SEGMENT4) THEN 'Y'
            WHEN EXISTS (... 같은 룩업에 ATTRIBUTE1(요일) 정의가 있음 ...) THEN 'T'   -- [E20260826-AUTHVIEW]
            ELSE 'N' END
```

핵심: **`TO_CHAR(SYSDATE,'HH24MI')` 와 룩업의 `'1000'`/`'1900'` 을 문자열 비교**한다.
`SYSDATE` 는 **DB 서버 로컬 시각**이다(세션·사용자 시간대 아님).

## 2. 사내 실측 (2026-09-09 14:14, ZIOUI1)

| 축 | 사내 값 | 판정 |
|---|---|---|
| A. DB 시각 | `SYSDATE`=2026-09-09 14:14:20 · `DY`=**WED** · `HH24MI`=**1414** · `DBTIMEZONE`=**+09:00** | 창 안 |
| B. 룩업 | `SCP Planner` / 40 / `SCM_FCST` / DAYS=`WED` / 1000~1900 / LIMIT=`MKT_FCST` / VALID=Y | 정상 |
| C. 그룹 | `dodae` → `SCP Planner` (1행, USE_YN=Y) | 정상 |
| D. 창 판정 시뮬 | 요일 **OK** / 시간 **OK** → `통과 → EDIT_AUTH_YN=Y` | **편집 가능** |
| F. 메저 마스터 | `SCM_FCST` DIVISION_ID 에 `40` 포함, VALID=Y | 정상 |

사내가 되는 이유가 이 표로 설명된다.

## 3. 코드 세대는 원인이 아니다 (파일 실측)

09-07 클라우드 수신본 · 09-07 발신본 v2 · 사내 현재본 3본의 편집게이트 마커를 대조했다.

| 마커 | 클라우드(09-07) | 발신 v2 | 사내 |
|---|---:|---:|---:|
| `AUTHUNION` (보유그룹 합집합) | 9 | 9 | 9 |
| `E20260819-LIMITMEAS` | 5 | 5 | 5 |
| `E20260826-AUTHVIEW` ('T' 잠금) | 3 | 3 | 3 |
| `E20260825-SCPPLOC` | 1 | 1 | 1 |
| `E20260820-MEASRULE` | 1 | 1 | 1 |
| `E20260907-LIMITMEAS-DIV` | 0 | 0 | **2** |

⇒ 편집 개방 로직은 **클라우드본에도 동일하게 존재**한다.
사내에만 있는 `E20260907-LIMITMEAS-DIV` 는 **MKT_FCST 를 더 잠그는** 방향(LIMIT 판정 범위 확대)이라,
"SCM_FCST 가 안 열린다"를 만들 수 없다. **코드 드리프트로는 이 증상이 설명되지 않는다.**

## 4. 1순위 가설 — DB 서버 시간대

시간창 비교가 `SYSDATE`(DB 서버 로컬) 기준이므로, **클라우드 DB 서버가 KST 가 아니면** 창이 통째로 어긋난다.

| 서버 시간대 | 한국 14:14 일 때 `HH24MI` | `'1000' <= HH24MI <= '1900'` |
|---|---|---|
| +09:00 (사내) | `1414` | **참** → 편집 가능 |
| +00:00 (UTC) | `0514` | **거짓** → 창 밖 → `EDIT_AUTH_YN='T'` → **편집 불가** |

UTC 라면 한국 근무시간 10~19시가 UTC 01~10시가 되어, 한국 기준 근무시간 대부분이 창 밖이 된다.
**신고 증상과 정확히 일치한다.**

> 방증: 이 패키지는 `FN_MULTY_TIME(V_USER_TIME_ZONE)`(사용자 시간대 함수)을 `_CURRENT` L7698 에서 쓴다.
> 즉 시스템은 다중 시간대를 전제로 하는데, **편집 게이트만 raw `SYSDATE`** 를 쓴다.
> AS-IS(MSSQL)는 `GETDATE()` = KST 서버였으므로 파리티가 성립했다.

### 영향 범위 (사내 전수 스윕)

`SYSDATE` 로 요일·시간창을 판정하는 지점 = **요일 6곳 + 시간 12곳 = 18곳**,
`P_DMF0082_GET_MAIN_DATA` / `P_DMF0082_GET_MAIN_DATA_CURRENT` 두 프로시저에 대칭.
서버 시간대가 원인이면 **이 18곳 전부**가 같이 어긋난다(= LIMIT 잠금 판정도 함께 틀어짐).

## 5. 2·3순위 가설 (진단으로 함께 배제)

| 순위 | 가설 | 진단 섹션 |
|---:|---|---|
| 2 | 룩업 값 미세 차이 — `SEGMENT1` 그룹명 공백 혼입, `ATTRIBUTE1` 표기(`WED` vs `Wed`/`WED ` ), `VALID_YN` | [B] `LENGTH()` 병기 |
| 3 | `dodae` 그룹 매핑이 클라우드에 없음/`USE_YN='N'` | [C] |
| 4 | 메저 마스터 `SCM_FCST` 의 `DIVISION_ID` 에 40 누락 | [F] |
| 5 | `DM_UI_EDITABLE_MEASURE` 행 부재 | [G] |

## 6. 확인 요청 — 진단 스크립트

[00_DIAG_EDITGATE.sql](00_DIAG_EDITGATE.sql) 을 **클라우드에 `SCM_MGR` 로 접속해 그대로 실행**하고 전체 출력을 회신해 주세요.
사내 실측값을 `[사내]` 로 병기해 두었으니 다른 항목만 보면 됩니다.

⚠ **한국시간 수요일 10~19시 사이에 실행**해 주세요(룩업 창 안이어야 의미가 있습니다). 실행한 한국시각도 함께 알려 주세요.

가장 중요한 두 줄은 이것입니다.

- `[A] ★ DBTIMEZONE` / `★ 시각 TO_CHAR(SYSDATE,'HH24MI')`
- `[D]` 의 `판정` 컬럼 — `FAIL(시간창)` 이면 서버 시각으로 확정

## 7. 확정 시 정정안 (미적용 — 원인 확인 후 진행)

원인이 서버 시간대로 확정되면 선택지는 셋입니다.

| 안 | 내용 | 영향 |
|---|---|---|
| **A. SP 를 KST 고정** (권장) | 편집게이트 18곳의 `SYSDATE` → `CAST(SYSTIMESTAMP AT TIME ZONE 'Asia/Seoul' AS DATE)` | DMF0082 한정. AS-IS(KST 서버) 파리티 회복. 서버 시간대 무관하게 동일 동작 |
| B. 세션 시간대 설정 | BE 커넥션에서 `ALTER SESSION SET TIME_ZONE` | ⛔ `SYSDATE` 는 세션 시간대를 따르지 않아 **효과 없음** |
| C. 클라우드 DB 시간대 변경 | `DBTIMEZONE` 자체를 +09:00 | 전 시스템 영향 — 운영 협의 필요, 본 건만으로 결정 불가 |

A 안을 택할 경우 **DMF0082 외 화면에도 같은 패턴이 있는지** 먼저 전수 스윕한 뒤 일괄 방침을 정하는 편이 안전합니다
(같은 룩업 `GET_ADMIN_GROUP_MEASURE` 를 DMF0003 등도 씁니다).

## 8. 이번 조사에서 하지 않은 것

- 클라우드 DB 직접 조회 — **접속 수단 없음** (hook #151). 본 문서의 클라우드 관련 서술은 전부 **가설**이며,
  확정 근거는 §6 진단 결과 회신 후에 생깁니다.
- SP 수정 — 원인 미확정이라 코드를 건드리지 않았습니다.
