# DMF0045 클라우드 이관 : W/H BOH 조회 지연 보완 (2026-11-25 14:35)

## 실행 순서 (클라우드, SCM_MGR, 파일마다 전체 F5)
1. 00_CHECK_RUNNING.sql : DMF0045 조회가 도는 세션 확인. 0행일 때 다음 단계 진행
2. 05_BACKUP_PKG_DMF0045.sql : 현재 PKG_DMF0045 BODY 원문을 ZB_DMF0045_BODY_20261125 표에 보관
3. 20_PATCH_PKG_DMF0045_BOH.sql : 보완 구간 17줄 교체. Output 창 APPLY 확인
4. 90_VERIFY.sql : VALID, 오류 0, 줄 수 2437, 보완 표시 1
5. 99_ROLLBACK_PKG_DMF0045.sql : 문제 있을 때만 실행

## 15:10 수정 (클라우드 20 실행 ORA-01031)
- 원인 : 클라우드 접속 창 현재 스키마 FP_MGR. 20 이 스키마 없이 PKG 를 교체해 FP_MGR 아래 생성을 시도함. SCM_MGR 에 CREATE ANY PROCEDURE 없음
- 조치 : 00, 05, 20, 90, 99 첫 줄에 ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR 추가. 20, 99 교체 문장에 SCM_MGR. 표시
- 사내 재현 : 현재 스키마 FP_MGR 로 종전 20 실행 시 같은 ORA-01031. 수정본은 같은 조건에서 05, 20, 90, 99 정상
- 종전 실행으로 바뀐 것 없음 : 클라우드 PKG_DMF0045 원문 그대로임

## 바뀌는 것
- PKG_DMF0045 W/H BOH 계산 82 사업부 부분 (클라우드 1345~1361줄)
- 재고 뷰 SSP_DNM_ESS_PACKER_STOCK_V 를 1번만 읽음. 사이트별 최근 재고 일자는 같은 읽기에서 구함
- 그 밖의 줄은 클라우드 원문 그대로 둠

## 사내 확인 (ZIOUI1, 2026-11-25)
- 14:27 사내 적용, VALID, 오류 0
- 수정 전후 조회 결과 6건 일치 (82, 81, 40 사업부 × Pack Biz, Cell Biz, 행 수와 결과 지문)
- 14:33 임시 사본 PKG 시험 : 종전 원문 APPLY, 들여쓰기 다른 원문 APPLY, 보완된 원문 SKIP
- 14:34 보관, 확인, 원복 스크립트 시험 : 원복 뒤 원문 일치

## 같은 날 만든 자동 패키지와 차이
- DMF0045_CLOUD_DB_MOD_20261125_1429 는 조립 결과가 사내 원문과 같아야 적용함. 클라우드 본문 2436줄, 사내 2399줄이라 중단됨
- 그 패키지 30_META 의 SCM_MST_SHEET_COLUMNS 2행(DIVISION_ID 머리글 'Div*')은 이번 보완과 관계없음. 오늘 사내에서 바뀐 행임
