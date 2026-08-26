# -*- coding: utf-8 -*-
"""[E20260819-MULTIJOIN] CURRENT GTT_TEMPSITEITEMALL 전환 예외 존치(revert).
   사유: 전환 후 해당 INSERT 단일문 38분+ 무종료 (사내 실측 2026-08-19, V$SESSION SID503 LAST_CALL_ET 2270s+
        SQL_ID 0dh4m2dhduyqg 'INSERT INTO SCM_MGR.GTT_TEMPSITEITEMALL...') — 지시 '악화 시 되돌리고 보고' 적용.
   원형 = PKG_DMF0082_BODY_PRE_MULTIJOIN_20260819.sql 의 (START)~(END) 구간. MAIN 동형 지점은 전환 유지(파리티 PASS)."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

S = "    INSERT INTO SCM_MGR.GTT_TEMPSITEITEMALL"
E = "    -- #TempSiteItemAll 만들기 (END)"

pre = open('PKG_DMF0082_BODY_PRE_MULTIJOIN_20260819.sql', encoding='utf-8').read()
ps, pe = pre.find(S), pre.find(E)
assert 0 < ps < pe, (ps, pe)
orig_seg = pre[ps:pe]  # START 주석 ~ END 주석 직전 (원형 인라인 문장 + 종결 ';')

live = open('PKG_DMF0082_BODY_PRE_REVERTCUR_20260819.sql', encoding='utf-8').read()  # 신선 덤프
ls, le = live.find(S), live.find(E)
assert 0 < ls < le, (ls, le)

note = ("    /* [E20260819-MULTIJOIN] 예외 존치(revert 2026-08-19) — 본 CURRENT GTT_TEMPSITEITEMALL 스테이징은\n"
        "       GTT 전환(인라인 술어 제거+후행 DELETE) 적용 시 INSERT 계획 회귀로 단일문 38분+ 무종료\n"
        "       (사내 실측: V$SESSION LAST_CALL_ET 2270s+, SQL_ID 0dh4m2dhduyqg — LISTAGG 상관 스칼라 ×\n"
        "       1행 파생테이블 카디널리티 앵커 상실 추정, 원인 확정은 계획 실측 필요). hook #129 ⓿병목 실측 +\n"
        "       지시 '전환이 성능을 악화시키면 되돌리고 보고' 적용 — 인라인 원형 존치. MAIN 동형 지점은 전환 유지(파리티 PASS). */\n")

out = live[:ls] + note + orig_seg + live[le:]
open('PKG_DMF0082_BODY_REVERTCUR_20260819.sql', 'w', encoding='utf-8', newline='').write(out)
print('orig_seg lines:', orig_seg.count('\n'), '| replaced lines:', live[ls:le].count('\n'))
print('markers:', {k: out.count(k) for k in
      ('E20260819-XLS81LOC', 'E20260819-MULTIJOIN', 'E20260819-SENDERJOIN', 'E20260819-PJTNAME')})
# 전환 잔재/원형 복원 확인
print('cur regexp restored:', out.count("CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))"))
print('cluster residue (GTT_TEMPSITEITEMALL delete):', out.count("DELETE FROM SCM_MGR.GTT_TEMPSITEITEMALL F"))
