# 카테고리 07 — i18n·MSG/LBL / i18n & Messages

> **연다: 언제?** 메시지(MSG)/라벨(LBL) 신규 채번·재사용·이관, 다국어 처리 시.
> **최중요 지식**: 런타임 원천 = `nscm-fe/public/locales/{KO,EN,CN}.json` — `SCM_ADM_MSG_M` 은 `t()` 소스가 **아니다**. DB만 넣으면 fallback 표시.

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 114 | [msg-id-asis-tobe-conversion](../hooks/msg-id-asis-tobe-conversion.md) | ⭐⭐⭐ | AS-IS MSG_ID 그대로 사용 절대 금지(89% 재배정) — 실문구 확보→대조표→사내 실측 3분기(재사용/MAX+1 채번/유지) + **§5 신규 채번=3점 동시**(DB 3언어+locales 3 JSON+이관 PATCH) + MSG_TP_CD=접두사 일치 |
| 22 | [i18n-ko-en-alignment](../hooks/i18n-ko-en-alignment.md) | ⭐ | i18n KO=EN 값 통일 (전 prefix) |
| 3 | [asis-msg-inventory](../hooks/asis-msg-inventory.md) | ⭐ | AS-IS MSG[n] 인벤토리 → To-Be 등록 SQL 절차 |
| 87 | [screen-combo-validation-message-mandatory](../hooks/screen-combo-validation-message-mandatory.md) §M | ⭐⭐⭐ | 메시지 코드 의미 충돌 금지(예: 사내 MSG00004='수정 내용 없음') |
| 89 | [screen-grid-edit-merge-and-meta-mandatory](../hooks/screen-grid-edit-merge-and-meta-mandatory.md) §M+ | ⭐⭐⭐ | 비규격 메시지코드 → 표준(MSG00002/00003) 정정 |
| 98 | [corp-meta-integrity-and-wiring](../hooks/corp-meta-integrity-and-wiring.md) §7 | ⭐⭐ | LBL 채번 = 권위 DB max+1 (FE locales stray 회피) + 동일명칭 재사용 |

## 필수 절차 (채번·재사용 공통)
1. **재사용 전 실값 검증**: `grep '"LBL#####"' public/locales/EN.json` — 추측 금지 (LBL00062='From Date'≠Close[LBL00627] 오배정 사고 2026-07-30)
2. **신규 채번**: 사내 `SCM_ADM_MSG_M` MAX 실측+1 → 3언어 MERGE + locales 3 JSON + 이관 PATCH (하나라도 누락=결함)
3. **검증 게이트**: DB `GROUP BY MSG_ID` 전부 3행 / locales 3파일 grep 누락 0 / `MSG_TP_CD <> SUBSTR(MSG_ID,1,3)` 전수 0행

## Cross-ref
- 메모리: `feedback_i18n_new_code_three_point_sync` / `feedback_i18n_lbl_code_pattern` / `feedback_msg_id_text_reconciliation` / `feedback_icon_buttons_and_lbl_reuse`(LBL 실값 검증) / `feedback_i18n_ko_en_alignment`
- 대조표: `_artifacts/MESSAGE_ASIS_vs_TOBE_대조.xlsx`
