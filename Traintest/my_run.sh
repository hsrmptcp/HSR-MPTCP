case $1 in
	--usb-mode    )    ./run_with_usb.sh
	                   ;;
	--file-mode   )    ./run.sh
	                   ;;
	--default | * )    ./new_run.sh
                       ;;
esac