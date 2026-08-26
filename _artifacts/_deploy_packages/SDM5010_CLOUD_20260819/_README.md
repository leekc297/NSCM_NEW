# SDM5010 Project Master — 클라우드 이관 패키지 (2026-08-19)

> 표준 = `SDM1020_CLOUD_20260819` 동형 (hook #134 §3 후속 화면 = **화면분만**).
> 원천 = `_artifacts/_apply_corporate/SDM5010_META_20260819/` (사내 기적용분 01~06·99 **무수정 취합**) +
> 사내 Oracle(OCGSCMD_P01, SCM_MGR) 2026-08-19 스팟 대조 — §5 전건 일치.
> 계약 단일 원천 = 동 폴더 `_CONTRACT.md` (PROC_M COL_NM·커서 실컬럼·DISABLE_YN 3상태 계약).

## ⭐ 이관 범위 기준 — 무수정 객체 제외 (사용자 확정 2026-08-19)

| 객체 | 판정 | 처리 |
|---|---|---|
| SPMS_PROJECT_MST / SPMS_PROJECT_USER_MAP (TABLE DDL) | 무수정(기존 테이블 그대로 사용) | **동봉 금지** — 클라우드 기생성 전제, PRECHECK [P1] 실존·컬럼수(37/22) 확인 |
| **PKG_SDM5010 SPEC+BODY** | **신규 배포물** (치명 결함 정정본 — 정정 마커 `[E20260819-SDM5010-*]` BODY 14곳 + SPEC 1곳 실측) | **모두 동봉** — `01_PKG_SDM5010_SPEC_BODY.sql` (사내 ALL_SOURCE 와 텍스트 일치 재검증 §5) |
| MSG/LBL **기존 코드** | 재사용 (MERGE 금지) | **제외** — 재사용 15코드 목록은 06 파일 헤더 주석 (MSG00097/00108/00164/00716/00717/01007/00002/00003 · LBL00001/00643/00046/00607/00857/00623/00624). PRECHECK [P7] 기존재 확인 |
| MSG/LBL **신규분** | MNU_SDM_Admin·MNU_SDM5010·MSG01008~01013·LBL00863 | 동봉 — INSERT-only (06) |
| GRANT/시노님·LOOKUP·CMBO·메타·ROUTE_PATH·FE | — | 동봉 (아래) |

## 1. 실행 순서 (⚠ QA·DEV **양쪽 각각** — 총 2회. SCM_MGR 계정, 시노님만 DBA)

```
A_DB/00_CLOUD_PRECHECK.sql        읽기 전용 — P0~P8 전 항목 PASS 후 착수 (환경식별/테이블 37·22/
                                  SPMS Administrator 그룹/SDM1010·1020 선행분/MSG 채번 충돌 가드)
A_DB/01_PKG_SDM5010_SPEC_BODY.sql SPEC+BODY 전체 (신규 배포물). 적용 후 PACKAGE+BODY 둘 다 VALID 확인
A_DB/02_GRANT_SYNONYM.sql         ⚠ 시노님은 DBA 권한 필요(CREATE ANY SYNONYM — SCM_MGR 불가, 사내 실사고).
                                  [3-1] GRANT = SCM_MGR 실행 / [3-2] 시노님 1문 = DBA 별도 실행.
                                  BE 계정이 SCMD_APP 인 프로파일(dev/qa/prd)은 SCMD_APP 로 동형 병행:
                                  GRANT EXECUTE ON SCM_MGR.PKG_SDM5010 TO SCMD_APP;
                                  CREATE SYNONYM SCMD_APP.PKG_SDM5010 FOR SCM_MGR.PKG_SDM5010; (DBA)
A_DB/03_LOOKUP.sql                SPMS_DPJT_DEVELOP_STATUS MASTER 1 + DETAIL 3 (DEV/PROD/DROP) — 멱등.
                                  ⚠ '임시 시드, 사용자 확정 대기' — 운영 확정값 수령 시 MERGE 보수
A_DB/04_CMBO_DpjtDevelopStatus.sql CMBO 신설 1본 (사내 SQL_DTL_CTN 174자 실측 — SQL_ID 한정 DELETE 후 INSERT)
A_DB/05_META_SDM5010.sql          MNU 2(ROUTE_PATH NULL) / SHEET_COLUMNS 48(TAB1 24+TAB2 24) / PROC_M 44 /
                                  MSG_API 36 / API 12 / BTN 12 / UGR_MNU 3 / UGR_BTN 12 — 멱등
                                  (SHEET·PROC = 대상 한정 DELETE 후 INSERT, 그 외 NOT EXISTS)
A_DB/06_MSG_LBL_NEW_ONLY.sql      ⭐ 신규 룰(2026-08-19) — 기존 코드 MERGE 금지·제외. 신규 채번분만
                                  INSERT-only: MNU 2코드(6) + MSG01008~01013(18) + LBL00863(3) = 27행
A_DB/90_VERIFY.sql                V1~V9 축별 기대 카운트 + 마커 14 전건 일치 확인 (QA·DEV 양쪽)
── FE 배포 (§2) ──
A_DB/99_ROUTE_PATH.sql            ⛔ 지금 실행 금지 — 반드시 FE 배포·빌드 후 최후미
                                  ('sdm/project-master'. 선적용 = 탭 "Page Not Found" — viewRegistry 등록 키 부재)
A_DB/90_VERIFY.sql [V9]           ROUTE_PATH='sdm/project-master' 재확인
```

## 2. B_FE (클라우드 리포 병합 — 이관 단위 = 폴더 전체)

| 패키지 경로 | 클라우드 대상 | 비고 |
|---|---|---|
| `B_FE/features_sdm/pages/project-master/` **폴더 전체(16파일 — 테스트 포함)** | `nscm-fe/features/sdm/src/pages/project-master/` | `index.ts` 가 viewRegistry 유일 등록 키 — 부분 이관 금지 |
| `B_FE/features_sdm/src_index.ts` | `nscm-fe/features/sdm/src/index.ts` | 전체 사본(project-master export 포함 3-export) |
| `B_FE/wiring/procedures.d.ts__SDM5010_block.txt` | `nscm-fe/configs/types/procedures.d.ts` | **블록 병합**(파일 통짜 덮어쓰기 금지 — 클라우드 셸 신·구 세대 혼재). 파일 상단 병합 안내 준수 |
| `B_FE/locales/{KO,EN,CN}.json` | (참조본) | ⚠ **전역 자산 — 구본 덮기 금지.** 신규 9키(MSG01008~13·MNU_SDM_Admin·MNU_SDM5010·LBL00863) 3본 각각 grep 확인 완료. 정석은 06 INSERT 후 클라우드에서 `gen:i18n` 재생성 — 동봉본은 기대 결과 대조용 |

병합 후 type-check/build 0 확인.

## 3. 의존성 (적용 순서 권장: SDM1010 → SDM1020 → SDM5010)

- **SDM1020_CLOUD_20260819 패키지 선적용 필수** — 공용 모달 `ProjectAuthRegModal`(features_sdm/components
  공용 승격분)·authPopup·features_sdm 공통분·`@sdm` alias 배선이 그 패키지(및 SDM1010_CLOUD_20260813)에
  기동봉. 본 패키지는 project-master 화면분만 동봉 — 선적용 없이는 import 미해결로 빌드 실패.
- DB 축도 동일: SDM 대분류 메뉴·SPMS Administrator 그룹·SPMS 테이블·기본 LOOKUP·공용 콤보 7종·
  PKG_SDM1010(P_SDM1010_GET_PERIOD — period 시트 공유 배선) = SDM1010/1020 기동봉 (PRECHECK 가 확인).

## 4. 이관 제외 명기

- ⚠ **minyonglee1 의 SPMS Administrator 그룹 부여 — 사내 테스트용, 이관 제외.**
  **클라우드는 운영 사용자 그룹 등재(SCM_ADM_USER_GR_USER_MPG) 별도 필요** — 본 패키지는 그룹→메뉴/버튼
  권한만 동봉하며 사용자→그룹 매핑은 운영 결정 사항.
- E2E·샘플 데이터(SPMS_PROJECT_MST 사내 테스트 원장) — 이관 제외.
- TABLE DDL·기존 MSG/LBL 코드 — §범위 기준 / POP1_* 권한관리 팝업 메타 42행·상위 메뉴·권한그룹·
  기본 LOOKUP·공용 콤보 — SDM1010/1020 기동봉.

## 5. 스팟 대조 결과 (2026-08-19 — 사내 OCGSCMD_P01 실측)

| 축 | 결과 |
|---|---|
| PKG | PACKAGE/BODY 둘 다 VALID · 마커 BODY 14(D1×2/D3/D4/D5/D6×4/D10/D11/DISABLED×2/REGSTS)+SPEC 1 = 파일과 일치 · ALL_SOURCE 신선 덤프 vs 동봉 01 텍스트 일치(차이 = 헤더 1행 스키마 수식어 — ALL_SOURCE 표기 차이뿐) |
| 메타 | MNU 2 / SHEET 24+24 / PROC 44(=ALL_ARGUMENTS 6·6·16·10·6) / API 12 / MSG_API 36 / BTN 12 / UGR_MNU 3 / UGR_BTN 12(그룹=SPMS Administrator 단독) / LOOKUP 1+3 / CMBO 1(174자) / MSG·LBL 신규 27 — 파일 인라인 데이터 vs 라이브 **양방향 MINUS 0행 (full-value 일치)** |
| FE | 패키지 20파일(project-master 16 + src_index + locales 3) sha256 = 라이브 **전건 일치** · wiring 블록 = 라이브 L4100~L4248 149라인 원문 일치 · locales 신규 9키 × 3본 grep 확인 |
| A_DB | 동봉 7본 = `_apply_corporate/SDM5010_META_20260819` 원본과 바이트 일치 (무수정 취합) |

## 6. 미결 (본 패키지 미반영 — 적용 판단 대기)

1. **개발현황 LOOKUP 임시 시드** (DEV/PROD/DROP) — 운영 확정값 사용자 확정 대기. 확정 시 MERGE 보수 후속.
2. **탭 라벨 미채번** — TAB1/TAB2 탭 표시 라벨 LBL 코드 미채번 상태 (FE 하드코딩 구간).
3. **DpjtRegCat 콤보 미등재** — SHEET_COLUMNS 가 참조하나 CMBO_SQL_M 부재 (표시 전용 'S' 라 차단 아님 —
   명칭 표시 필요 시 커서 DPJT_REG_CAT_NAME 사용 또는 콤보 후속 등재).
4. **D7~D24 경미 결함** — PKG 무수정 영역 (커서 REG_COMP_DATE 2회 중복 D16 등) — 정오표(`_CONTRACT.md` ⑤·⑦) 참조.

파일 무결성 목록 = `_FILELIST.md` (sha256 12자·bytes·lines).
