## What It Does ##

This is a bash script to automate the process of testing the security of your wireless network. It uses tools such as aireplay-ng, aircrack-ng, airodump-ng to obtain WPA handshakes, and then try to crack the passphrase through a dictionary attack. 

More specifically, it automates:
1. Setting network card to monitor mode
2. Read access point and client MAC address
3. Obtain the channel the access point and client is on
4. Obtain handshake through deauthentication
5. Crack passphrase through dictionary attack

### Disclaimer ###
The bash script must only be used for
testing home/personal networks that you own. Do
not test on networks you do not own!
I am not reponsible for any action performed by
the user.
