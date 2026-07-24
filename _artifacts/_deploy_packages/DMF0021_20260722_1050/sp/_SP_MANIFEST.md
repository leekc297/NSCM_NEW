# DMF0021 SP/PKG 매니페스트 (사내 OCGSCMD_P01 실측 DDL — 2026-07-21)

> `DBMS_METADATA.GET_DDL` 전수 추출(CREATE OR REPLACE). 스키마 SCM_MGR. 배포 = PKG(SPEC→BODY) 우선, standalone 순서 무관.

## PKG
| 파일 | 객체 | 설명 |
|---|---|---|
| `PKG_DMF0021_SPEC.sql` | PKG_DMF0021 (SPEC) | 패키지 스펙 |
| `PKG_DMF0021_BODY.sql` | PKG_DMF0021 (BODY) | 패키지 본문. [PJ2025-50188] FROM_SITE_ID(ATTRIBUTE2) 저장 로직 보유. |

## Standalone SP (wired — API_M 배선분)
| 파일 | 버튼/용도 | 설명 |
|---|---|---|
| `DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX.sql` | Sales Plan SEARCH (main) | 17 IN + 3 커서(data/calendar/editAuth). ⭐ [E20260512] FROM_SITE_ID 출력(L1575-76) + [E20260715] DEFAULT_FLAG `NVL(,'N')<>'Y'` 교정(''=NULL 함정) 반영본. |
| `DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL.sql` | Sales Plan SAVE | 16키 '^' bulk. p_cell_prod_site_id 로 81 FROM_SITE_ID 수신(FE 치환). Red-변경셀 저장·주→일 분배 SP 내부. |
| `DMF0021_GET_SALES_PLAN_MEASUREINFO.sql` | measureInfo SEARCH | division별 measure 정보(기본 SalesAmt_LOC). |
| `DMF0021_GET_SPREAD_TITLE.sql` | spreadTitle SEARCH | 동적 시간축(M_/W_/D_ 3단) + ⭐ DEFAULT_FLAG NVL 교정(2곳) 반영본. |

## 미포함 — 공유 SP (클라우드 기존재 가정, 01 API_M 배선 존재)
| SP | 용도 |
|---|---|
| `PR_GET_DAY_RANGE` | dayRange(기본 조회기간 산출) |
| `DMF0002_GET_TITLESET_POPUP` / `SCM0002_SET_TITLESET_POPUP` | titleSet 조회/저장(Column·Measure 설정) |

## 미포함 — 미배선 변형 (배포 제외)
`DMF0021_GET_SALES_PLAN_MEASUREINFO2` — VALID 이나 API_M 미배선(변형본) → 이관 대상 아님.

## 의존 인프라 (공유 — 클라우드 기존재 가정, 본 패키지 범위 밖)
- GTT: `GT_DMF0021_*`(COLUMN_SETUP 등)
- 마스터/뷰: `SCM_SYS_CALENDAR_M`, `SCM_MST_SITE_ITEM`(SALES_PLAN_ADJUST_YN), `SCM_ADM_LOOKUP_MASTER_DETAIL`, `DM_MST_ITEM_SINGLE_V`
- 공유 함수/프로시저: `UP_FX_*`, `PR_SCM_SYS_LOG_BATCH`, `PR_GET_SHEET_COLUMN_LIST`(hook #113 컬럼 서버비교)

> ⚠ SP 재배포 시 라이브러리 캐시 배타적 락(hook #107 §4) — 접속 세션 종료 또는 `ALTER SESSION SET DDL_LOCK_TIMEOUT=30`.
