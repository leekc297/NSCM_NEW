# AS-IS ↔ TO-BE VALIDATION 비교 기준서 (모든 비교 배치 공통)

## 원천
- AS-IS 검증 행: 배치 파일에 JSON 으로 동봉(이미 AS-IS 원문을 판독해 추출한 결과). 필요하면 AS-IS 원문 `C:\Projects\NSCM\Doc\asisfacts\db\modules\dbo.<SP>.sql` 을 직접 확인.
- TO-BE 원문: `C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\70cfc1a6-0bda-4c01-92c0-6addcb47fc4c\scratchpad\val\tobe\src\<file>` (사내 ZIOUI1 SCM_MGR, 2026-10-22 16:25 재조회). 배치에 지정된 라인 범위(start~end, PACKAGE BODY 내 해당 PROCEDURE 블록)를 **처음부터 끝까지 전부 Read**. 블록 안에서 호출하는 같은 PKG 의 내부 프로시저(P_LOG_ERROR, P_OPEN_ERROR, F_* 등)가 검증을 수행하면 그 정의도 찾아 읽는다.
- 라인번호 = 각 파일 기준.

## 판정 (AS-IS 검증 행 1개당 1행)
- `일치`: 같은 조건·같은 실패 처리(반환 코드/메시지 또는 보정값 또는 제외)가 TO-BE 에 있음. MSSQL→Oracle 표현 차이(ISNULL→NVL, '' → NULL/'-'/'/' 센티널, result_code 결과셋 → 결과커서 CODE/MSG 또는 O_RESULT_CODE, THROW → RAISE_APPLICATION_ERROR)는 일치로 본다. 단 차이점은 diff 에 기록.
- `차이`: 검증은 있으나 조건·대상·사업부 분기·실패 시 동작·메시지 중 하나라도 다름 → diff 에 구체적으로.
- `누락`: TO-BE 에 해당 검증이 없음.
- `해당없음`: AS-IS 행이 reach=주석/미도달이고 TO-BE 에도 없음(정상). TO-BE 에 살아 있으면 `차이`로 두고 diff 에 "AS-IS 주석/미도달인데 TO-BE 실행".
- AS-IS EXCEPTION(CATCH) 행은 TO-BE 의 EXCEPTION WHEN OTHERS 처리와 비교(ROLLBACK 여부·반환 코드·로그).

## ⭐ 실행 코드만 (사용자 지시 2026-10-22)
- 취합·비교 대상은 **실제 실행되는 코드만**. AS-IS 행 중 reach=주석/미도달 은 판정하지 말고 verdict=`해당없음` 으로만 남긴다(산출물에서 제외됨).
- TO-BE 쪽도 주석(`--`, `/* */`) 안의 코드나 도달 불가 분기는 근거로 쓰지 않으며, TO-BE 추가로 기록하지 않는다. TO-BE 에서 해당 검증이 주석 처리돼 있으면 `누락`.

## TO-BE 추가
GUIDE.md "⭐ 기준 통일" 1~4(계산 방어식·화면 표시 설정 기본값·UI 편집 경계값 전달·일반 범위/조인)는 TO-BE 추가로 기록하지 않는다. 블록은 키워드 스캔으로 대체하지 말고 끝까지 Read(불가피하면 summary 에 실제 읽은 줄 수·read_note).
TO-BE 블록에 있으나 어떤 AS-IS 행에도 대응하지 않는 검증(AS-IS 기준서 GUIDE.md 의 분류 A/B/C/D 정의 동일 적용)은 `TO-BE 추가` 행으로 기록.

## TO-BE 미이관
TO-BE 가 `P_RAISE_NOT_MIGRATED('<AS-IS명>')`(실행 코드)로 대체돼 있으면 해당 AS-IS SP 의 행은 verdict=`TO-BE 미이관`, summary.map_note 에 대체 위치(파일·라인).

## AS-IS 추출누락
TO-BE 추가 후보가 AS-IS 원문(`dbo.<asis_sp>.sql`)에도 같은 의미로 존재하면 `TO-BE 추가` 대신 verdict=`AS-IS 추출누락` 으로 기록하고, AS-IS 쪽 위치를 `asis_line_from`/`asis_line_to`/`asis_evidence` 에, TO-BE 쪽 위치는 tobe_* 에 함께 적는다(class/check_type/target/desc_ko 도 기재). 이관 자체는 일치/차이 중 무엇인지 diff 에 적는다.

## 매핑 확인
배치에 준 TO-BE 대상이 AS-IS SP 의 실제 전환본인지 확인(같은 목적·같은 저장 테이블·같은 파라미터 의미). 아니면 summary.map_ok="N" 과 이유, 더 적합한 대상이 같은 PKG 에 보이면 map_note 에 기재(그 경우에도 지정 대상 기준으로 판정은 하지 말고 전 행 `누락` 대신 `매핑오류` 로 표기).

## 출력 JSONL (한 줄 = JSON 1개)
```
{"asis_sp":"…","tobe":"PKG_X.P_Y","asis_idx":3,"verdict":"일치|차이|누락|해당없음|매핑오류","tobe_file":"PKG_X.PACKAGE_BODY.sql","tobe_line_from":120,"tobe_line_to":131,"tobe_evidence":"원문 발췌 200자 이내","diff":"차이/누락 설명(한국어)"}
{"asis_sp":"…","tobe":"PKG_X.P_Y","asis_idx":null,"verdict":"TO-BE 추가","class":"A","check_type":"REQUIRED","target":"…","tobe_file":"…","tobe_line_from":88,"tobe_line_to":92,"tobe_evidence":"…","desc_ko":"…"}
{"asis_sp":"…","tobe":"PKG_X.P_Y","_summary":true,"map_ok":"Y","map_note":"","tobe_lines_total":350,"tobe_lines_read":350,"asis_rows":5,"returns_to_ui":"TO-BE 가 UI 로 실패를 돌려주는 방식(결과커서 CODE/MSG, O_RESULT_CODE, RAISE 등)"}
```
- asis_idx = 배치에 동봉된 AS-IS 행의 idx 값 그대로.
- AS-IS 행이 0건인 쌍도 TO-BE 추가 여부를 판정하고 summary 를 반드시 쓴다.
