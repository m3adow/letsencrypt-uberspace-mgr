#!/usr/bin/env bash
set -e
set -u
set -o pipefail
set -x

LE_CONFIG_DIR=${LE_CONFIG_DIR:-${HOME}/.config/letsencrypt/}
DOMAINS_FILE=${DOMAINS_FILE:-${HOME}/etc/letsencrypt_domains.conf}
DOMAIN_PLACEHOLDER=${DOMAIN_PLACEHOLDER:-%DOMAINS%}

LE_CONF=${LE_CONF:-"${LE_CONFIG_DIR}/cli.ini"}
LE_PATH=$(which letsencrypt)

while read -u 42 DOMAIN_LINE
do
	# skip comments
	[[ "${DOMAIN_LINE:0:1}" == '#' ]] && continue

	sed -i".sic" "/^domains =/ c\
		domains = ${DOMAIN_LINE}" "${LE_CONF}"
	${LE_PATH} certonly
	mv "${LE_CONF}.sic" "${LE_CONF}"
	LIVE_DIR="${LE_CONFIG_DIR}/live/${DOMAIN_LINE%%,*}/"
	uberspace-add-certificate -k "${LIVE_DIR}/privkey.pem" -c "${LIVE_DIR}/cert.pem"
done 42<"${DOMAINS_FILE}"
