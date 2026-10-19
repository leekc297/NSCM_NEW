# DM_PLN_MKT_FCST — BALANCE·SYSTEM 메저 PLANT_SITE_ID '/'·' ' 혼재 원인 (2026-10-12, 진단만 · 수정 없음)

> 원문 기준: 사내 ZIOUI1 `USER_SOURCE` 2026-10-12 15:53 새로 조회 (`_src_corp/`, [d01_dump_src.py](d01_dump_src.py)). AS-IS = LGCE_SCMDEV DB 직접 조회.

## 결론

| 항목 | 내용 |
|---|---|
| 원인 문장 | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` 의 `CASE WHEN ORIGIN_DIVISION_ID IN ('82','40') THEN ' ' ELSE PLANT_SITE_ID END` **6곳** (SCP RTF 배분 결과를 RTF 계열로 적재하는 3개 SELECT 의 SELECT 절 + GROUP BY 절) |
| 왜 ' ' 인가 | AS-IS 는 같은 6곳이 `THEN ''` (빈 문자열). Oracle 은 `''` = NULL 이라 이관 때 `' '`(공백)로 바꿨다 |
| 왜 '/' 작업 뒤에 갈라졌나 | '/' 전환은 `'-'` 리터럴·테이블 기본값·원장 데이터를 '/' 로 바꿨지만 **`' '` 리터럴은 대상이 아니었다**. 수요 쪽(MKT_FCST·SCM_FCST)은 '/' 가 됐고 RTF 쪽만 ' ' 로 남았다 |
| BALANCE 가 +/− 두 행인 이유 | BALANCE = RTF_SCP 누계 − MKT_FCST 누계를 **PLANT_SITE_ID 포함 키별**로 계산한다. '/' 키는 수요만 있어 −100만, ' ' 키는 RTF 만 있어 +100만 (제시 사례와 일치) |
| 사내 현재 상태 | 10-11 POJ 가 6곳을 `'/'` 로 수정 (LAST_DDL 10-12 15:39). 현재 원문에 ' ' 상수 0곳 |
| 클라우드 | '/' 전환 이관 패키지(`_apply_corporate/SLASH_DBOBJ_20261008/03_CLOUD_APPLY_sqlplus/`)의 같은 SP 에는 **' ' 6곳이 그대로** 있다. 클라우드가 이 세대면 원인 확정 — [P01](P01_SP_GENERATION.sql) 로 확인 |

## 데이터가 만들어지는 경로 (40 기준, 사내 원문 줄 번호)

| 단계 | SP · 줄 | 메저 · 작성자 | PLANT_SITE_ID 에 들어가는 값 |
|---|---|---|---|
| 1 수요 동기화 | `PR_DM_PLN_CFM_TO_MKT_FCST_ALL` L59~69 | MKT_FCST·SCM_FCST·VMI_In_Req · BATCH_CFM_TO_ALL | `DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID` 그대로 → 원장이 '/' 이면 '/' |
| 2 RTF 스테이징 | `…QTY_BALANCE_CREATE` L1818~1846 → `GT_PRDM2_MKT_FCST_INSERT` | RTF_SCP(·VMI_In_Plan·AS_In_Plan) · SYSTEM | **40/82 는 상수** — 구판 `' '` / 현재 사내 `'/'` (L1829, L1845) |
| 2' CFM 스테이징 | 같은 SP L1896~1961 → `GT_PRDM2_CFM_DEMAND_INSERT` | 같음 | 같은 상수 (L1911, L1927) |
| 3 RTF 본적재 | 같은 SP L2093~2162 → `DM_PLN_MKT_FCST` | RTF_SCP → RTF_SYS_RP · RTF_PR 복제 · SYSTEM | 스테이징 값 그대로 |
| 4 대상 키 수집 | 같은 SP L1570~1603 → `GT_PRDM2_RESULTS` | — | 수요 원장 표기 ∪ RTF 배분 상수(L1591, L1603) → 표기가 다르면 **키 2개** |
| 5 BALANCE | 같은 SP L2787~2870 | BALANCE · BALANCE_MAKE | 4의 키별로 계산 → 표기마다 한 행 |

- BALANCE 계산식 (L2836~2841): `SUM(MKT_FCST 외 누계) − SUM(MKT_FCST 누계)`, GROUP BY 에 PLANT_SITE_ID 포함.
- BALANCE 삭제 (L2843~) 는 계산 대상 키(PLANT_SITE_ID 포함)와 일치하는 행만 지우고, 삽입 (L2862~) 은 `ACCUM_X <> 0` 만 넣는다. 대상 키 수집(L1570~)이 기존 BALANCE 행의 키도 포함하므로, SP 를 '/' 세대로 바꾼 뒤 재실행하면 ' ' 키는 RTF 가 0 이 되어 BALANCE 가 삭제만 되고 다시 생기지 않는 것으로 읽힌다. **실행 검증은 하지 않았다 (원문 판독)**.
- 테이블 기본값: `DM_PLN_MKT_FCST` · `DM_PLN_CFM_MKT_DEMAND_PLAN` 의 PLANT_SITE_ID DEFAULT ON NULL = `'/'`. 값을 `''`(NULL)로 넣는 문장은 '/' 가 되고, `' '` 를 명시한 문장만 공백으로 남는다. 중간 GTT 7종은 기본값 없음.

## 사내 데이터 실측 (DM_PLN_MKT_FCST, 40, 당주 이후 — P02 B1)
| 메저 | 표기 | 행수 | 작성자 · 수정일 |
|---|---|---|---|
| MKT_FCST · SCM_FCST · MKT_FCST_LATEST | `-` | 7,988 ~ 7,996 | BATCH_CFM_TO_ALL 10-11 |
| RTF_SCP · RTF_SYS_RP · RTF_PR | `/` | 각 3,965 | FILLFIX20261012 10-12 |
| BALANCE | `' '` | 194,277 | BALANCE_MAKE 10-09 |
| BALANCE | `-` | 224,768 | BALANCE_MAKE 10-09 (일부 08-25) |

- 사내도 같은 구조로 갈라져 있다. 10-09 BALANCE 실행 때 수요는 '-'(사내 원장은 아직 '/' 미전환), RTF 는 ' ' 여서 BALANCE 가 ' ' 와 '-' 두 벌로 생겼다.
- 10-12 에 RTF 계열이 '/' 로 다시 적재됐지만(작성자 `FILLFIX20261012`, 타 작업자 작업) 사내 수요는 '-' 그대로라, **사내는 지금 '-' 대 '/' 로 여전히 어긋난다**. BALANCE 를 다시 돌려도 두 벌이 된다.
- 즉 SP 상수만 '/' 로 맞추는 것으로는 부족하고, **수요 원장 표기와 RTF 상수가 같은 값**이어야 한다 (클라우드는 수요 '/' 이므로 SP 가 '/' 세대면 맞는다).

## AS-IS 대조 (DB 직접)
- `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` L916·930·1330·1355·1462·1483 = `THEN ''`. TO-BE 6곳과 1:1.
- AS-IS 데이터도 40 의 PLANT_SITE_ID 는 빈 문자열. 수요·RTF 양쪽이 같은 값이라 갈라지지 않는다.

## 같은 유형이 더 있는지 (사내 현재 원문 전 객체 검색)
- `THEN ' ' ELSE …PLANT_SITE_ID` : **0곳** (사내). 이관 패키지 세대에는 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` 6곳 + `PR_DM_PLN_MKT_FCST_TO_NET_DEMAND` 에 존재.
- `'' AS PLANT_SITE_ID` : `PR_DM_SSP_CONFIRM_SYNC` L188·L685, `PKG_SCM0002` L4558·L4742, `PKG_DMF0044` L9194, `PKG_SCP0027` L210~211 — NULL 이므로 대상 테이블 기본값('/')을 탄다. 혼재 원인은 아니다.

