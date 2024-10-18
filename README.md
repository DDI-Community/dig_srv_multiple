Guide: Running dig to Query SRV Records with a Custom DNS Server

This guide will walk you through setting up and using a Bash script to query SRV (Service) records for multiple domains using the dig command. The script allows you to specify a DNS server to query against, or if no DNS server is provided, it will use the default system DNS.

Prerequisites:

	1.	Linux-based system or any system with Bash and dig installed.
	2.	A list of SRV records you want to query.
	3.	Basic knowledge of running scripts in Bash.

Step-by-Step Instructions

Step 1: Create SRVrecords.txt

	1.	Create a file called SRVrecords.txt in the same directory where you’ll place the script.
	2.	Add the SRV records you want to query to the file, one per line.

An SRV record typically follows the format:

_service._protocol.domain

For example:

	•	_ldap._tcp.example.com: LDAP service over TCP for example.com
	•	_sip._udp.example.com: SIP service over UDP for example.com

Here’s an example SRVrecords.txt:

_ldap._tcp.example.com
_sip._udp.example.com
_kerberos._tcp.example.com
_smtp._tcp.mail.example.com

Each line represents an SRV record that the script will query.

Step 2: Create the Bash Script

	1.	Open a text editor (such as nano or vi) and create a new file named dig_srv_records.sh.

nano dig_srv_records.sh


	2.	Copy and paste the following script into the file:

#!/bin/bash

# Check if SRVrecords.txt exists
if [ ! -f SRVrecords.txt ]; then
    echo "SRVrecords.txt not found! Please create the file and list SRV records in it."
    exit 1
fi

# Check if a DNS server was provided as an argument
if [ $# -eq 0 ]; then
    echo "No DNS server specified. Using the default DNS server."
    dns_server=""
else
    dns_server="@${1}"
    echo "Using DNS server: $1"
fi

# Read each line from SRVrecords.txt and run dig for SRV records
while read -r srv_record; do
    if [[ -n "$srv_record" ]]; then
        echo "Resolving SRV record: $srv_record"
        dig +short SRV "$srv_record" $dns_server
        echo ""
    fi
done < SRVrecords.txt


	3.	Save the file and exit the editor (for nano, press CTRL+X, then Y, and Enter).

Step 3: Make the Script Executable

In the terminal, run the following command to make the script executable:

chmod +x dig_srv_records.sh

Step 4: Run the Script

You can now run the script in two ways:

	1.	Using the Default DNS Server:
If you don’t specify a DNS server, the script will use the system’s default DNS server.
Run the script without any arguments:

./dig_srv_records.sh


	2.	Using a Specific DNS Server:
You can also specify a DNS server (IP or hostname) as an argument.
For example, to use Google’s public DNS server (8.8.8.8):

./dig_srv_records.sh 8.8.8.8



Example Outputs

Example 1: Using the default DNS server

No DNS server specified. Using the default DNS server.
Resolving SRV record: _ldap._tcp.example.com
0 100 389 ldapserver.example.com.

Resolving SRV record: _sip._udp.example.com
10 100 5060 sipserver.example.com.

Resolving SRV record: _kerberos._tcp.example.com
0 100 88 kerberos.example.com.

Resolving SRV record: _smtp._tcp.mail.example.com
0 100 25 mailserver.example.com.

Example 2: Using a custom DNS server (e.g., 8.8.8.8)

Using DNS server: 8.8.8.8
Resolving SRV record: _ldap._tcp.example.com
0 100 389 ldapserver.example.com.

Resolving SRV record: _sip._udp.example.com
10 100 5060 sipserver.example.com.

Resolving SRV record: _kerberos._tcp.example.com
0 100 88 kerberos.example.com.

Resolving SRV record: _smtp._tcp.mail.example.com
0 100 25 mailserver.example.com.

In both examples, the SRV records are resolved, and the results show the priority, weight, port, and hostname of the server providing the service.

Customizing and Troubleshooting

	1.	Modifying the SRVrecords.txt file:
	•	You can add or remove SRV records in SRVrecords.txt as needed. Make sure each line is a valid SRV record format.
	2.	Verifying DNS resolution:
	•	If a record doesn’t resolve, dig will simply output no information for that query. You can check if the DNS server you are querying is correctly configured to serve the SRV records.
	3.	Handling Multiple DNS Servers:
	•	If you want to test the same SRV records against multiple DNS servers, you can run the script repeatedly with different DNS server arguments.

Conclusion

By following this guide, you can easily query multiple SRV records against any DNS server using a custom script. This is useful for troubleshooting or verifying DNS configurations for services like LDAP, SIP, Kerberos, and more.

Let me know if you need further assistance!
