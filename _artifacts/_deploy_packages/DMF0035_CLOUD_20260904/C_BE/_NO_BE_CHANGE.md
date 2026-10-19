# BE 변경 없음 (DMF0035_CLOUD_20260904)

이번 이관 범위(OLAP 제거·공용 그리드 전환·GRID COLUMN SET 신설·titleset 'C' 축 정정)에
**BE(Java) 변경은 없다.** 화면은 기존 공용 경로만 쓴다.

- 조회 = `POST /{mnuId}/{shtNm}/SEARCH/call-proc` (GeneralController 공용)
- 컬럼/메저 메타 = `POST /admin/menu/{mnuId}/column` · `/measure` (MenuController 공용)
- 개인화 = `POST /admin/menu/{mnuId}/titleset/search` · `/titleset` (MenuController 공용)

⚠ 별건(이번 범위 밖, 보고만): 홈 화면 권한목록이 비는 것은 `UserSession` 에 `groups` 필드가 없어
로그인 응답에 권한그룹이 실리지 않기 때문이다(FE `Home.tsx:96` 은 `session.groups` 를 그린다).
해소하려면 BE 추가 변경이 필요하다 — 사용자 결정(2026-09-04)으로 이번엔 보고만 한다.