## 미확정 · 한계
- P02 는 사내에서 **전 문장 구문 검증(EXPLAIN PLAN) 통과**, 전체 실행은 사내 DB I/O 포화(타 세션 다수, 차단 4건)로 B1 까지만 완료(`_corp_P02_out_v1_partial.txt`). B2~B5 실행 결과는 미확인.
- 클라우드 SP 세대는 미확인 (P01 결과 필요).
- 사내 `PKG_DMF0082` BODY · `PKG_DMF0003` BODY · `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH` 가 15:53 시점 **INVALID** (타 작업자 당일 수정의 의존성 무효화로 추정, 미조치).

## 클라우드 확인 쿼리 (READ-ONLY · 전체 F5 · 값 입력 없음)
| 파일 | 보는 것 | 사내 검증 |
|---|---|---|
| [P01_SP_GENERATION.sql](P01_SP_GENERATION.sql) | A1 SP 세대 · A2 ' ' 상수 문장 · A3 그 밖의 빈값 문장 · A4 테이블 기본값 | 오류 0 |
| [P02_DATA_MIX.sql](P02_DATA_MIX.sql) | B1/B2 메저×표기×작성자 · B3 갈린 키 수와 BALANCE 상쇄 쌍 · B4 사례 키 · B5 SP 실행 이력 | 구문 검증 통과 · B1 실행 완료 · B2~B5 실행 미확인 |

## 수정 방향 후보 (제안만 — 미착수)
1. 클라우드 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` 를 ' ' → '/' 6곳이 반영된 세대로 올린다 (사내 POJ 10-11 수정분. 타 작업자 소유 변경이므로 이관 주체 확인 필요).
2. 이미 적재된 ' ' 행 — RTF 계열은 SP 재실행 시 전량 삭제 후 재적재되고, BALANCE 도 원문상 재계산으로 정리될 것으로 읽힌다. 다만 실행 검증 전이므로, 적용 뒤 [P02](P02_DATA_MIX.sql) B1·B3 으로 ' ' 잔존 0 을 확인하고 남으면 정리 문장을 따로 만든다.
3. `PR_DM_PLN_MKT_FCST_TO_NET_DEMAND` 등 같은 세대 SP 동반 확인.
