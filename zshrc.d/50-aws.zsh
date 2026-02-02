#
# AWS tools
#

function aws-env {
	##########################################################################
	# Convenience function for setting aws environment variables from
	#  ~/.aws/credentials
	###########################################################################

	local USAGE="$0 <profile-name>\nFor example: $0 default"

	if [ -z "$1" ]; then
		echo $USAGE
		return 1
	elif [[ $* == *-h* ]]; then
		echo $USAGE
		return 0
	else
		local PROFILE=$1
	fi

	export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile $PROFILE)
	export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile $PROFILE)
	export AWS_DEFAULT_REGION=$(aws configure get region --profile $PROFILE)
	# Set this so that powerlevel10k can display the current AWS profile
	export AWS_DEFAULT_PROFILE=$PROFILE
}

function aws-unset {
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_DEFAULT_REGION
        unset AWS_DEFAULT_PROFILE
}

# Enable shell autocompletion for eksctl
if is_bin_in_path eksctl; then
    source <(eksctl completion zsh)
fi
