# -*- coding: utf-8 -*-
import io, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
root = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260826_PENDING")
rp = root / "README.md"
r = rp.read_text(encoding="utf-8")
r = r.replace("**적용 순서: `21` → `23` → `24` → `25` → `02` → `90`**",
              "**적용 순서: `21` → `23` → `24` → `25` → `26` → `02` → `90`**")
a25 = "(계층 들여쓰기 표기 정본. 타 17개 소비 화면 무영향) |"
assert a25 in r
r = r.replace(a25, a25 + "\n| 26 | `26_LOOKUP_INSMEAS81.sql` | 멱등 MERGE 8행 | `DM_UI_EDITABLE_MEASURE` 81 계열 Insert 후보 — 전 6 division MKT_FCST(Y) + 81/81_UC VMI_In_Req(N). 81 Insert 콤보 LOC-만 결손 정정. AS_In_Req/TMM_FCST 미등재(저장 SP 81 게이트 밖 — silent no-op 방지) |")
rp.write_text(r, encoding="utf-8")
print("README 갱신", flush=True)

lp = pathlib.Path(r"C:\Projects\NSCM\Doc\단위테스트_보완대상\보완요청_원장.md")
t = lp.read_text(encoding="utf-8")
anchor = "MktFcstGrid L891 \ud30c\ub9ac\ud2f0). \uac80\uc99d \ub3c4\uad6c PASS |"
assert t.count(anchor) == 1
row = ("\n| REQ:CHAT-20260826-6 | \ub300\ud654 \uc9c0\uc815 2026-08-26 | 81 division ADMIN INSERT \uc2dc \uc785\ub825\uac00\ub2a5 \uba54\uc800\uac00 LOC \ub9cc \ubcf4\uc784 | DMF0082 "
       "| EV:_artifacts/_deploy_packages/DMF0082_CLOUD_20260826_PENDING/A_DB/26_LOOKUP_INSMEAS81.sql::E20260826-INSMEAS81 | VERIFIED | Y | N "
       "| \uc6d0\uc778: Insert \ucf64\ubcf4 \uc6d0\ucc9c DM_UI_EDITABLE_MEASURE 81 \uacc4\uc5f4\uc774 LOC 1\ud589\ubfd0 (8/25 'GET_ADMIN \ud55c\uc815' \uc6d0\ubcf5 \ud6c4 Excel Form \ucd95\uc73c\ub85c LOC \ub9cc \uc7ac\ub4f1\uc7ac\ub41c \uacbd\uc704). "
       "\uc815\ub2f5 \ucd95=MKT_FCST_MEASURE \uc815\ubcf8 x \uc800\uc7a5 SP 81 MERGE \uac8c\uc774\ud2b8('MKT_FCST','VMI_In_Req') \uad50\uc9d1\ud569 \u2014 \uc804 6 div MKT_FCST(Y)+81/81_UC VMI_In_Req(N) \ub4f1\uc7ac. "
       "AS_In_Req\u00b7TMM_FCST \ubcf4\ub958(\uc800\uc7a5 \uac8c\uc774\ud2b8 \ubc16 silent no-op \ubc29\uc9c0\u00b7TMM \uc2b9\uc778 \uac8c\uc774\ud2b8 TMM_MEASURE_ADMIN 81=70\ud589 \ubbf8\uc774\uc2dd). "
       "\uac80\uc99d: \ucf64\ubcf4 \uc2e4\ud589(81)=MKT FCST[R+P]+LOC\u00b7Excel Form LOC \ucd95 \ubd88\ubcc0(6)\u00b7\uba71\ub4f1 |")
t = t.replace(anchor, anchor + row)
lp.write_text(t, encoding="utf-8")
print("원장 REQ-6 등재", flush=True)
