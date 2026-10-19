import pathlib
p=pathlib.Path("fixed_all/PKG_DMF0044.PACKAGE_BODY.sql"); s=p.read_text(encoding="utf-8"); L=s.split("\n")
i=8027-1
old="\t\t\t\t\t\t, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, '/'), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID"
assert L[i]==old, repr(L[i][:120])
assert "CASE WHEN( NVL(A.CURRENCY, '/') = '/' ) THEN ''" in L[8006-1] and "ELSE NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') END" in L[8007-1]
L[i]="\t\t\t\t\t\t, A.FCST_TYPE, A.INCOTERMS, CASE WHEN( NVL(A.CURRENCY, '/') = '/' ) THEN '' ELSE NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') END /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식(L8006~8007) */, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID"
p.write_text("\n".join(L),encoding="utf-8"); print("PKG_DMF0044 L8027 fixed")
