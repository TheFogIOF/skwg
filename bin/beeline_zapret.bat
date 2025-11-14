@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"
echo:

set "BIN=%~dp0"
set "LISTS=%~dp0lists\"
set "FAKES=%~dp0fakes\"

start "(old config) TheFogIOF's config" /min "%BIN%winws.exe" --wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-pos=2,sniext+1 --dpi-desync-split-seqovl=679 --dpi-desync-split-seqovl-pattern="%FAKES%tls_clienthello_www_google_com.bin" --new ^
--filter-udp=443 --hostlist="%LISTS%list-general.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%FAKES%quic_initial_www_google_com.bin" --new ^
--filter-tcp=80 --hostlist="%LISTS%list-general.txt" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%LISTS%list-general.txt" --dpi-desync=multisplit --dpi-desync-split-pos=2,sniext+1 --dpi-desync-split-seqovl=679 --dpi-desync-split-seqovl-pattern="%FAKES%tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%list-alt.txt" --dpi-desync=fake,fakedsplit --dpi-desync-fake-tls-mod=sni=none --dpi-desync-split-seqovl=681 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=7000 --new ^
--filter-udp=443 --ipset="%LISTS%ipset-discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%FAKES%quic_initial_www_google_com.bin" --new ^
--filter-tcp=80 --ipset="%LISTS%ipset-discord.txt" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig

exit