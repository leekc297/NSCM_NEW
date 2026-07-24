# DMF0021 PKG 취합 (standalone → PKG_DMF0021 병합) — 2026-07-23

## 배경
UI별 PKG 원칙(`feedback_ui_pkg_no_standalone_sp`)에 따라, DMF0021 이 사용하던 standalone SP 를 `PKG_DMF0021` 로 병합(본문 무수정)하고 배선을 PKG한정명으로 전환, standalone 은 삭제.

## 사내 적용 전 상태
- API_M/PROC_M 이 **전부 standalone 이름**을 가리킴(PKG 멤버 3개는 미배선 사문화).
- standalone 5: DATAEX / SPREAD_TITLE / MEASUREINFO / SAVE(사용) + MEASUREINFO2(미사용 변형본).

## 4버킷 처리 결과
| SP | 버킷 | 조치 |
|---|---|---|
| DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX | B2 병합 | PKG 멤버 신규 + 배선전환 + 삭제 |
| DMF0021_GET_SPREAD_TITLE | B2 병합 | 동일 |
| DMF0021_GET_SALES_PLAN_MEASUREINFO | B2 병합 | 멤버 최신화(라이브본) + 전환 + 삭제 |
| DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL | B2 병합 | 동일 |
| DMF0021_GET_SALES_PLAN_MEASUREINFO2 | B3 삭제 | 미사용 → standalone·PKG멤버 모두 제거 |
| DMF0002_GET_TITLESET_POPUP / SCM0002_SET_TITLESET_POPUP / PR_GET_DAY_RANGE | B4 보류 | 공통 — 손대지 않음 |

**처리 후 PKG_DMF0021 멤버 4**: P_..._DATAEX / P_..._SPREAD_TITLE / P_..._MEASUREINFO / P_..._SAVE (MEASUREINFO2 제거).

## 파일 / 적용 순서 (클라우드)
```
1) sp/00_GTT_DDL_DMF0021.sql        (의존 GTT — 기존재 -955 skip)
2) sp/PKG_DMF0021_SPEC.sql          (멤버 4 선언)
3) sp/PKG_DMF0021_BODY.sql          (멤버 4 본문 — 라이브 standalone 무수정 이관)
4) sql/01_wiring_API_PROC_M.sql     (API_M→PKG한정 + PROC_M PKG한정 등록)
5) sql/02_drop_standalone.sql       (⚠ 4 검증 후 — standalone 5 DROP + 고아 PROC_M 정리)
```
- 본문 = `_backup/*_orig.sql` 의 헤더/END 만 치환(파라미터·로직 1바이트 불변). spec=ALL_ARGUMENTS 재구성(VARCHAR2/SYS_REFCURSOR).
- SP 재배포 시 라이브러리 캐시 락 → BE 종료 또는 `DDL_LOCK_TIMEOUT`.

## 검증 결과 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- 컴파일: PACKAGE/BODY **VALID, errors 0**, 멤버 4.
- 배선: MNU_ID=DMF0021 **9개 버튼 전부 PKG한정명 도달**. 잔존 standalone API_M 참조 0.
- PROC_M ↔ ALL_ARGUMENTS positional 카운트 일치(21/7/2/19).
- 회귀: GET 3종 standalone→PKG멤버 호출 **SHA 완전 일치**(MEASUREINFO 1행 8863.., SPREAD_TITLE 74행 2b77.., DATAEX 무에러). 본문 바이트 동일.
- 삭제: standalone 5 DROP(참조0: API/DEP/CMBO 전부 0 확인 후), 고아 PROC_M 49행 정리. 잔존 standalone DMF0021 PROC 0.

## 잔여 (사용자 최종 확인 권장)
- 로컬 FE→BE(사내 DB)로 화면 진입 조회/저장 실동작 1회(BE 로그 ORA 0). DB단은 전부 통과.

## _backup/
원본 PKG spec/body + standalone 5 GET_DDL + PROC_M/API_M rows(json) — ROLLBACK 근거.
