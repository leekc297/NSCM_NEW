# SCP0111 MS1 PKG 보완 (2026-11-19 13:37:58 사내 ZIOUI1 적용)

- 대상: SCM_MGR.PKG_SCP0111 BODY, 2줄
  - 3204줄 C_MSG_DUP: '[99010]동일한 데이터가 존재합니다.' → 'MSG00428'(KO, EN, CN 등록)
  - 3458줄 P_SCP0111_SAVE_PSI_ADMIN 오류 결과 MSG 칸: 중복(-20010)이면 C_MSG_DUP 코드만 돌려줌
- 근거: CheckList v64 EG-42d53d53(MS1) 사용자의견 '확인 필요' 재점검. CR-008. AS-IS SCP0111_SAVE_INTEGRATION_PSI_ADMIN 180줄도 같은 한글 문구(THROW 99010). AS-IS 화면 cs:1228 의 같은 뜻 메시지 = MSG00260(AS-IS 문구 '신규 입력 데이터 중 중복된 데이터가 있습니다.') = TO-BE MSG00428
- FE: integrationPsiApi.ts:28 결과 값 중 MSG 코드가 있으면 t(코드)로 표시. FE 수정 없음
- 적용 전 원문 LAST_DDL_TIME 2026-11-17 19:47:10, FRESH-GATE 일치, PKG 실행 세션 0
- 적용 뒤: VALID, ALL_ERRORS 0건, 원문 일치(첫 줄 공백만 다름)
- 실행 확인 13:38: 기존 행 키로 'I' 1셀 → CODE -1, MSG 'MSG00428', 변경 행 0. 시험 로그 SCM_SYS_LOG_BATCH 2행 삭제
- 원복: `python apply.py rollback`(현재 원문이 TOBE 와 같을 때만 ASIS 로 되돌림)
- 클라우드 이관: `_artifacts/_deploy_packages/SCP0111_CLOUD_DB_MOD_20261119_1338`(리허설 OK, 경고 0)
