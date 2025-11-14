@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"
echo:

set "BIN=%~dp0"
set "LISTS=%~dp0lists\"
set "FAKES=%~dp0fakes\"

start "(old config) TheFogIOF's config" /min "%BIN%winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-udp=443 --hostlist="%LISTS%list-general.txt" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fake-quic="%FAKES%quic_initial_google_com.bin" --new ^
--filter-tcp=80 --hostlist="%LISTS%list-general.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=badseq --new ^
--filter-tcp=443 --hostlist="%LISTS%list-general.txt" --dpi-desync=fake,split --dpi-desync-fooling=badseq --dpi-desync-split-seqovl-pattern="%FAKES%tls_clienthello_iana_org.bin" --dpi-desync-fake-tls-mod=sni=www.google.com
--filter-tcp=443 --hostlist="%LISTS%list-alt.txt" --dpi-desync=fake,fakedsplit --dpi-desync-fake-tls-mod=sni=none --dpi-desync-split-seqovl=681 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=7000 --new ^

exit