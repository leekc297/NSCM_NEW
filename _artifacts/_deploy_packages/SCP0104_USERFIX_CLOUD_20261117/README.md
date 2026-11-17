# SCP0104 사용자의견 DB 보완 · 클라우드 이관 패키지 (수정 구간만)

- 생성: 2026-11-17 10:15:27 · 기준 = 사내 Oracle ZIOUI1 (SCM_MGR)
- 실행 계정: SCM_MGR · 순서: `10_PKG_PATCH.sql` → `20_DATA_PATCH.sql` → `90_VERIFY.sql` (각각 전체 실행, 반복 실행 안전)

## 보완 내용
- PKG_SCP0104: ① Loss Plan 2곳 V_VERSION NULL 이면 날짜 변환 생략(ORA-01840) ② Dummy 이름 비교 대소문자 무시 2곳 ③ ELTR Material 비교 NICK_NAME → ITEM_ID 2곳 ④ SOP 조회 ORDER BY 에 OPERATION_ID·ELTR_LN_TP_CD 추가 2곳 ⑤ P_SCP0104_SPLIT_CLOB 빈 값·끝 구분자도 1행(AS-IS dbo.String_Split 등가) 2곳
- 데이터: Capa Plan 폴더 권한(하위 화면 권한 그룹 중 없는 그룹만 추가) · SCP0104 SOP 컬럼 SORT_ORDER_NO 3행(AS-IS 값)
- 먼저 가능 여부만 보려면 `10_PKG_PATCH.sql` 의 `c_dry CONSTANT BOOLEAN := FALSE` 를 TRUE 로 일괄 바꿔 실행한다(적용 안 함).

## 동작
- 패키지마다 클라우드 자신의 원문을 읽어 **이번 수정 구간만** 치환한다. 그 밖의 클라우드↔사내 차이는 건드리지 않는다.
- 출력: `> APPLY`(적용) / `> SKIP`(이미 반영) / `ORA-20011 중단`(그 구간이 사내 수정 전과 달라 자동 반영 불가 — 그 객체 원문은 무변경, 나머지는 계속 진행).
- 컴파일 오류가 나면 그 객체는 실행 전 원문으로 자동 복원된다.

## 대상 패키지 (1개) + 데이터 2종

| 패키지 | 변경 구간 | 사내 적용 시각 |
|---|---|---|
| PKG_SCP0104 | 10 | 2026-11-17 09:47:01 |
| SCM_ADM_USER_GR_MNU_MPG_M Capa Plan 7행 · SCM_MST_SHEET_COLUMNS 3행 | - | 2026-11-17 09:47 |

## 되돌리기
- 사내 수정 전 원문: `_artifacts/_apply_corporate/SCP0104_USERFIX_20261117/backup/PKG_SCP0104.ASIS.sql` · 데이터 수정 전 값 `logs/data_before.json`
- 클라우드는 실행 전 원문을 별도로 받아 두었다가 필요 시 재실행한다(이 패키지는 클라우드 백업 파일을 만들지 않는다).
