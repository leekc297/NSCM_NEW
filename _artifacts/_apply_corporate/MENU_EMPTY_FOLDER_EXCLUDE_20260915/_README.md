# MENU_EMPTY_FOLDER_EXCLUDE_20260915 — 실제 사용 화면이 없는 메뉴 폴더(트리) 원천 배제

## 요구 (사용자 2026-09-15)
- bottle 로그인 시 권한 없는 ADMIN/SYSTEM 메뉴 노출 원인 확인
- "실제 사용하지 않는 메뉴는 대상에서 원천 배제" / "하위에 실제 메뉴가 없으면 메뉴 TREE 도 보이지 않도록"

## 원인 (사내 ZIOUI1 실측)
- bottle 권한그룹 = `SCP Planner` 1개. 이 그룹에 **폴더 `Admin`·`System` 만 매핑**(admin, 2026-07-27 13:28), 하위 화면 매핑 0.
- 메뉴 원천 SP `SCM_MGR.PR_GET_MENU_LIST_V2`(BE `admin.menu.retrieveMenus` → 로그인 세션·`/admin/menu` 단일 원천)가
  매핑 행을 폴더/화면 구분 없이 반환 → BE `MenuDto.treeOf` 도 빈 폴더 미필터 → Admin > System 빈 트리 노출.
- 전 그룹 전수: 하위 화면 없이 폴더만 매핑된 사례 = `SCP Planner`/`System` 1건.

## 조치 [E20260915-MENUEMPTY]
권한 판정(그룹 매핑·USE_YN·POPUP 제외)은 **종전 그대로**. 폴더(MNU_TP_CD='MENU')는
**사용자 권한 SCREEN 의 상위 폴더 체인(CONNECT BY)에 속할 때만** 반환 → 하위 실사용 화면이 없으면 트리 전체 미노출.

## 사전 검증 (DB 무변경 — compare)
사내 활성 사용자 **64명 전원** 기존 SP 결과 vs 신규 SELECT 대조:
| 결과 | 값 |
|---|---|
| 결과가 바뀌는 사용자 | 3 (bottle · coeogus · dodae) |
| 제거 행 | 6 = 각 사용자 `Admin`·`System` 폴더 |
| 제거된 SCREEN 행 | **0** |
| 추가 행 | 0 |
같은 SCP Planner 의 jaehun_cho · minyonglee1 은 타 그룹에서 Admin 하위 화면 권한 보유 → 종전과 동일.

## 적용 절차 (⚠ 미적용 — 실행 권한 차단으로 대기)
```
cd C:\Projects\NSCM\_artifacts\_apply_corporate\MENU_EMPTY_FOLDER_EXCLUDE_20260915
python apply_menu_sp.py apply    # 게이트(현재 SP == 00_BACKUP_ASIS) → 01_APPLY 배포 → STATUS/ERRORS/GRANT(SCMP_APP EXECUTE) 확인
python apply_menu_sp.py verify   # 64명 전원 SP 결과 == 신규 SELECT, bottle 에 Admin/System 없음 확인
```
DBeaver 로 할 경우 `01_APPLY/PR_GET_MENU_LIST_V2.sql` 실행 (CREATE OR REPLACE — 기존 GRANT 유지).
적용 후 bottle 은 **재로그인**해야 반영(메뉴가 로그인 세션에 저장됨).

## 원복
`00_BACKUP_ASIS/PR_GET_MENU_LIST_V2.ASIS.sql` 실행.

## 클라우드
`01_APPLY/PR_GET_MENU_LIST_V2.sql` 동일 사용 가능(단독 PROCEDURE 전체본). 클라우드 원문이 사내 백업본과 다르면 먼저 대조.
