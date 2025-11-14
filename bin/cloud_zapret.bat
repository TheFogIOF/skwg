@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
:: 65001 - UTF-8

call "%~dp0config.bat"

set DISCORD_STRATEGY=--dpi-desync=fake --dpi-desync-repeats=6
set QUIC_STRATEGY=--dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%FAKE_QUIC%"
set UDP_STRATEGY=--dpi-desync=fake --dpi-desync-ttl=8 --dpi-desync-repeats=20 --dpi-desync-any-protocol=1 --dpi-desync-fooling=none --dpi-desync-fake-unknown-udp="%FAKE_UDP%" --dpi-desync-cutoff=n10
set SYNDATA_STRATEGY=--dpi-desync=syndata --dpi-desync-fooling=badseq,hopbyhop2 --dpi-desync-fake-tls="%FAKE_TLS%" --dpi-desync-cutoff=n4
set HTTP_STRATEGY=--dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-http="%FAKE_HTTP%"
set HTTPS_STRATEGY=--dpi-desync=multisplit --dpi-desync-split-pos=2,sniext+1 --dpi-desync-split-seqovl=679 --dpi-desync-split-seqovl-pattern="%FAKE_TLS%" --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ya.ru

set ARGS=--wf-tcp=80,443,444-65535 --wf-udp=443,50000-50100,444-65535

set ARGS=!ARGS! --filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun %DISCORD_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=443 --filter-l7=tls --ipset-ip=162.159.36.1,162.159.46.1,2606:4700:4700::1111,2606:4700:4700::1001 %HTTPS_STRATEGY% --new

set ARGS=!ARGS! --filter-udp=443 --hostlist="%ZAPRET_HOSTS%" --hostlist="%ZAPRET_HOSTS_AUTO%" %QUIC_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=80 --hostlist="%ZAPRET_HOSTS%" --hostlist-auto="%ZAPRET_HOSTS_AUTO%" %HTTP_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=443 --hostlist="%ZAPRET_HOSTS%" --hostlist-auto="%ZAPRET_HOSTS_AUTO%" %HTTPS_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=444-65535 --hostlist="%ZAPRET_HOSTS%" --hostlist-auto="%ZAPRET_HOSTS_AUTO%" %SYNDATA_STRATEGY% --new
set ARGS=!ARGS! --filter-udp=444-65535 --hostlist="%ZAPRET_HOSTS%" --hostlist="%ZAPRET_HOSTS_AUTO%" %UDP_STRATEGY% --new

set ARGS=!ARGS! --filter-udp=443 --ipset="%ZAPRET_IPSET%" %QUIC_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=80 --ipset="%ZAPRET_IPSET%" %HTTP_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=443 --ipset="%ZAPRET_IPSET%" %HTTPS_STRATEGY% --new
set ARGS=!ARGS! --filter-tcp=444-65535 --ipset="%ZAPRET_IPSET%" %SYNDATA_STRATEGY% --new
set ARGS=!ARGS! --filter-udp=444-65535 --ipset="%ZAPRET_IPSET%" %UDP_STRATEGY%

if not exist "%ZAPRET_HOSTS_AUTO%" (
	type NUL >"%ZAPRET_HOSTS_AUTO%"
)

start "TheFogIOF's config: %~n0" /min "%ZAPRET_BIN%winws.exe" %ARGS%

exit