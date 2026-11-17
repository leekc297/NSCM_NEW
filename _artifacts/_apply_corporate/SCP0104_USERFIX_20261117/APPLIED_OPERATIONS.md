# SCP0104 사용자의견 DB 보완 (2026-11-17) 사내 적용 기록

기준 DB: 사내 Oracle ZIOUI1 (SCM_MGR). 근거: SCP0104 CheckList v22 사용자의견 열(조치 필요 2·6·8·12·14·15번).

## PKG_SCP0104 PACKAGE BODY

| 차수 | 시각 | LAST_DDL 전 → 후 | 내용 |
|---|---|---|---|
| 1차 실패 | 09:43:56 | 10:46:06(11-13) → 09:43:58 | 컴파일 오류 PLS-00103(주석 닫기 뒤 설명 문구) → 원문 자동 복원, 원문 동일 확인 |
| 1차 | 09:44:56 | 09:43:58 → 09:44:56 | ① Loss Plan 2곳 V_VERSION NULL 이면 날짜 변환 생략 ② Dummy 이름 UPPER 비교 2곳 ③ ELTR Material ITEM_ID 비교 2곳 ④ SOP 조회 ORDER BY 2곳 |
| 2차 | 09:47:01 | 09:44:56 → 09:47:01 | ⑤ P_SCP0104_SPLIT_CLOB 빈 값·끝 구분자도 1행(AS-IS dbo.String_Split 실측: '' 1행, 'a^' 2행) |

- 원인 진단: 진단용 복사본 PKG_SCP0104_DBG 를 09:38~09:39 에 만들어 실패 저장 4건을 재실행(오류 줄 = 3119 Loss Plan) 뒤 삭제. 남은 객체 0.
- 시험(verify_after.py, logs/verify_*.json): 저장 실패 재현 4건 'F'(ORA-01840) → 'S', 같은 트랜잭션 안 반영 확인 뒤 ROLLBACK. Material 'apcan2364c' 0행 → 4행. SOP_ASSEMBLY 정렬 어긋남 13 → 0. Dummy 'm50lt' → 기존 DMY_11562 반환, 행 505 그대로.
- 사고 1건: 09:44 1차 실패 직후 시험이 복원된 원문에서 Dummy 채번을 실행해 DMY_14154('m50lt') 1행이 커밋됨 → 09:44 삭제(행 수 505 복원). 시험은 보완 구간이 DB 에 있을 때만 채번하도록 수정. 시퀀스 1개 소비.
- 백업: backup/PKG_SCP0104.ASIS.sql(1차 착수), r2/backup/PKG_SCP0104.ASIS.sql(2차 착수). 적용본: tobe/, r2/tobe/.

## 데이터 (apply_data.py, 09:47:54)

- SCM_ADM_USER_GR_MNU_MPG_M: MNU_ID 'Capa Plan' 에 CAPA Planner, FP Planner, FP Viewer, SCM PI Admin, SCM Viewer, SCP Planner, SCP Tester 7행 추가(전에는 ADMIN 1행).
- SCM_MST_SHEET_COLUMNS SCP0104: SOP_ASSEMBLY.ELTR_LN_TP_CD 200 → 150, SOP_ASSEMBLY.SOP_DT 200 → 190, SOP_ELTR.SOP_DT 200 → 170(AS-IS 값).
- 수정 전 값: logs/data_before.json. 수정 후: logs/data_after.json.

## 클라우드 이관

- `_artifacts/_deploy_packages/SCP0104_USERFIX_CLOUD_20261117/` (10_PKG_PATCH.sql 변경 10구간 · 20_DATA_PATCH.sql · 90_VERIFY.sql · README.md). 생성 10:15.

## 미적용(같은 유형, 범위 밖)

- 메뉴 폴더 Supply_Validation 도 하위 화면 권한 그룹 12개 중 폴더 권한 1개(10:0x 조회). SCP0104 범위 밖이라 손대지 않음.

## 클라우드 적용 (사용자 보고)
- 2026-11-17 13:07 사용자 보고: SCP0104_USERFIX_CLOUD_20261117 클라우드 적용 완료. 클라우드 90_VERIFY.sql 결과는 미수령(Claude 클라우드 DB 접속 없음, 미확인).
