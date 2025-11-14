@echo off

set "SCRIPTS_DIR=%~dp0"

@REM if "%1"=="" (
@REM 	set ZAPRET_BIN="%~dp0"
@REM ) else (
@REM 	set ZAPRET_BIN="%1"
@REM )
set "ZAPRET_BIN=%~dp0"
set "ZAPRET_LISTS=%ZAPRET_BIN%lists\hosts\"
set "ZAPRET_CUSTOM=%ZAPRET_BIN%custom\"
set "ZAPRET_FAKES=%ZAPRET_BIN%fakes\"

@REM HOST/IPSET files begin
set "ZAPRET_IPSET=%ZAPRET_LISTS%zapret-ipset.txt"
set "ZAPRET_HOSTS=%ZAPRET_LISTS%zapret-hosts.txt"
set "ZAPRET_HOSTS_AUTO=%ZAPRET_LISTS%zapret-hosts-auto.txt"
@REM end

@REM FAKES begin
set "FAKE_QUIC=%ZAPRET_FAKES%quic_initial_www_google_com.bin"
set "FAKE_UDP=%ZAPRET_FAKES%quic_initial_www_google_com.bin"
set "FAKE_HTTP=%ZAPRET_FAKES%http_iana_org.bin"
set "FAKE_TLS=%ZAPRET_FAKES%tls_clienthello_www_google_com.bin"
@REM end