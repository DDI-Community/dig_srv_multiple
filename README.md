### Guide to Use `dig_srv_records.sh` for SRV Record Lookup

#### Step 1: Prepare the Environment

Before you start, you need to have a Linux environment with `dig` installed. The `dig` command is often part of the `dnsutils` package, which you can install using your package manager.

For example, on **Debian/Ubuntu**:
```bash
sudo apt-get update
sudo apt-get install dnsutils
```

#### Step 2: Create the `SRVrecords.txt` File

You need a file named `SRVrecords.txt` that contains a list of SRV records you want to resolve. Each SRV record should be on a separate line. Here’s an example of the file content:

**`SRVrecords.txt` example:**
```
_ldap._tcp.example.com
_sip._tcp.example.com
_kerberos._udp.example.com
_xmpp-server._tcp.example.org
```

In this example:
- `_ldap._tcp.example.com`: Queries for LDAP services in the domain `example.com`.
- `_sip._tcp.example.com`: Queries for SIP services for the domain `example.com`.
- `_kerberos._udp.example.com`: Queries for Kerberos services using UDP for `example.com`.
- `_xmpp-server._tcp.example.org`: Queries for XMPP server service for `example.org`.

#### Step 3: Create the Bash Script

Now, create the Bash script to read the list of SRV records from `SRVrecords.txt` and run `dig` for each.

1. **Create a new file named `dig_srv_records.sh`**:
   ```bash
   nano dig_srv_records.sh
   ```

2. **Paste the following script** into the file:
   ```bash
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
   ```

3. **Save and exit** (`CTRL + X`, then `Y`, then `Enter`).

4. **Make the script executable**:
   ```bash
   chmod +x dig_srv_records.sh
   ```

#### Step 4: Run the Script

You can run the script in two different ways, either specifying a DNS server to use or defaulting to the system-configured DNS server.

##### Option 1: Using a Specific DNS Server

If you want to query a specific DNS server (e.g., Google’s DNS at `8.8.8.8`):
```bash
./dig_srv_records.sh 8.8.8.8
```

- This will use the DNS server at `8.8.8.8` to resolve each SRV record listed in `SRVrecords.txt`.

##### Option 2: Using the Default DNS Server

If you do not specify a DNS server, the system will use the default DNS server that is configured:
```bash
./dig_srv_records.sh
```

- This is useful if you want to use the DNS server settings already defined on your machine.

#### Step 5: Interpret the Output

The script will provide output for each SRV record in `SRVrecords.txt`. Here’s an example output for `_ldap._tcp.example.com`:

```bash
Using DNS server: 8.8.8.8
Resolving SRV record: _ldap._tcp.example.com
0 100 389 ldap.example.com.

Resolving SRV record: _sip._tcp.example.com
0 100 5060 sipserver.example.com.
```

- Each line in the result shows the **priority**, **weight**, **port**, and **target host** for the SRV record.
  - Example: `0 100 389 ldap.example.com.` means:
    - **Priority**: 0 (lower value indicates higher priority)
    - **Weight**: 100 (used to determine the load distribution when multiple servers have the same priority)
    - **Port**: 389 (the port that the service is running on)
    - **Target Host**: `ldap.example.com` (the hostname providing the service)

#### Summary

- **SRVrecords.txt**: Contains the list of SRV records you want to query.
- **dig_srv_records.sh**: The script that runs `dig` against each SRV record in the file.
- Run the script with or without specifying a DNS server to get SRV record resolutions.

By following this guide, you can easily automate the process of checking multiple SRV records against the DNS server of your choice.
