import pathlib
s = pathlib.Path('Doc/gen/SCP0122/SCP0122_PKG.sql').read_text(encoding='utf-8')
pathlib.Path('_artifacts/_diagnostics/_tmp_SCP0122_PORTCHK.sql').write_text(s.replace('PKG_SCP0122', 'PKG_SCP0122_PORTCHK'), encoding='utf-8')
print('ok')
