# DMF0082 조회 GTT DELETE 비용 — 등가성 분석 · 클라우드 진단 (2026-10-14)

- 기준 원문: 사내 ZIOUI1 (SERVER_HOST=localhost) `PKG_DMF0082` BODY LAST_DDL 2026-10-14 13:39 · 17,256줄 · FETCHED 14:13
- 상태: **분석·진단 SQL 작성까지. SP 수정 없음.** 클라우드 G01 결과를 받은 뒤 #129 0-b를 판정하고 수정 여부를 결정한다.

## 1. 사내 실측 (V$SQL)

| 구분 | 1회 소요 | 1회 행수 |
|---|---|---|
| 판가 스테이징 INSERT (`SCM_MST_FUTURE_PRICE` ONEREAD, 81 Project 지정 4회) | 2.09s | 161,346 적재 |
| Project 필터 DELETE `NVL(PROJECT_CODE,' ') NOT IN` | 0.86s | 146,844 삭제 (91%) |
| Unit Price 보조메저 DELETE | 0.22s | 31,762 |
| SCM Site 필터 DELETE (`TEMP_SITE_ITEM_ALL`) | 0.11s | 29,940 |
| WHERE 없는 초기화 DELETE 18개 합 | 0.013s | — |

- 분류별 합(G01 [G3]): 초기화 0.013s · 필터 DELETE 0.98s · 기타 DELETE 0.24s · INSERT/MERGE 6.1s.
- 최근 4시간 ASH(G01 [G4]): DELETE가 PKG 활성 시간의 14%, INSERT가 62%.
- 사용 비율: 사내 45일 동안 조회 940건 중 Project·Owner·Team 지정은 23건(2.4%)이다. **선행축소 효과는 지정 조회에만 해당한다.**

## 2. 등가성 분석 — 필터를 스테이징 앞으로 옮길 수 있나

| 점검 대상 | 결과 |
|---|---|
| 스테이징 INSERT 22개 arm (L1406~L3224) | 전부 `INNER JOIN GT_DMF0082_TEMP_SITE_ITEM C ON (DIV, PROJECT, SITE, ITEM)`. PROJECT_CODE는 키, OWNER·DEPT_ID는 `C.OWNER`·`C.DEPT_ID` |
| arm 안 GROUP BY·윈도 | 전부 PROJECT_CODE 포함 (KEEP 18곳, L1833~1834 PARTITION 포함) |
| CURRENCY MERGE 1차 L3234 | 키에 PROJECT·PLANT 포함 → 안전 |
| CURRENCY MERGE 2차 L3274 | 키에 PROJECT·PLANT 포함 → 안전 |
| **CURRENCY MERGE 3차 L3328** | **키 = DIV+SITE+ITEM+DOM_EXP+FCST_TYPE (PROJECT·PLANT 없음)**. 다른 프로젝트의 LOC 통화로 채우는 것이 설계 의도(주석: 수요 Varta / 단가 VARTA(Vacuum)). `HAVING COUNT(DISTINCT CURRENCY)=1` 판정에도 다른 프로젝트 행이 들어간다 |
| Unit Price INSERT L3368 / SP L3466 | 키에 PROJECT·PLANT 포함 → 안전 |
| 보조메저 DELETE L3652 · SCM Site L3672 | 행 단위 → 안전 (L3672는 L1003과 중복이라 0행) |
| L3226 이후 TEMP_SITE_ITEM 참조 | 없음 |

### 결론
- **정확 필터를 앞으로 옮기면 등가가 아니다.** 3차 MERGE의 CURRENCY 값이 달라질 수 있다. Project·Owner·Team 모두 해당한다(Owner·Team은 SITE_ITEM 키, 즉 프로젝트 단위 속성이기 때문).
- **완화 선행축소는 구조상 등가다.** 선택된 SITE_ITEM 행의 (DIV, SCM_SITE_ID, ITEM_ID)를 가진 행은 프로젝트가 달라도 `TEMP_SITE_ITEM`에 남긴다. 기존 L3692/L3699/L3724 DELETE는 그대로 둔다.
  - 근거: L3692 이전에 남은 행의 값을 계산하는 모든 문장은 같은 (DIV, SITE, ITEM) 안의 행만 참조한다. 3차 MERGE가 가장 넓은 범위인데, 그 범위가 바로 (DIV, SITE, ITEM)이다.
  - Owner·Team 판정은 `TEMP_SITE_ITEM`(MAX 집계 후) 값으로 하고, `NVL(x,' ')`와 토큰 비교 의미를 그대로 따라야 한다. 스테이징 행이 실제로 갖는 값이 이것이기 때문이다.
  - Plant·Sender는 원장 컬럼이고 SITE_ITEM 속성이 아니므로 대상에서 제외한다. Plant는 3차 MERGE 키에도 없다.
