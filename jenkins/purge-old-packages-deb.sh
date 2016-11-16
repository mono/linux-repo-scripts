#!/bin/bash
# space separated list of package prefixes to treat as "the same"
# these have a * appended in a filter
# e.g. mono-snapshot-2 searches for mono-snapshot-2* so as to
# avoid counting mono-snapshot-common
PACKAGESETS="mono-4.0-snapshot-2 mono-4.2-snapshot-2 mono-4.4-snapshot-2 mono-4.6-snapshot-2 mono-4.8-snapshot-2 mono-snapshot-2 monodevelop-snapshot-2"
# number of packages to keep, beyond 1-a-month rule
NUMKEEP=20
# aptly repo to use
REPONAME="sid"

for packageset in ${PACKAGESETS}
	do lastyearmonth=""
	for package in $(aptly repo search -format '{{.Package}}' ${REPONAME} "Name (% ${packageset}*), \$Architecture (source)" 2> /dev/null| sort | head -n -${NUMKEEP})
		do if [ `echo ${package} | grep -cP '\d{14}'` -eq 0 ]
			then yearmonth=`echo ${package} | grep -Po '\d{4}\.\d{2}'`
			if [ "${yearmonth}" == "${lastyearmonth}" ]
			then
				aptly repo remove ${REPONAME} "\$Source (${package})"
			else
				lastyearmonth=${yearmonth}
			fi
		fi
	done
done
aptly publish update sid
aptly db cleanup
