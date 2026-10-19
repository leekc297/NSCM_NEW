# PR_DM_BPS_METAL_LINK_S — VERSION_NO '_V1' 생성 수정 (VERSEQ2D) · 클라우드 이관

- 작성: 2026-10-01 · 사내 ZIOUI1 적용 완료 (VALID, 오류 0)
- 대상: 클라우드 QA · DEV 각각 SCM_MGR
- 범위: `PR_DM_BPS_METAL_LINK_S` 채번식 1곳 (GTT·FE·BE·메타 변경 없음)

## 원인
`GT_DBML_VERSION_SEQ.VERSION_SEQ` 컬럼이 **NUMBER** 다(클라우드도 동일, 사용자 확인).
1. 프로시저가 `LPAD(seq, 2, '0')` 로 `'02'` 를 넣어도 컬럼에는 `2` 로 저장된다.
2. 채번식 `VERSION_NO_T || NVL(Y.VERSION_SEQ, '01')` 의 NVL 결과형도 NUMBER 다. 그래서 `'01'` 이 `1` 로 바뀐다.
3. 결과적으로 TO-BE 실행분이 `..._V1`, `..._V2` 로 만들어진다.

## 변경
```
NVL(Y.VERSION_SEQ, '01')  →  NVL(TO_CHAR(Y.VERSION_SEQ, 'FM00'), '01')
```
- 지시식은 `TO_CHAR(Y.VERSION_SEQ, '00')` 이었다. 그런데 `'00'` 포맷은 부호 자리에 공백을 붙여 `' 02'` → `..._V 02` 를 만든다(사내 실측).
- 그래서 같은 의도로 `'FM00'` 을 쓴다(앞 공백 제거). 결과: V01 / V02 / V10.

## 실행 순서 (sqlplus / SQL Developer 스크립트 실행)
1. `A_DB/01_PATCH_PR_DM_BPS_METAL_LINK_S.sql` — **클라우드 자기 원문을 읽어 위 1곳만 치환 후 재컴파일**한다.
   - 클라우드 판본(LAST_DDL 2026-08-14)이 사내(2026-09-02)와 달라서 전문 교체 대신 이 방식을 쓴다.
   - 출력 `PATCHED — STATUS=VALID` 이면 정상.
   - 이미 적용돼 있으면 `ALREADY` 출력 후 변경 없음.
   - 채번식이 정확히 1곳이 아니면 오류(-20002)로 중단하고 변경하지 않는다 → 결과 공유.
2. `A_DB/90_VERIFY.sql` — VALID · 채번 줄 1줄 · 식 재현 V01/V02/V10
3. 원복이 필요할 때만 `A_DB/99_ROLLBACK_PR_DM_BPS_METAL_LINK_S.sql` (패치 흔적이 없으면 `NOTHING`)

## 사내 검증
- `_apply_corporate/PR_DM_BPS_METAL_LINK_S_VERSEQ_20261001/test_cloud_patch_scripts.py` 로 01·99 를 실제 프로시저에서 왕복 검증했다 → **PASS**.
  - 순서: 원문 복원 → 01 패치 → 01 재실행(ALREADY) → 99 원복 → 99 재실행(NOTHING) → 01 패치
  - 99 원복 결과가 원래 원문과 md5 일치 · 매 단계 VALID / 오류 0
- 실제 GTT(NUMBER) 경유 재현(ROLLBACK): 행 없음 → V01 / seq 2 → V02 / seq 10 → V10
- 사내 최종 상태 = 본 01_PATCH 적용본. 원래 원문 백업은 `_apply_corporate/.../00_BACKUP_PR_DM_BPS_METAL_LINK_S.sql`.

## 참고
- 이미 생성된 `_V1` 행은 정정하지 않는다(데이터 무변경).
- 다음 채번은 `SUBSTR(MAX(VERSION_NO), 19, 2) + 1` 로 구한다. 같은 주에 `_V1` 이 있으면 `'1'` + 1 → `V02` 로 이어지므로 중복은 생기지 않는다.
