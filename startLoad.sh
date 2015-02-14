#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$DIR"

declare -a combos
declare -a collectors

combos=(
"OS=7.0,name=iPad 2"
"OS=7.1,name=iPad 2"
"OS=8.1,name=iPad 2"
"OS=7.0,name=iPad Air"
"OS=7.1,name=iPad Air"
"OS=8.1,name=iPad Air"
"OS=7.0,name=iPad Retina"
"OS=7.1,name=iPad Retina"
"OS=8.1,name=iPad Retina"
"OS=7.0,name=iPhone 4s"
"OS=7.1,name=iPhone 4s"
"OS=8.1,name=iPhone 4s"
"OS=7.0,name=iPhone 5"
"OS=7.1,name=iPhone 5"
"OS=8.1,name=iPhone 5"
"OS=7.0,name=iPhone 5s"
"OS=7.1,name=iPhone 5s"
"OS=8.1,name=iPhone 5s"
"OS=8.1,name=iPhone 6 Plus"
"OS=8.1,name=iPhone 6"
"OS=8.1,name=Resizable iPad"
"OS=8.1,name=Resizable iPhone"
)

collectors=(
"demo1"
"demo2"
)

IFS='%'
while true; do
	for i in ${combos[@]}; do
		echo "Running " "${i[0]}"
		for d in ${collectors[@]}; do
			echo "Collector "${d[0]}
	                cp "EUMConfig/Root.plist."${d[0]} Settings.bundle/Root.plist

	                xcodebuild -project Ecommerce\ Mobile\ Application.xcodeproj -configuration Release
	                xcodebuild -project Ecommerce\ Mobile\ Application.xcodeproj -configuration Debug

			xcodebuild test -project Ecommerce\ Mobile\ Application.xcodeproj -scheme "AcmeMobileShopping" -destination-timeout 1 -destination ${i[0]}
		done
	done
done