- 사내 81 효과 근사(판가 원장 행수): 전체 190,317~428,193 → 정확 필터 0~11,970 / **완화 0~12,330**. 완화 방식은 정확 필터보다 최대 15% 정도 더 남긴다.
- **미검증 항목**: 완화안을 실제로 실행해 전/후 결과를 비교하지 않았다(SP를 수정하지 않았기 때문). 채택 전에 #129 §12.1 전행 해시를 대조해야 한다. 조합은 40/81/82 × Project·Owner·Team 지정/미지정 × 버전 4종이다.

## 2-b. 클라우드 QA 1차 결과 (OCGSCMQ_P01, BODY LAST_DDL 10-14 13:46, 17,256줄 — 사내와 같은 줄 수)

| 문장 | 1회 소요 | 1회 행수 | 비고 |
|---|---|---|---|
| Project 필터 DELETE L3692 | **1.438s** | 216,449 | 커서 캐시 54회 중 19회(35%) 실행 |
| 판가 INSERT L1676 (d019r0hbb0muh) | **2.115s** (2회는 5.8s) | 180,591 (312,104) | |
| 초기화 DELETE `GT_DMF0082_MF_SP` L4204 | 0.328s | 49,837 | **이전 호출이 남긴 행** — 커넥션 풀 세션 재사용 |
| 초기화 DELETE `GT_DMF0082_TEMP_FCST_N_PRICE` L1397 | 0.322s | 49,837 | 위와 같음 |
| 초기화 DELETE `TEMP_SITE_ITEM_ALL` / `TEMP_SITE_ITEM` | 0.061 / 0.059s | 9,691 | 위와 같음 |
| 초기화 DELETE 합 ([G3]) | **0.814s** | | 사내 측정(매번 새 세션)에서는 0.013s로 드러나지 않았다 |
| 조회조건 필터 DELETE 합 ([G3]) | 1.572s | | |
| GET 1회 평균 | 6.7s | | |
| AWR 일자별 DELETE 비중 ([G5]) | 0~23% | | 10-12 23.4% |

- [G4]·[G6]·[G7]은 1차 실행에서 치환변수 `&MIN`/`&DAYS`가 바인드로 처리돼 ORA-01008이 났다. 리터럴로 고친 `G02_RERUN_G4_G6_G7.sql`로 재실행해야 한다(G01도 같이 수정).

### 정정 — 트랜잭션 단위 GTT
- 처음에 "효과 약 0.01초"라고 판단한 근거는 사내 측정이었다. 클라우드에서는 커넥션 풀 세션에 **이전 호출의 행이 남아 있어** 초기화 DELETE가 호출당 0.81초다.
- 반환 커서가 읽는 GTT는 `GT_DMF0082_MF_SP`(O_RC1)와 `GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE`(O_RC4) 두 개뿐이다. 이 둘은 세션 단위를 유지해야 한다(ORA-08103).
- 나머지 중간 GTT는 `P_DMF0082_GET_MAIN_DATA`만 쓰고, 그 안에는 COMMIT·동적 DDL이 없다(예외 처리부 ROLLBACK만 있음). 대상은 `TEMP_FCST_N_PRICE`·`TEMP_SITE_ITEM(_ALL)`·`MST_ITEM_SINGLE_*` 등이다. 이들을 `ON COMMIT DELETE ROWS`로 바꾸면 BE autocommit 시점에 세그먼트째 해제되어 **호출당 약 0.48초**의 초기화 DELETE가 사라진다(추정, 미실행).
  - 비용: 기간(DURATION) 변경은 DROP+CREATE가 필요하다. 그 결과 인덱스·권한·시노님 재생성, PKG 재컴파일이 필요하고, 사용 중인 세션이 있으면 ORA-14452가 나므로 BE 정지 창이 필요하다. 사내·클라우드 모두 현재 GTT 통계 설정(PREFS)이 비어 있다.
