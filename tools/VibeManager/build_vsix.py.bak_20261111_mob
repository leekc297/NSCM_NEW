#!/usr/bin/env python3
"""vsce 없이 .vsix 패키징 — 오프라인 노트북용"""
import json, os, zipfile
here = os.path.dirname(os.path.abspath(__file__)); pkg = json.load(open(os.path.join(here, 'package.json'), encoding='utf-8'))
ver = pkg['version']; out = os.path.join(here, 'dist', f"{pkg['name']}-{ver}.vsix"); os.makedirs(os.path.dirname(out), exist_ok=True)
manifest = f'''<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011" xmlns:d="http://schemas.microsoft.com/developer/vsx-schema-design/2011">
  <Metadata>
    <Identity Language="ko-KR" Id="{pkg['name']}" Version="{ver}" Publisher="{pkg['publisher']}" />
    <DisplayName>{pkg['displayName']}</DisplayName>
    <Description xml:space="preserve">{pkg['description']}</Description>
    <Tags>NSCM,Claude Code,migration</Tags>
    <Categories>Other</Categories>
    <GalleryFlags>Private</GalleryFlags>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="{pkg['engines']['vscode']}" />
      <Property Id="Microsoft.VisualStudio.Code.ExtensionDependencies" Value="" />
      <Property Id="Microsoft.VisualStudio.Code.ExtensionPack" Value="" />
      <Property Id="Microsoft.VisualStudio.Code.ExtensionKind" Value="workspace" />
      <Property Id="Microsoft.VisualStudio.Code.LocalizedLanguages" Value="" />
    </Properties>
  </Metadata>
  <Installation><InstallationTarget Id="Microsoft.VisualStudio.Code"/></Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true" />
    <Asset Type="Microsoft.VisualStudio.Services.Content.Details" Path="extension/README.md" Addressable="true" />
    <Asset Type="Microsoft.VisualStudio.Services.Content.Changelog" Path="extension/CHANGELOG.md" Addressable="true" />
  </Assets>
</PackageManifest>'''
ctypes = '''<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension=".json" ContentType="application/json"/><Default Extension=".vsixmanifest" ContentType="text/xml"/>
  <Default Extension=".js" ContentType="application/javascript"/><Default Extension=".md" ContentType="text/markdown"/>
  <Default Extension=".svg" ContentType="image/svg+xml"/><Default Extension=".txt" ContentType="text/plain"/>
</Types>'''
files = ['package.json', 'extension.js', 'prompt-panel.js', 'flow-panel.js', 'history.js', 'workbench.js', 'tabview.js', 'quick.json', 'steps.json', 'README.md', 'CHANGELOG.md', 'CONCEPT.md', 'media/vibe.svg', 'media/vibe-color.png', 'media/vibe-color.svg']
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    z.writestr('[Content_Types].xml', ctypes); z.writestr('extension.vsixmanifest', manifest)
    for f in files:
        p = os.path.join(here, f)
        if os.path.exists(p): z.write(p, 'extension/' + f)
print(out, os.path.getsize(out), 'bytes')
