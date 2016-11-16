#!/bin/bash
# directory containing repodata directory
TOPDIR=/var/www/html/repo/centos
# number of packages to keep, beyond 1-a-month rule
NUMKEEP=20

pushd ${TOPDIR}
for lane in `ls -d */* | grep -v repodata`
	do lastyearmonth=""
	for package in `ls -1 ${lane}/ | head -n -${NUMKEEP}`
		do if [ `echo ${package} | grep -cP '\d{14}'` -eq 0 ]
			then yearmonth=`echo ${package} | grep -Po '\d{4}\.\d{2}'`
			if [ "${yearmonth}" == "${lastyearmonth}" ]
			then
				rm -fr ${lane}/${package}
			else
				lastyearmonth=${yearmonth}
			fi
		fi
	done
done
createrepo --update --database .
rm -f repodata/repomd.xml.asc
gpg --detach-sign --armor repodata/repomd.xml
popd
