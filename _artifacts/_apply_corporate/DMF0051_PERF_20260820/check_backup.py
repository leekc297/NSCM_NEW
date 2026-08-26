import io,sys,pathlib
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
# 산출물 보호 점검 (코디네이터 지적 5) — 백업이 패치본으로 덮여있지 않은지
for f in ["00_BACKUP_PKG_DMF0051_BODY.sql","00_BACKUP_PKG_DMF0051_BODY_raw.sql"]:
    t=pathlib.Path(f).read_text(encoding="utf-8")
    bad=[m for m in ["D51SCALAR","D51REGROUP","D51SEMI","D51ITEMPFX"] if m in t]
    print(f"  {f}: {len(t)} bytes / D51 마커 {bad if bad else '없음(정상 — 패치 전 원본)'}")
    assert not bad, "백업이 패치본으로 오염됨"
t=pathlib.Path("PKG_DMF0051_BODY_LIVE.sql").read_text(encoding="utf-8")
print(f"  PKG_DMF0051_BODY_LIVE.sql(패치 소스): D51 마커 {'있음(오염!)' if 'D51SCALAR' in t else '없음(정상)'}")
assert "D51SCALAR" not in t
print("[산출물 보호] 백업 2본 + 패치 소스 무결 OK")
