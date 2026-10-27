# 메시지 ID AS-IS ↔ TO-BE 대조 기준서

목적: 화면 VALIDATION 취합에서 "TO-BE 적용/부분적용"으로 판정된 UI 행마다, **TO-BE 화면이 실제로 표시하는 메시지 ID 와 문구**를 FE 코드 원문으로 확정하고, AS-IS 메시지와 **의미가 같은지** 판정한다.
배경(사용자 지시 2026-10-23): AS-IS·TO-BE 는 메시지 번호 체계가 다르다. ID 가 달라도 문구 의미가 같으면 정상, **ID 가 같아도 문구 의미가 다르면 결함**(예: TO-BE 가 AS-IS 의 MSG00002(필수)를 그대로 썼는데 TO-BE 마스터의 MSG00002 는 "성공적으로 저장되었습니다").

## 원천
- 입력: `msgcheck_in/mNN.json` — 행마다 uid, screen, event, asis_msg_id, asis_msg_ko(AS-IS 마스터 문구), asis_msg_args/asis_msg_text, remark, tobe_apply, tobe_basis(판독 에이전트가 적은 TO-BE 근거 — 파일:라인 포함, **ID 표기는 신뢰하지 말고 코드로 재확인**), tobe_folders.
- TO-BE FE 코드: `C:\Projects\NSCM\nscm-fe\` + tobe_folders(예: `nscm-fe/features/supply/src/pages/tact-time`). tobe_basis 의 파일·라인을 Read 하고, 메시지 키가 상수(`MSG.XXX`, `CRUD_MSG.REQUIRED_FIELD.id` 등)면 정의(constants 파일, `@foundation/constants`·`@shared` 의 공통 상수 — 경로 예: `nscm-fe/packages/foundation/src/constants/`)까지 따라가 **실제 문자열 ID** 를 확정. `t('MSGxxxxx', '_fallback')` 형태면 그 ID. 공통 훅(`useSaveWithValidation` 등)이 띄우면 그 훅이 쓰는 ID.
- TO-BE 메시지 마스터(사내 ZIOUI1 SCM_ADM_MSG_M, 2026-10-23 06:58 조회): `tobe_msg_master.csv` (MSG_ID, LANG_CD, MSG_NM, USE_YN). KO 우선.
- AS-IS 메시지 마스터: `C:\Projects\NSCM\Doc\asisfacts\db\meta\dbo.TB_FX_MessageInfo.csv` (입력의 asis_msg_ko 와 같음).

## 판정 (행마다)
- `tobe_msg_ids`: TO-BE 가 이 검사에서 표시하는 메시지 ID 목록(보통 1개). ID 없이 하드코딩 문자열/서버 message 를 보여주면 [] 이고 `tobe_text` 에 그 문자열.
- `tobe_msg_ko`: TO-BE 마스터의 KO 문구(없으면 "TO-BE 마스터 미등록" + 코드의 fallback 문자열).
- `meaning`: 
  - `일치` — AS-IS 문구와 같은 의미(번호·표현 달라도 사용자가 받는 뜻이 같음. 인자 위치 차이 무관)
  - `불일치` — 뜻이 다름(예: 필수 ↔ 저장성공, 날짜형식 ↔ 삭제할 데이터 없음, 초과 ↔ 이상). 어떤 뜻으로 보이는지 note 에.
  - `TO-BE 미등록` — TO-BE 가 쓰는 ID 가 마스터에 없거나 USE_YN=N (fallback 문자열이 보일 것)
  - `메시지 없음` — TO-BE 는 막기만 하고 메시지를 안 띄움
  - `AS-IS 문구 이상` — AS-IS 코드 의도(주석·문맥)와 AS-IS 마스터 문구가 이미 어긋나는 경우(예: 날짜 오류에 AS-IS MSG00046 "삭제할 데이터가 없습니다"). 이때는 **AS-IS 코드 의도** 기준으로 TO-BE 의미를 판정하고 note 에 `[AS-IS 문구 이상] 의도=…, 실제 표시=…` 와 TO-BE 판정(의도와 일치/불일치)을 같이 적는다.
- AS-IS 가 MSG ID 없이 하드코딩 문구(asis_msg_text)면 그 문구와 비교.
- 추측 금지. 코드에서 ID 를 확정 못 하면 `meaning`="미확인" + 이유.

## 출력
`msgcheck_out/mNN.jsonl` — 입력 행마다 1줄:
```
{"uid":"u08.jsonl:12","screen":"SCP0020","asis_msg_id":"MSG00002","tobe_msg_ids":["MSG00429"],"tobe_msg_ko":"{0} 값은 필수 입력 항목입니다.","tobe_text":"","meaning":"일치","tobe_loc":"nscm-fe/packages/shared/src/hooks/useSaveWithValidation.ts L92 (CRUD_MSG.REQUIRED_FIELD.id=MSG00429, foundation/constants/... L..)","note":""}
```
- 파일 수정 금지(출력 1개만). 최종 응답: 판정별 건수, 불일치·미등록 목록(화면·이벤트·AS-IS ID→TO-BE ID), 애매했던 점 3개 이내.
