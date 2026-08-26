# SDM1020 Project List — 클라우드 이관 패키지 (2026-08-19)

> 표준 = hook #134 §3 (후속 화면 = **화면분만** — 대분류 메뉴 SDM/SDM_Project·권한그룹 3종·features 패키지 골격·
> SPMS 테이블·LOOKUP 기본분은 **SDM1010_CLOUD_20260813 기동봉**이라 본 패키지 제외, `A_DB/00_CLOUD_PRECHECK.sql` 로 기존재 확인).
> 원천 = 사내 Oracle(OCGSCMD_P01, SCM_MGR) **2026-08-19 ALL_SOURCE·원장 신선 덤프** — 드리프트 재검증 전건 일치(§5).

## ⭐ 이관 범위 기준 — 무수정 객체 제외 (사용자 확정 2026-08-19)

TABLE·PKG 는 **수정 내역이 있을 때만** 이관 대상.

| 객체 | 수정 여부 | 처리 |
|---|---|---|
| SPMS_PROJECT_MST / SPMS_PROJECT_USER_MAP (TABLE DDL) | 무수정(사용자 생성) | **동봉 금지** — 클라우드 기생성 전제, PRECHECK [P2] 실존·컬럼수(37/22) 확인 |
| PKG_SDM1020 **SPEC** | 무수정 | **동봉 금지** — PRECHECK [P1] SPEC VALID 실존 확인으로 대체 |
| PKG_SDM1020 **BODY** | 2026-08-19 정정 2건(D3/D12) | **동봉** — `01_PKG_SDM1020_BODY.sql` |
| GRANT/시노님·메타·MSG 신규분·LOOKUP·CMBO·ROUTE_PATH·FE | — | 동봉 (아래) |

## 1. 실행 순서 (⚠ QA·DEV **양쪽 각각** — 총 2회. SCM_MGR 계정, 시노님만 DBA)

```
A_DB/00_CLOUD_PRECHECK.sql   읽기 전용 — P1~P9 전 항목 PASS 후 착수 (SPEC/테이블/상위메뉴/그룹/LOOKUP/콤보/MSG충돌)
A_DB/01_PKG_SDM1020_BODY.sql BODY 만 (SPEC 기존재 전제 — 부재 시 중단·회신). 적용 후 PACKAGE+BODY 둘 다 VALID 확인
A_DB/02_GRANT_SYNONYM.sql    ⚠ 시노님은 DBA 권한 필요(CREATE ANY SYNONYM — SCM_MGR 불가, 사내 실사고).
                             BE 계정이 SCMD_APP 인 프로파일(dev/qa/prd)은 [B] 주석 해제 병행
A_DB/03_META_SDM1020.sql     MNU 1 / SHEET_COLUMNS 30(현행 = DEFAULT_FLAG·Division 09 정정 반영본) /
                             PROC_M 29 / API 7 / MNU_BTN 7 / UGR_MNU 3 / UGR_BTN 21 — 대상 한정 DELETE 후 INSERT
A_DB/04_MSG_LBL_NEW_ONLY.sql ⭐ 신규 룰(2026-08-19 사용자 확정) 첫 적용 — 기존 코드 MERGE 금지·대상 제외.
                             신규 채번분만 INSERT-only: MNU_SDM1020(3) + MSG01002~01007(18) + MSG_API(21).
                             재사용 17코드는 파일 헤더 목록으로만 기재(이관 제외)
A_DB/05_LOOKUP.sql           사내 07(REQ_MOD/MOD 시드) + 08(등록상태 확정 9항목 — 기존 코드 무수정·신규 4코드) 통합, 멱등
A_DB/06_CMBO_StackMethodByCellType.sql  CMBO 신설 1본 (사내 SQL_DTL_CTN 338자 실측 덤프)
A_DB/90_VERIFY.sql           V1~V10 축별 기대 카운트 전건 일치 확인 (QA·DEV 양쪽)
── FE 배포 (§2) ──
A_DB/99_ROUTE_PATH.sql       ⚠ 반드시 FE 배포 후 마지막 (선적용 = 탭 "Page Not Found" — viewRegistry 등록 키 부재)
A_DB/90_VERIFY.sql [V10]     ROUTE_PATH='sdm/project-list' 재확인
```

## 2. B_FE (클라우드 리포 병합 — 이관 단위 = 폴더 전체)

