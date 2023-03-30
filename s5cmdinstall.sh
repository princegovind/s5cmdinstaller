#! /bin/bash
#Created by Govind
if [ "$1" = "-e" ]; then



		echo -e "\n++++++++\nBucket endpoint configure\n++++++++"
		echo -e "Enter your bucket's Region. The complete endpoint is {REGION}.digitaloceanspaces.com. REGION is Bucket region like nyc3, fra1, sgp1."
		read new_region
		FILE=~/.bashrc
		DOSPACES=digitaloceanspaces.com
		var="${new_region}.${DOSPACES}"
		cur_region=$(grep ${DOSPACES} ${FILE} | awk -F '//' '{print $2}')
		echo -e "\nYou have entered your current region as $var. Continue....\n"
		if [[ $new_region != "" && $cur_region != "" ]]; then
		sed -i "s/${cur_region}/${var}/" ~/.bashrc
		fi
		echo -e "\n\ns5cmd version $(s5cmd version) Installed\n\n"
		exit 0






else
	echo -e "Installation running in $(pwd)"
	echo -e "\n+++++++\nDownloading s5cmd\n+++++++\n"
	FILE=s5cmd_2.0.0_Linux-64bit.tar.gz
	s5cmd_dir=s5cmd_install
	if [ -d "${s5cmd_dir}" ]; then
		echo -e "s5cmd directory exists. Skipping..."
	else
		$(mkdir $s5cmd_dir)
		echo -e "${s5cmd_dir} created"
	fi

	if [ -f "$FILE" ]; then
		echo -e "s5cmd_2.0.0_Linux-64bit.tar.gz Exists, Skipping download..."
	else
		$(wget -q --show-progress https://github.com/peak/s5cmd/releases/download/v2.0.0/s5cmd_2.0.0_Linux-64bit.tar.gz)
		echo -e "\nSUCCESS!!! File Downloaded"
	fi
	#unzip tar file
	$(tar -zxf s5cmd_2.0.0_Linux-64bit.tar.gz -C ~/s5cmd_install)
	echo "${FILE} extracted"
	AWS_CONFIG_FILE=~/.aws/credentials
	#check if .aws directory exists or create one
	if [ -d ~/.aws ]; then
		echo -e "\n.aws directory already exists. Skipping...."
		if [ -f ~/.aws/credentials ]; then
			echo -e "\n~/aws/credentials file exists too. Skipping..."
		else

			echo -e "\ncredentials file not found. Creating now...."
			$(touch ~/.aws/credentials)
			echo -e "\nCreated ~/.aws/credentials file. "
		fi
	else
		$(
			mkdir ~/.aws
			touch ~/.aws/credentials
		)
		echo -e "\nCreated ~/.aws/directory "
	fi

	echo -e "Moving s5cmd to /usr/local/bin"

	#softlink to /usr/local/bin
	#s5cmd_2.0.0_Linux-64bit.tar.gz
	ln -s ~/s5cmd_install/s5cmd /usr/local/bin
	echo -e "\nBinary Linked"
	#s5cmd setup
	echo -e "Setting up s5cmd"
	echo -e "\n+++++++\ns5cmd Installation\n+++++++\nEnter your Spaces Access Key and Secret Key"
	echo -e "\nSpaces Access Key"
	read access_key
	echo -e "[default]\naws_access_key_id = ${access_key}" >$AWS_CONFIG_FILE
	echo -e "\nSpaces Secret Key"
	read secret_key
	echo -e "aws_secret_access_key = ${secret_key}" >>$AWS_CONFIG_FILE
	echo -e "\ns5cmd configured\n$(cat ${AWS_CONFIG_FILE})"

	#configure bucket endpoint
		echo -e "\n++++++++\nBucket endpoint configure\n++++++++"
		echo -e "Enter your bucket's Region. The complete endpoint is {REGION}.digitaloceanspaces.com. REGION is Bucket region like nyc3, fra1, sgp1."
		read new_region
		FILE=~/.bashrc
		DOSPACES=digitaloceanspaces.com
		echo "You have entered your current region as $(cur_region). Continue...."
		cur_region=$(grep ${DOSPACES} ${FILE} | awk -F '//' '{print $2}')
		echo $cur_region
		if [[ $new_region != "" && $cur_region != "" ]]; then
		sed -i "s/${cur_region}/${var}/" ~/.bashrc
		fi
		echo -e "\n\ns5cmd version $(s5cmd version) Installed\n\n"
fi
echo -e "!!INSTALLATION SUCCESSFUL!!"