# -*- coding: utf-8 -*-
"""DMF0074 전용 스윕 도구를 화면 파라미터화 버전으로 파생 생성."""
import pathlib

src = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_dmf0074_deploy_axis_sweep.py")
t = src.read_text(encoding="utf-8")

t = t.replace('"""DMF0074 클라우드 이관 대상 축 전수 스윕',
              '"""화면별 클라우드 이관 대상 축 전수 스윕 — 인자로 MENU_ID 지정\n\n원본: _dmf0074_deploy_axis_sweep.py')
t = t.replace('MENU = "DMF0074"',
              'MENU = (sys.argv[1] if len(sys.argv) > 1 else "DMF0074")')
t = t.replace('PATTERNS = ["DMF0074"]          # DMF0074_40 도 LIKE \'%DMF0074%\' 로 포함',
              'PATTERNS = [MENU]               # 접미 변형(예: DMF0074_40)도 LIKE 로 포함')
t = t.replace(
    'FE_DIR = pathlib.Path(r"C:\\Projects\\NSCM\\nscm-fe\\features\\demand\\src\\pages\\metal-link-price")',
    'FE_MAP = {"DMF0074": "metal-link-price", "DMF0014": "customer-fcst-upload"}\n'
    'FE_DIR = pathlib.Path(r"C:\\Projects\\NSCM\\nscm-fe\\features\\demand\\src\\pages") / FE_MAP[MENU]')
t = t.replace(
    'OUT = pathlib.Path(r"C:\\Projects\\NSCM\\_artifacts\\_deploy_packages\\DMF0074_CLOUD_20260818\\_survey")',
    'OUT = pathlib.Path(r"C:\\Projects\\NSCM\\_artifacts\\_deploy_packages") / f"{MENU}_CLOUD_20260818" / "_survey"')

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_ui_deploy_axis_sweep.py")
out.write_text(t, encoding="utf-8")
print("생성:", out)
for k in ("MENU =", "PATTERNS =", "FE_DIR =", "OUT ="):
    print("  ", [l for l in t.splitlines() if l.startswith(k)])
