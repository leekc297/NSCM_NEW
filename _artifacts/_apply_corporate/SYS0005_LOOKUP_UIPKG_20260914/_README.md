# SYS0005 Procedure Setting — 조회 0건 보완 (2026-09-14)

사내 적용: ZIOUI1 · 데이터 1행 UPDATE · 클라우드 ⛔ 미적용

## 원인
`PKG_SYS0005.SYS0005_GET_MAIN_DATA` 는 룩업 `UI_PKG_NM` 에 등록된 패키지만 목록 대상으로 삼는다
(`ALL_ARGUMENTS.OWNER = SEGMENT1 AND PACKAGE_NAME LIKE SEGMENT2 || '%'`).
사내 룩업 행이 `SEGMENT1='PKG_SYS0005'`(소유자 자리에 패키지명) 으로 등록돼 있어 일치하는 소유자가 없어 항상 0건.
SP 코드 결함 아님 — 04-13 PROC_M 기반에서 룩업 기반으로 바뀐 뒤 08-24 등록된 룩업 데이터 오류.

AS-IS 대조: AS-IS DB(LESDFPSTO1C01/LGCE_SCMDEV)에는 SYS0005 계열 SP·`UI_PKG_NM` 룩업이 없다 — TO-BE 신규 관리 화면이라 1:1 비교 대상 없음.

## 보완 (사용자 확정: SEGMENT1='SCM_MGR', SEGMENT2='PKG_' — SCM_MGR 소유 PKG 전체)
- `01_UPDATE_LOOKUP_UI_PKG_NM.sql` / 원복 `99_ROLLBACK_LOOKUP_UI_PKG_NM.sql`
- 1차로 SEGMENT2='PKG_SYS0005' 유지(4개) 적용 후, 사용자 지시로 'PKG_' 로 확대

## 실측 (BE API)
- 수정 전: procList 0행
- 수정 후: procList 504행 / 82개 패키지 · 1.5초 (IS_YN Y 255 · N 249 / UPDATE_YN Y 261 · N 243)
- 프로시저명 검색 `PKG_DMF0053` → 2행 정상

## 참고
`PACKAGE_NAME LIKE 'PKG_%'` 의 `_` 는 LIKE 와일드카드(임의 1문자)라 'PKG' 뒤 임의 문자 패키지도 포함된다.
사내 SCM_MGR 패키지는 전부 `PKG_` 로 시작해 결과 영향은 없다.
