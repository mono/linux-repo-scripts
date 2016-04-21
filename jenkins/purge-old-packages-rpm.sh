#!/bin/bash
# directory containing repodata directory
TOPDIR=/var/www/html/repo/centos
# number of packages to keep, beyond 1-a-month rule
NUMKEEP=20

pushd ${TOPDIR}
for lane in `ls -d */* | grep -v repodata`
	do lastyearmonth=""
	for package in `ls -1 ${lane}/ | head -n -${NUMKEEP}`
		do echo "evaluating $package"
		if [ `echo ${package} | grep -cP '\d{14}'` -gt 0 ]
		then echo "old date format, ignore"
		else
			yearmonth=`echo ${package} | grep -Po '\d{4}\.\d{2}'`
			if [ "${yearmonth}" == "${lastyearmonth}" ]
			then
				echo "deleteytime"
				echo rm -r ${package}
			else
				lastyearmonth=${yearmonth}
				echo "seeing ${lastyearmonth}"
			fi
		fi
	done
done
popd
