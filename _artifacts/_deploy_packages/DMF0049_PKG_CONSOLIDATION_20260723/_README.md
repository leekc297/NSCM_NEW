# DMF0049 PKG 취합 이관 (재취합판 v2 — 2026-07-23)

> ⭐ **v2 재취합 사유** (클라우드 1차 이관 실패 2건 반영):
> 1. 구판 파일이 SPEC+BODY 를 `/` 구분자 없이 담아 `PLS-00103: 심볼 "CREATE"` 발생 → 전 파일 `/` 구분 정비.
> 2. 구판 BODY 가 `SCM_MGR.DMF0044_MOBILE_REPORT_CREATE`(standalone) 를 호출하는 판본이었는데
>    클라우드에 해당 standalone 이 없어 `PLS-00201` 발생 → **사내 최신 live 판본(PKG_DMF0044.P_ 한정 호출)** 으로 교체
>    + 선행 의존인 **PKG_DMF0044 를 PREREQ 로 폴더에 동봉** (단독 이관 가능).
> 구판 sp 3파일은 `_backup/old_*` 로 이동.

## 적용 순서 (클라우드 — 번호 순서대로)

```
sp/01_PREREQ_GTT_DDL_DMF0044.sql     -- PKG_DMF0044 의존 GTT 18종 (멱등 -955 skip)
sp/02_PREREQ_PKG_DMF0044_SPEC.sql    -- ⭐ 선행 필수 — PKG_DMF0049 BODY 가 이 PKG 멤버를 호출
sp/03_PREREQ_PKG_DMF0044_BODY.sql
sp/04_GTT_DDL_DMF0049.sql            -- PKG_DMF0049 의존 GTT 6종 (멱등)
sp/05_PKG_DMF0049_SPEC.sql           -- 멤버 4
sp/06_PKG_DMF0049_BODY.sql           -- live 최신 (MOBILE 호출 = PKG_DMF0044.P_ 한정)
sql/01_wiring_API_PROC_M.sql         -- DMF0049 자체 2 SP 배선 (API+PROC_M, 멱등 MERGE)
sql/03_CROSS_DMF0044_WIRING.sql      -- DMF0049 버튼이 쓰는 PKG_DMF0044 4 proc 배선 (멱등)
sql/02_drop_standalone.sql           -- DMF0049 standalone 4 DROP (-4043 skip 멱등) + 고아 PROC_M
sql/99_VERIFY.sql                    -- 검증 3종 (VALID / 에러 0 / 버튼 전부 PKG 도달)
```

- 각 sp 파일은 문장 끝 `/` 구분자 포함 — DBeaver 는 **"SQL 스크립트 실행"(Alt+X)** 으로 실행.
- `DMF0044_PKG_CONSOLIDATION_20260723` 폴더를 이미 적용했다면 01~03(PREREQ) 은 건너뛰어도 됨(재실행 무해).
- 1차 실패로 INVALID 로 남은 PKG_DMF0049 는 05/06 재배포만으로 복구됨(CREATE OR REPLACE).

## 4버킷 처리 결과 (standalone 4)
| SP | 버킷 | 조치 |
|---|---|---|
| DMF0049_GET_SALES_ETC_REPORTS_DATA | B2 병합 | PKG 멤버 신규 + 배선전환 + 삭제 |
| DMF0049_SAVE_SALES_ETC_REPORT_C | B2 병합 | PKG 멤버 신규 + 배선전환 + 삭제 |
| DMF0049_GET_MEASURE / GET_SPREAD_TITLE | B3 삭제 | API 가 이미 PKG 멤버 사용 → standalone 사문화 → 삭제 |
| DMF0002/SCM0002 titleSet, PKG_DMF0000 공통 | B4 보류 | 공통 — 손대지 않음 |

- **처리 후 PKG_DMF0049 멤버 4**: GET_MEASURE / GET_SPREAD_TITLE(기존) + GET_SALES_ETC_REPORTS_DATA / SAVE_SALES_ETC_REPORT_C(신규). standalone DMF0049_* 4개 전부 삭제.
- **교차의존**: DMF0049 버튼 unitedVersion(ACTION/ACTION_BP/SEARCH/TRANSFER)·main SP_VER = **PKG_DMF0044 멤버 공용**(DMF0044 화면과 공유) → `03_CROSS` 가 배선. 내부 체인: P_DMF0049_SAVE_SALES_ETC_REPORT_C → `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE` (PREREQ 필요 사유).

## 검증 (사내 OCGSCMD_P01 — 적용 완료 상태가 이 패키지의 정본)
- PKG_DMF0049 PACKAGE/BODY VALID · errors 0 · 멤버 4. PKG_DMF0044 VALID · 멤버 23.
- DMF0049 버튼 전부 PKG한정명 도달(자체 2 + PKG_DMF0044 공용 5), standalone 참조 0.
- 회귀: GET_SALES_ETC_REPORTS_DATA standalone=PKG 해시 일치. 본문 바이트 동일(헤더/END만 치환).

## 잔여
- 클라우드 99_VERIFY 3종 통과 확인 → 화면(Etc Sales Reports) 조회/저장/버전 popup 실동작 1회 확인.
