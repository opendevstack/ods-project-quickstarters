#!/bin/bash
# this script checks for env variable HTTP_PROXY and add them to gradle.properties
# 
if [[ $HTTP_PROXY != "" ]]; then

	proxy=$(echo $HTTP_PROXY | sed -e "s|https://||g" | sed -e "s|http://||g")
	proxy_hostp=$(echo $proxy | cut -d "@" -f2)
	
	proxy_host=$(echo $proxy_hostp | cut -d ":" -f1)
	echo "$JAVA_OPTS -Dhttp.proxyHost=$proxy_host -Dhttps.proxyHost=$proxy_host" >> $GRADLE_USER_HOME/gradle.properties
	echo "$JAVA_OPTS -Dhttp.proxyHost=$proxy_host -Dhttps.proxyHost=$proxy_host" >> /tmp/gradle/wrapper/gradle-wrapper.properties
	
	proxy_port=$(echo $proxy_hostp | cut -d ":" -f2)
	echo "$JAVA_OPTS -Dhttp.proxyPort=$proxy_port -Dhttps.proxyPort=$proxy_port" >> $GRADLE_USER_HOME/gradle.properties
	echo "$JAVA_OPTS -Dhttp.proxyPort=$proxy_port -Dhttps.proxyPort=$proxy_port" >> /tmp/gradle/wrapper/gradle-wrapper.properties

	proxy_userp=$(echo $proxy | cut -d "@" -f1)
	if [[ $proxy_userp != $proxy_hostp ]]; 
	then
		proxy_user=$(echo $proxy_userp | cut -d ":" -f1)
		echo "$JAVA_OPTS -Dhttp.proxyUser=$proxy_user -Dhttps.proxyUser=$proxy_user" >> $GRADLE_USER_HOME/gradle.properties
		echo "$JAVA_OPTS -Dhttp.proxyUser=$proxy_user -Dhttps.proxyUser=$proxy_user" >> /tmp/gradle/wrapper/gradle-wrapper.properties
		proxy_pw=$(echo $proxy_userp | sed -e "s|$proxy_user:||g")
		echo "$JAVA_OPTS -Dhttp.proxyUser=$proxy_user -Dhttps.proxyUser=$proxy_user" >> $GRADLE_USER_HOME/gradle.properties
		echo "$JAVA_OPTS -Dhttp.proxyUser=$proxy_user -Dhttps.proxyUser=$proxy_user" >> /tmp/gradle/wrapper/gradle-wrapper.properties
 	fi
fi

if [[ $NO_PROXY != "" ]]; then
	noproxy_host=$(echo $NO_PROXY | sed -e "s/,/|/g")
	echo "$JAVA_OPTS -Dhttp.nonProxyHosts=$noproxy_host -Dhttps.nonProxyHosts=$noproxy_host" >> $GRADLE_USER_HOME/gradle.properties
	echo "$JAVA_OPTS -Dhttp.nonProxyHosts=$noproxy_host -Dhttps.nonProxyHosts=$noproxy_host" >> /tmp/gradle/wrapper/gradle-wrapper.properties
fi
