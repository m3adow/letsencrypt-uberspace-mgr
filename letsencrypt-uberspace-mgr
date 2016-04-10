#!/usr/bin/env bash
set -e
set -u
set -o pipefail
set -x

LE_CONFIG_DIR=${LE_CONFIG_DIR:-${HOME}/.config/letsencrypt/}
LE_CONF=${LE_CONF:-"${LE_CONFIG_DIR}/cli.ini"}
LE_ARGS=${LE_ARGS:-"--agree-tos --non-interactive"}

DOMAINS_FILE=${DOMAINS_FILE:-${HOME}/etc/letsencrypt_domains.conf}

# Include Path to Uberspace scripts
PATH="${PATH}:/usr/local/bin/"

while read -u 42 DOMAIN_LINE
do
	# skip comments
	[[ "${DOMAIN_LINE:0:1}" == '#' ]] && continue

	# Save original cli.ini
	sed -i".sic" "/^domains =/ c\
		domains = ${DOMAIN_LINE}" "${LE_CONF}"
	letsencrypt certonly
	# Restore original cli.ini
	mv "${LE_CONF}.sic" "${LE_CONF}"
	LIVE_DIR="${LE_CONFIG_DIR}/live/${DOMAIN_LINE%%,*}/"
	uberspace-add-certificate -k "${LIVE_DIR}/privkey.pem" -c "${LIVE_DIR}/cert.pem"
done 42<"${DOMAINS_FILE}"
