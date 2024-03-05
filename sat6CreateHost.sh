#!/bin/bash

usage() {
	cat <<EOF
Creates a host on a Satellite server

Usage: $0

        -g, --hostgroup     hostgroup ID
        -h, --host          host to create
        -i, --ip            IP address

        -l, --location_id   location ID
        -o, --org_id        organization ID

        -p, --password      password
        -s, --server        Satellite server
        -u, --user          username

EOF
	exit 0
}

createHost() {
	curl https://"${SERVER}"/api/hosts/ \
		-X POST \
		-k \
		-H "Content-Type: application/json" \
		--user "${USER}":"${PASS}" \
		-d "{\"host\":{\"name\":\"${HOST}\",\"location_id\":\"${LOCATION}\",\"organization_id\":\"${ORG}\",\"hostgroup_id\":\"${HOSTGROUP}\",\"build\":\"true\",\"managed\":\"true\",\"enabled\":\"true\",\"ip\":\"${IP}\"}}"
}

parseOptions() {
	[[ $# -eq 0 ]] && usage

	while test $# -gt 0; do
		key="$1"
		case "${key}" in
		-h | --host)
			HOST=${2}
			shift
			;;
		-g | --hostgroup)
			HOSTGROUP=${2}
			shift
			;;
		-i | --ip)
			IP=${2}
			shift
			;;
		-l | --location_id)
			LOCATION=${2}
			shift
			;;
		-o | --org_id)
			ORG=${2}
			shift
			;;
		-p | --password)
			PASS=${2}
			shift
			;;
		-s | --server)
			SERVER=${2}
			shift
			;;
		-u | --user)
			USER=${2}
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
	createHost
	exit 0
}

main "$@" || exit 1
