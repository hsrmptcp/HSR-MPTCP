# CellRecord

CellRecord is an application that can capture and record various information in eight files. In our experiments, we only use **Cell.txt**, **Handoff.txt**, **Signal.txt** and **Speed.txt** to record cellular network information and the GPS information.
+ **Cell.txt & Handoff.txt** `timestamp Cellular-type Basestation-id Cell-id flag`
> **Cell.txt** and **Handoff.txt** is a file recording the handoff information. `timestamp` is the time when handoff hanppens. `Cellular-type` is the type of new cellular newtork and we will list all the cellular network type with their corresponding type-id in the table below. `Basestation-id` `Cell-id` are the basestation ID and cell ID of the new cellular network. `flag` is a historical thing and is abandoned. 

Cellular Network Type | Network-ID
--------------------- | ---------- 
1 | 2

+ **Signal.txt** ``timestamp RSRP RSRQ ?? ?? ?? Cell-id Basestation-id``
> **Signal.txt** is a file recording the signal information. We capture the information for every 5 secends. `timestamp` is the record time. `RSRP` is the *Reference Signal Received Power* and `RSRQ` is the *Reference Signal Received Quality*. ?? ?? ??. `Cell-id` and `Basestation-id` is the same with above.

+ **Speed.txt** ``timestamp flag speed latitude longtitude ??``
> **Speed.txt** is a file recording the speed information based on GPS. We add a new item when we receive a new GPS record. `timestamp` is the record time. And the record is *available* when the `flag` is Available. The next is the speed, with the unit of *kilometers per hour* and the next two are latitude and longtitude. ??

# run.sh
## Scripts
```bash
run.sh [--usb-mode] [--file-mode] [--default]
```
The `run.sh` is a script to run our experiments. We have three type of running mode to run different experiments, using `wget` to download file from our servers. Our servers have installed MPTCP v0.91 and multiple softwares such like `ssh` and `tcpdump`. If we have no optional argument, then the script will run in default mode.

> **Default Mode** When script run in default mode, the script will run loop to download files from our server for each 3 minutes for one experiment. For each experiment, we will run `wget` in 2 minutes and leave the other time left to use `ssh` to modify the configurations of servers. For fully using the 2 minutes to download files, the files in the server has enough size, which means no experiment will stop until 2 minutes.

> **USB Mode** When script run in usb mode, it means we use usb modern as NIC to download files from our server. Other configuration has the same with that for **Default Mode**. 

> **File Mode** When script run in file mode, it will download various size of files. Different with **Default Mode**, files in **File Mode** has different size and it will not start a new `wget` until current one finish. This mode is used to testify how the size of files affect the diversity rate of file transmission.

## Environments
Our experiment configuration is saved in the `settings` directory, where 5 files are there. Each file may has several lines, which will be selected randomly by the script for each experiment.

> **buffer_size.txt** This file is used to save the optional size of buffer. 

> **congestion_control.txt** This file is used to save the optional congestion control algorithm.

> **scheduler.txt** This file is used to save the optional MPTCP scheduler.

> **filelist.txt** This file is used to save the optional file names. For each file, it is stored at `<SERVER>:/etc/www/blocks`. 