| 패키지 경로 | 클라우드 대상 | 비고 |
|---|---|---|
| `B_FE/features_sdm/pages/project-list/` **폴더 전체(15파일 — 테스트 포함)** | `nscm-fe/features/sdm/src/pages/project-list/` | `index.ts` 가 viewRegistry 유일 등록 키 — 부분 이관 금지 |
| `B_FE/features_sdm/components/` 3파일 | `nscm-fe/features/sdm/src/components/` | ProjectAuthRegModal 공용 승격 + authPopup(+test) — SDM1010 pages 하위 구본은 클라우드에서 제거·import 전환 |
| `B_FE/features_sdm/pages/project-reg/ProjectReg.tsx` | `nscm-fe/features/sdm/src/pages/project-reg/ProjectReg.tsx` | 공용 승격에 따른 import 경로 수정분(`../../components/ProjectAuthRegModal`) — 이 1파일만 교체 |
| `B_FE/features_sdm/src_index.ts` | `nscm-fe/features/sdm/src/index.ts` | 전체 사본(project-list export 추가분) |
| `B_FE/wiring/procedures.d.ts__SDM1020_block.txt` | `nscm-fe/configs/types/procedures.d.ts` | **블록 병합**(파일 통짜 덮어쓰기 금지 — 클라우드 셸 신·구 세대 혼재). 파일 상단 병합 안내 준수 |
| `B_FE/locales/{KO,EN,CN}.json` | (참조본) | ⚠ **전역 자산 — 구본 덮기 금지.** MSG01002~01007·MNU_SDM1020 포함 grep 확인 완료(3본 각 7코드). 정석은 04 MSG INSERT 후 클라우드에서 `gen:i18n` 재생성 — 동봉본은 기대 결과 대조용 |

전제(기적용): `@sdm` alias(tsconfig.base)·apps/web `@sdm` 의존 — SDM1010 패키지 배선분. 병합 후 type-check/build 0 확인.

## 3. 미결 2건 (본 패키지에 미반영 — 적용 판단 대기)

1. **40 division 권한컬럼 노출 여부** — SHEET_COLUMNS DIVISION_ID 한정 10행(81계열·82)이 메타 우선 확정으로
   **40 조회 시 권한 계열 컬럼 미표시**. 사용자 재확인 대기 (변경 시 SHEET_COLUMNS UPDATE 1건으로 후속).
2. **PKG TO_CHAR(SEQ,'000000') 공백 결함** — 채번 문자열에 선행 공백 유입(FM 미적용). **FM 정정 미승인** —
   BODY 는 사내 현행 그대로 이관(임의 정정 금지). 승인 시 BODY 재이관.

## 4. 이관 제외 명기

- **샘플 데이터 5건**(SPMS_PROJECT_MST 사내 테스트 원장) — 사내 테스트용, 이관 제외.
- TABLE DDL·PKG SPEC — §범위 기준(무수정) / POP1_* 5시트 메타·상위 메뉴·권한그룹·기본 LOOKUP·공용 콤보 7종 — SDM1010 기동봉.
- DpjtDevelopStatus 콤보 — lookup 'SPMS_DPJT_DEVELOP_STATUS' 0행(사내·클라우드 공히) — lookup 신설 후 후속 등재(전 환경 동일 상태 — 미결 아님).

## 5. 드리프트 재검증 (2026-08-19 — 패키지 생성 직후 2차 실측)

| 축 | 결과 |
|---|---|
| PKG BODY | ALL_SOURCE 2차 재덤프 sha256 12자 `bc0e9a3b31c0` = 1차 덤프 = 패키지 동봉 원문 **일치** · 마커 [E20260819-D3]/[E20260819-D12] 각 1 실측 · PACKAGE/BODY VALID |
| FE | 패키지 23파일 전건 sha256 = 라이브 **23/23 일치** · wiring 블록 = 라이브 L4006~L4098 93라인 원문 일치 · locales 3본 신규 7코드 포함 |
| 메타 | SHEET 30 / PROC 29 / API 7 / BTN 7 / UGR_MNU 3 / UGR_BTN 21 / MSG 42 / LOOKUP REG_STATUS 'Y' 10행(확정 9항목 — 작성중 DRAFT·WRITING 2코드) / CMBO 1 — **전건 일치** |

파일 무결성 목록 = `_FILELIST.md` (sha256 12자·bytes·lines).
