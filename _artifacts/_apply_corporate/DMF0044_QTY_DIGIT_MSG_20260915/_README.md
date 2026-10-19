# DMF0044_QTY_DIGIT_MSG_20260915 — 수량 자릿수 초과 메시지 문구 보완 (DB 전용, FE 무변경)

- 요구(사용자 2026-09-15): 자릿수 초과 시 아래 형식으로 안내. **FE 수정 없이 DB 기존 검증의 메시지만 변경.**
  ```
  허용 가능한 자릿수를 초과하였습니다. 30자리(정수20자리) 이내로 입력하세요.
  Model : MCCM349215A1-002
  Measure : RTF_SYS_RP
  기간 : 202602
  부서 : IM1팀
  입력값 7.777777777777778e+35
  ```
- 기존 구조 (2026-09-03 [E20260903-DMF0044NUM]): 저장 SP `P_DMF0044_SAVE_SALES_PLAN_REPORT_C`(ETC) / `_C_CF`(Cutoff) 가
  공용 함수 `FN_CHK_QTY_DIGITS(20)` 로 정수부 20자리 초과를 검사 → `O_RESULT_CURSOR` CODE=-1 / MSG=메시지 반환 →
  FE axios 인터셉터가 MSG 를 Alert 표시. **이번 변경은 이 함수의 반환 문구만** 교체 [E20260915-DMF0044MSGFMT].
- 판정 로직(ABS(값) ≥ 10^20)·최대 10건 상세·"외 N건" 표기는 그대로. 다건이면 건 사이 빈 줄 1개.

## 적용 (사내 ZIOUI1 — 2026-09-15 10:25 적용 완료)
| # | 파일 | 결과 |
|---|---|---|
| 0 | 00_BACKUP_ASIS/PKG_DMF0044_BODY.ASIS.sql | 적용 직전 BODY 전체 (원복용) |
| 1 | 01_APPLY/PKG_DMF0044_BODY.sql | 게이트(현재 BODY == 백업) 통과 후 배포 → PACKAGE / BODY **VALID**, ALL_ERRORS 0, 배포본 == 01_APPLY |
| — | apply_msg_format.py | backup / apply / test 3모드 |

실측(test — ETC·Cutoff·Cutoff 2건 호출, 검증은 DML 전 RETURN 이라 원장 무변경): 3케이스 모두 CODE=-1, 위 형식 그대로 반환.

## 클라우드
`01_APPLY/PKG_DMF0044_BODY.sql` 는 **사내 BODY 전체본**이다. 클라우드 BODY 가 사내와 다르면 통째 덮어쓰기 금지 —
클라우드 현재 BODY 에서 `FN_CHK_QTY_DIGITS` 의 `IF V_CNT <= 10 THEN` ~ `RETURN ... END;` 블록만 동일 치환할 것
(치환 전/후 원문 = apply_msg_format.py `OLD`/`NEW`).

## 원복
`00_BACKUP_ASIS/PKG_DMF0044_BODY.ASIS.sql` 실행.

## 정정 이력 (같은 날)
최초 대응에서 기존 DB 검증을 확인하지 않고 FE 검증 + 신규 MSG01032 를 만들었다가 사용자 지적으로 전부 원복:
FE 7파일 해당 hunk 원복 · locales 3종 MSG01032 제거 · 사내 SCM_ADM_MSG_M MSG01032 3행 삭제.
