#!/bin/bash

usage() {
	cat <<EOF
Override repositories per host on a Satellite server

Usage: $0

        -s, --server       Satellite server
        -u, --user         username on Satellite server
        -p, --password     password for the user
        -h, --host         host to use
        -r, --repository   repository to use
        -e, --enable       enable the specified repository
        -d, --disable      disable the specified repository
EOF
	exit 0
}

getIdFromHostname() {
	HOSTID=$(curl https://"${SERVER}"/api/v2/hosts \
		-k \
		--header "Content-Type: application/json" \
		--user "${USER}":"${PASS}" \
		2>/dev/null |
		jq -r ".results[]|select(.name == \"$HOST\").id")
}

overrideRepositorySet() {
	curl https://"${SERVER}"/api/v2/hosts/"${HOSTID}"/subscriptions/content_override \
		-X PUT \
		-k \
		-H "Content-Type: application/json" \
		--user "${USER}":"${PASS}" \
		-d "{\"content_overrides\":[{\"content_label\":\"${REPO}\",\"name\":\"enabled\",\"value\":\"${ENABLE}\"}],\"host_id\":\"${HOSTID}\"}"
}

parseOptions() {
	[[ $# -eq 0 ]] && usage

	while test $# -gt 0; do
		key="$1"
		case "${key}" in
		-s | --server)
			SERVER=${2}
			shift
			;;
		-u | --user)
			USER=${2}
			shift
			;;
		-p | --password)
			PASS=${2}
			shift
			;;
		-r | --repository)
			REPO=${2}
			shift
			;;
		-h | --host)
			HOST=${2}
			shift
			;;
		-d | --disable)
			ENABLE=false
			shift
			;;
		-e | --enable)
			ENABLE=true
			shift
			;;
		*)
			usage
			;;
		esac
		shift
	done
}

main() {
	parseOptions "$@"
	getIdFromHostname
	overrideRepositorySet
	exit 0
}

main "$@" || exit 1
