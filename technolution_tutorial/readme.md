RISC-V 4th workshop - tutorial session by Technolution
=======
This is a short intro to the commands for the tutorial session of Technolution held at the 4th RISC-V workshop. The 
tutorial shows a simple buffer overflow exploit example. In the presentation a number of examples are given how 
RISC-V can help to prevent an embedded system to be completely comprimized after an exploit is found.


Virtualbox setup
-----------
* Extract virtualbox image.
* Make sure the programmer is selected as usb device in virtualbox.  Go to Settings > USB > Add USB Filter > Microsemi Embedded FLashPro5.

![Usb-virtualbox](manual/img/usb-virtualbox.png?raw=true "Usb-virtualbox")

Get code
-----------
* Open terminal

    $git clone  https://github.com/Technolution/riscv-security-tutorial.git
    
Program FPGA
-----------
    $./start_FPExpress
    
* Click New..
* Select programming job file: riscv-security-tutorial/fpga/sf2_1_full.job

![Settings terminal](manual/img/new-job-flash.png?raw=true "FPExpress programming startup windows")
* Click the large RUN button
 
You should now see blinking leds on the FPGA. Furthermore, you should already have access to the terminal and 
see a command prompt.

Make FreeRTOS application
-------------------------
	$ cd riscv-security-tutorial/appl/
	$ make
	
Open serial terminal
-----------
    $ cd riscv-security-tutorial/tools/terminal
    $ ./wxTerminal.pyw
    
* Select port: /dev/ttyUSB2
* Leave the other settings as is.

![Settings terminal](manual/img/settings-terminal.png?raw=true "Settings terminal")

Try application commands
-----------
    rush
    normal
    stats

Exploit the application
=======================
We will now use a simple and small binary to exploit our application. 

Make exploit
-----------
This is a simple application that will download and create an buffer overflow. It will cause the leds to create an 
invalid combination.

	$ cd riscv-security-tutorial/exploit/
	$ make
	
Upload exploit & payload
-----------
Use the upload blob feature from the terminal to upload a binary image via the terminal interface. With the normal
application we will see echo's of all characters. Note that the menu in ubuntu is located at the top of the screen
and only visible when you hover with the mouse over the tob bar.

* Tools > Upload blob..

![Upload blob](manual/img/upload_blob.png?raw=true "Tools -> Upload Blob...")

* Select riscv-security-tutorial/exploit/build/exploit.raw 
	

Exploit bootstrapping
=======================
The buffer only allows very small applications. We will now use a bootstrap mechanism with a downloader to load a 
bigger exploid program. We will start from the normal terminal of the program. To be sure you are running from the right prompt, reset you board.

Make exploit downloader
-----------
This is a simple application that will download and create an buffer overflow. It will cause the leds to create an 
invalid combination.

    $ cd riscv-security-tutorial/exploit_downloader/
    $ make
    

Make payload
-----------
The payload is a simple application that will force the leds in an invalid combination and print to the terminal.
It is however to big to load in the exploitable buffer directly.

	$ cd riscv-security-tutorial/payload/
	$ make


Upload exploit & payload
-----------
* Tools > Upload blob..
* Select riscv-security-tutorial/exploit_downloader/build/exploit_downloader.raw 
* See ready...

![exploit](manual/img/exploit.png?raw=true "exploit")
* Tools > Upload blob..
* Select riscv-security-tutorial/payload/build/payload.raw
* See HACKED

![HACKED](manual/img/hacked.png?raw=true "HACKED")

