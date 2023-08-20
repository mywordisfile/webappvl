#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

uuid=15ade4a8-774e-444e-afc1-2a3840f1e720
mypath=/fas30fdsa
myport=80


# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/myconfig.pb
{
	"inbounds": [
		{
			"port": $myport,
			"protocol": "vless",
			"settings": {
				"clients": [
					{
						"id": "$uuid"
					}
				],
			"decryption": "none"
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
					"path": "$mypath"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
mv -f ${DIR_TMP}/myconfig.pb ${DIR_CONFIG}/myconfig.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/v2ray run -config=${DIR_CONFIG}/myconfig.json
