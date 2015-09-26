#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$DIR"

declare -a combos
declare -a collectors

combos=(
"OS=8.2,name=iPhone 6"
)

collectors=(
"demo1"
"demo2"
)

IFS='%'

#cd Pods/
#xcodebuild -project Pods.xcodeproj -configuration Release
#xcodebuild -project Pods.xcodeproj -configuration Debug
#cd ..

while true; do
	for i in ${combos[@]}; do
		echo "Running " "${i[0]}"
		for d in ${collectors[@]}; do
			echo "Collector "${d[0]}

			#if [[ $string == *"id="* ]]
			#then
			#	xcodebuild clean
			#	cp "PodsLibs/device/libPods-UI Tests-KIF.a" Pods/build/Debug-iphoneos/
			#	cp "PodsLibs/device/libPods-UI Tests.a" Pods/build/Debug-iphoneos/
			#	cp "PodsLibs/device/libPods-UI Tests-KIF.a" Pods/build/Release-iphoneos/
			#	cp "PodsLibs/device/libPods-UI Tests.a" Pods/build/Release-iphoneos/
			#else
			#	xcodebuild clean
			#	cp "PodsLibs/simulator/libPods-UI Tests-KIF.a" Pods/build/Debug-iphoneos/
			#	cp "PodsLibs/simulator/libPods-UI Tests.a" Pods/build/Debug-iphoneos/
			#	cp "PodsLibs/simulator/libPods-UI Tests-KIF.a" Pods/build/Release-iphoneos/
			#	cp "PodsLibs/simulator/libPods-UI Tests.a" Pods/build/Release-iphoneos/
			#fi
	                cp "EUMConfig/Root.plist."${d[0]} ECommerce-Mobile/Settings.bundle/Root.plist

	                xcodebuild -project ECommerce-Mobile.xcodeproj -configuration Release
	                xcodebuild -project ECommerce-Mobile.xcodeproj -configuration Debug

			xcodebuild test -project ECommerce-Mobile.xcodeproj -scheme "ECommerce-iOSUITests" -destination-timeout 1 -destination ${i[0]}
		done
	done
done
