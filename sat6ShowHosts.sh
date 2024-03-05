#!/bin/bash

usage() {
	cat <<EOF
Usage: $0 -s server -u user -p pass

Lists host names and host IDs registered to a Satellite Server in CSV format
EOF
	exit 0
}

parseOptions() {
	[[ $# -eq 0 ]] && usage

	while getopts ":s:u:p:" opt; do
		case "${opt}" in
		s)
			SERVER=${OPTARG}
			;;
		u)
			USER=${OPTARG}
			;;
		p)
			PASS=${OPTARG}
			;;
		*)
			usage
			;;
		esac
	done
	shift $((OPTIND - 1))
}

getHostnameAndId() {
	curl https://"${SERVER}"/api/v2/hosts \
		-k \
		--user "${USER}":"${PASS}" \
		--header "Content-Type: application/json" \
		2>/dev/null |
		jq -r '.results[]|.name + "," + (.id|tostring)'
}

main() {
	parseOptions "$@"
	getHostnameAndId
	exit 0
}

main "$@" || exit 1