- `TEMP_UNDO_ENABLED`는 L248에서 이미 세션 단위로 켜고 있다(E20260907-PERF2).

## 2-c. 클라우드 QA 2차 결과 (G02, 14:52)

- [G4] ASH 최근 240분: INSERT 69.8% · **DELETE 12.9%(36초)** · MERGE 8.3% · SELECT 7.9%. DELETE 36초 중 **L3692 Project 필터가 26초(72%)**, 초기화 DELETE는 약 8초.
- [G6] 45일 조회 1,334건:

| 사업부 | 조건 | 건수 | 중앙값(초) |
|---|---|---|---|
| 40 | 미지정 | 610 | 18 |
| 40 | SalesSite | 186 | 3 |
| 40 | Team | 17 | **58** (DELETE 비용 0.03초라 원인 별도 — 미확인) |
| 81 | 미지정 | 359 | 18 (평균 121, 최대 9,479 = 10-09 타임아웃) |
| 81 | **Project** | 21 | **10** |
| 81 | **Project+SalesSite** | 23 | **2** |
| 82 | 미지정 | 24 | 25.5 |

  - SalesSite는 이미 `TEMP_SITE_ITEM_ALL` 단계에서 필터된다(L1003). 그래서 같은 Project 조회라도 SalesSite를 함께 주면 2초, Project만 주면 10초다. **선행축소 효과를 실데이터로 보여 주는 근거다.**
  - 선행축소 대상(Project·Owner·Team 지정)은 70건(5.2%)이다. 그중 Project 단독 22건이 주 대상이다.
- [G7] 클라우드 81 판가: 전체 210,714~240,699 → 정확 0~12,570 / **완화 0~12,570**(최대 전체의 6%). 완화안이 정확 필터보다 더 남기는 양은 0~1,881행이다.

### 판정 (#129 0-a/0-b)
- A(완화 선행축소): 대상 호출(Project 단독, 중앙값 10초)에서 판가 INSERT 2.1초 + 필터 DELETE 1.4초가 병목으로 실측됐다. **착수 조건을 충족한다.** 단, 전체 호출 중 비중은 약 1.7~5%다.
- B(중간 GTT 트랜잭션 전환): 모든 호출에서 약 0.48초(중앙값 18초의 약 3%)를 줄인다. DDL 재생성과 BE 정지 창이 필요해 비용 대비 효과가 낮다. **보류를 권장한다.**
- 미지정 조회(전체의 90% 이상, 중앙값 18초)의 병목은 DELETE가 아니라 INSERT(ASH 70%)다. 같은 시점에 측정한 GET 평균은 6.7초인데 화면 기준은 18초라, SP 밖(fetch·직렬화) 비중일 수 있다. 다만 측정 기간이 달라 단정할 수 없다. **이번 범위 밖이며 별도 측정이 필요하다.**

## 3. 클라우드 진단 — `G01_GTT_DELETE_COST.sql`
- READ-ONLY, 전체 F5 가능. 사내에서 파이썬 F5 모사로 13문장 오류 0을 확인했다(SQL*Plus 미설치).
- [G0] 환경·BODY 상태 · [G0b] 필터 DELETE 라인 위치 · [G1] DELETE 문장별 비용 · [G2] 스테이징 INSERT 비용 · [G3] 분류별 합 · [G4] ASH DELETE 비중 · [G5] AWR 일자별 DELETE 비중 · [G6] 조회조건 사용 비율·소요 · [G7] 실조회 Project의 정확/완화 행수
- 판정 기준: [G3]의 "2 DELETE 조회조건 필터" + [G2]의 판가 INSERT가 2초를 넘고, [G6]의 지정 조회 비율이 의미 있으면 완화 선행축소를 진행한다. 아니면 이번 범위에서 제외한다(#129 0-a).
