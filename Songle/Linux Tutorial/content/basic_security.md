## Linux security
By default, Linux has several account types in order to isolate processes and workloads:

1. **root**
2. **system**
2. **normal**
3. **network**

For a safe environment, it is advised to grant the minimum privileges possible and necessary to accounts, and remove inactive accounts. The ``last`` command, which shows the last time each user logged into the system, can be used to help identify potentially inactive accounts which are candidates for system removal.
```
# last
adriano  pts/4        10.10.10.113     Thu Feb 19 16:50   still logged in
mina     pts/2        10.10.10.113     Thu Feb 19 16:39   still logged in
root     pts/1        10.10.10.113     Thu Feb 19 16:25 - 16:25  (00:00)
root     pts/0        10.10.10.113     Thu Feb 19 15:42   still logged in
adriano  pts/3        10.10.10.246     Wed Feb 18 17:53 - 18:44  (00:51)
root     pts/2        10.10.10.99      Wed Feb 18 17:14 - 18:44  (01:30)
adriano  pts/1        10.10.10.246     Wed Feb 18 16:57 - 19:19  (02:22)
root     pts/0        10.10.10.246     Wed Feb 18 16:25 - 19:19  (02:53)
root     pts/0        10.10.10.246     Tue Feb 17 13:29 - 19:29  (06:00)
reboot   system boot  3.10.0-123.20.1. Tue Feb 17 13:28 - 17:20 (2+03:51)
```

The **root** account is the most privileged account on a Linux/UNIX system. This account has the ability to carry out all facets of system administration, including adding accounts, changing user passwords, examining log files, installing software, etc. 

A regular account user can perform some operations requiring special permissions; however, the system configuration must allow such abilities to be exercised. Running a network client or sharing a file over the network are operations that do not require a root account.

In Linux you can use either ``su`` or ``sudo`` commands to temporarily grant root access to a normal user; these methods are actually quite different. When using the ``su`` command:

* to elevate the privilege, you need to enter the root password. Giving the root password to a normal user should never, ever be done
* once a user elevates to the root account, the normal user can do anything that the root user can do for as long as the user wants, without being asked again for a password
* there are limited logging features

When using the ``sudo`` command:

* you need to enter the user’s password and not the root password
* what the user is allowed to do can be precisely controlled and limited; by default the user will either always have to keep giving their password to do further operations with ``sudo``, or can avoid doing so for a configurable time interval
* detailed logging features are available

### The sudo command
Granting privileges using the ``sudo`` command is less dangerous than ``su`` and it should be preferred. By default, ``sudo`` must be enabled on a per-user basis. However, some distributions (such as Ubuntu) enable it by default for at least one main user, or give this as an installation option. To execute just one command with root privilege type ``sudo <command>``. When the command is complete you will return to being a normal unprivileged user. The ``sudo`` configuration files are stored in the ``/etc/sudoers`` file and in the ``/etc/sudoers.d/`` directory. By default, that directory is empty.

The ``sudo`` command has the ability to keep track of unsuccessful attempts at gaining root access. An authentication failure message would appear in the ``/var/log/secure`` log file  when trying to execute sudo bash without successfully authenticating the user

```
# tail /var/log/secure
authentication failure; logname=op uid=0 euid=0 tty=/dev/pts/6 ruser=op rhost= user=op
conversation failed
auth could not identify password for [op]
op : 1 incorrect password attempt ;
TTY=pts/6 ; PWD=/var/log ; USER=root ; COMMAND=/bin/bash
```

Whenever the ``sudo`` command is invoked, a trigger will look at ``/etc/sudoers`` and the files in ``/etc/sudoers.d`` to determine if the user has the right to use ``sudo`` and what the scope of their privilege is. Unknown user requests and requests to do operations not allowed to the user even with ``sudo`` are reported. You can edit the sudoers file by using the ``visudo`` command, which ensures that only one person is editing the file at a time, has the proper permissions, and refuses to write out the file and exit if there is an error in the changes made.

The basic structure of an entry is:
> who where = (as_whom) what

To create a normal user account and give it sudo access, login as root user and edit the ``/etc/sudoers`` file with the ``visudo`` command. Find the lines in the file that grant ``sudo`` access to users in the group ``wheel`` when enabled.
```
## Allows people in group wheel to run all commands
# %wheel        ALL=(ALL)       ALL
```
Remove the comment character at the start of the second line. This enables the configuration option. Save your changes. Add the user you created to the ``wheel`` group.
```
# usermod -aG wheel adriano
# su adriano -
$ groups
adriano wheel
$ sudo whoami
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for adriano:
root
```
If sudo is configured correctly the last line value will be ``root``.

Some Linux distributions prefer you add a file in the directory ``/etc/sudoers.d`` with a name the same as the user. This file contains the individual user's sudo configuration, and one should leave the master configuration file untouched except for changes that affect all users.

### The process isolation
Linux is considered to be more secure than many other operating systems because processes are naturally isolated from each other. One process normally cannot access the resources of another process, even when that process is running with the same user privileges. Additional security mechanisms that have been recently introduced in order to make risks even smaller are:

1. **Control Groups**: allows system administrators to group processes and associate finite resources to each group (**cgroup**).
2. **Linux Containers**: makes it possible to run multiple isolated Linux systems containers on a single system.
3. **Virtualization**: hardware is emulated in such a way that not only processes can be isolated, but entire systems are run simultaneously as isolated and insulated guests (**virtual machines**) on one physical host.

### Password encryption
Protecting passwords has become a crucial element of security. Most Linux distributions rely on a modern password encryption algorithm called SHA-512 (Secure Hashing Algorithm 512 bits), developed by the U.S. National Security Agency (NSA) to encrypt passwords. The SHA-512 algorithm is widely used for security applications and protocols. These security applications and protocols include TLS, SSL, PHP, SSH, S/MIME and IPSec. SHA-512 is one of the most tested hashing algorithms.

### Password aging
The password aging is a method to ensure that users get prompts that remind them to create a new password after a specific period. This can ensure that passwords, if cracked, will only be usable for a limited amount of time. This feature is implemented using the ``chage`` command, which configures the password expiry information for a user.
```
# chage --list adriano
Last password change                                    : Feb 18, 2015
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7
```

## Public/Private keys authentication
Public Key Encryption let clients and server to trust each other without exchanging any key. A private key is installed on the server and a public key is shared between clients. The private key has to be kept secured, the public key can be freely distributed among clients. And the two keys are mathematically keyed to one another. The public key has to be authorized to the server, so any client would be connect, has to have the authorized public key.

Using encrypted keys for authentication offers other two main benefits. Firstly, it is convenient as you no longer need to enter a password if you use public/private keys. Secondly, once public/private key pair authentication has been set up on the server, you can disable password authentication completely meaning that without an authorized key you can't gain access.

Create a private key for client and a public key for server to do it
```
# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.

# cd /root/.ssh
# ll
total 8
-rw------- 1 root root    0 May 30 11:17 authorized_keys
-rw------- 1 root root 1675 May 30 11:17 id_rsa
-rw-r--r-- 1 root root  396 May 30 11:17 id_rsa.pub
-rw-r--r-- 1 root root    0 May 30 11:07 known_hosts
# chmod 700 ~/.ssh
# chmod 600 ~/.ssh/id_rsa
```

This will create two files in your hidden ssh directory called: ``id_rsa`` and ``id_rsa.pub`` The first is your private key and the other is your public key. Install the public key to the authorized keys list and then remove it from the server
```
# cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# rm -rf ~/.ssh/id_rsa.pub
```

Copy the private key on the client that you will use to connect to the server and then remove it from the server
```
# scp ~/.ssh/id_rsa root@clientmachine:root/.ssh/
# rm -rf ~/.ssh/id_rsa
```

Use the private key to login to the server
```
# ssh -i ~/.ssh/id_rsa root@servermachine
```

Please, note that each user that want to login must have his own key pair.


## SSL/TLS Security
**Transport Layer Secirity**, or **TLS**, and its predecessor **Secure Sockets Layer**, or **SSL**, are protocols used to wrap normal traffic in a protected, encrypted wrapper. Using this technology, http servers can send traffic safely between the server and the client without the concern that the messages will be intercepted and read by an outside party. The certificate system also assists users in verifying the identity of the sites that they are connecting with.

In this section, we will set up a self-signed SSL certificate for use with an Apache web server. A self-signed certificate will encrypt communication between server and any clients. However, because it is not signed by any of the trusted certificate authorities by web browsers, users cannot use the certificate to validate the identity of your server and their browsers will prompt for a securty risk.

A self-signed certificate is more appropriate when you do not have a domain name associated with server and/or the server provides APIs interfaces to any other service.

Install the SSL on the CentOS machine

    yum install -y openssl
    
    openssl version
    OpenSSL 1.0.1e-fips 11 Feb 2013

    mkdir -p ./tls
    cd tls

### Create Certification Authority certificate and key
Create a CA key file ``ca-key.pem`` with an encrypted passphrase

    openssl genrsa -aes256 -out ca-key.pem 4096
    
    Generating RSA private key, 4096 bit long modulus
    .....++
    ........++
    e is 65537 (0x10001)
    Enter pass phrase for ca-key.pem:
    Verifying - Enter pass phrase for ca-key.pem:

This file just created, is the key used in the process to sign the server certificates against the Certification Authority. It is NOT the private key used in the client/server communication. We'll create this key later.

To inspect the key

    openssl rsa -in ca-key.pem -text

If you are interested in to extract the public part from this key, use the command

    openssl rsa -in ca-key.pem -pubout

Now create the CA certificate ca.pem file using the key above

    openssl req -new -x509 -days 3650 -key ca-key.pem -sha256 -out ca.pem
    ...
    -----
    Country Name (2 letter code) [XX]:IT
    State or Province Name (full name) []:Italy
    Locality Name (eg, city) [Default City]:Milan
    Organization Name (eg, company) [Default Company Ltd]:My Own Certification Authority
    Organizational Unit Name (eg, section) []:
    Common Name (eg, your name or your server's hostname) []:
    Email Address []:

This is an interactive process, asking for information about the Certificate Authority. Since we're creating our own Certification Authority, no too much constraints here.

Inspect the certificate

    openssl x509 -in ca.pem -noout -text
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number: 15423805392213301438 (0xd60c5d490fa0d8be)
        Signature Algorithm: sha256WithRSAEncryption
            Issuer: C=IT, ST=Italy, L=Milan, O=My Own Certification Authority
            Validity
                Not Before: Aug  9 09:29:01 2017 GMT
                Not After : Aug  7 09:29:01 2027 GMT
            Subject: C=IT, ST=Italy, L=Milan, O=My Own Certification Authority
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (4096 bit)

As convenience, we set the validity of this certificate as for 10 years.

### Create certificate and key for the server
Create the private key ``server-key.pem`` file for our web server

    openssl genrsa -out server-key.pem 4096

    Generating RSA private key, 4096 bit long modulus
    ....................++
    ..++
    e is 65537 (0x10001)

Please note, we are not using a passphrase for the server key. 

Once we have the private key ``server-key.pem``, we can proceed to create a **Certificate Signing Request**, or **CSR** as ``server.csr`` file. This is a formal request asking the Certification Authority to sign the server certificate. The request needs the private key ``server-key.pem`` of the requesting entity and some information about the entity.

Create the request

    HOST=centos
    openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

Make sure that Common Name (**CN**) matches the hostname of the server.

Once we created the certificate signing request, we can issue the request against the Certification Authority

    openssl x509 -req -days 3650 -sha256 -in server.csr \
                 -CA ca.pem \
                 -CAkey ca-key.pem \
                 -CAcreateserial -out server.pem

This will produce the ``server.pem`` certificate file containing the public key. Together with the ``server-key.pem`` file, this makes up a server's keys pair.

Move the server's keys pair to a given location where the web server is able to access

    mv server-cert.pem /etc/httpd/ssl/server.pem
    mv server-key.pem /etc/httpd/ssl/server-key.pem

We'll instruct the http server to use these files. To improve secutity, make sure the private key file will be safe, e.g. changing the file permissions.

    chmod 400 /etc/httpd/ssl/*

### Configure the web server for TLS/SSL
Install the web server with TLS/SSL support, e.g. apache, and configure it to serve on port 443.

    yum -y install httpd
    yum -y install mod_ssl
    
Edit the ``/etc/httpd/conf.d/ssl.conf`` configuration file at default virtual host section

    <VirtualHost _default_:443>
        DocumentRoot "/var/www/html"
        ServerName centos:443
        ...
        SSLCertificateFile /etc/httpd/ssl/server.pem
        SSLCertificateKeyFile /etc/httpd/ssl/server-key.pem
    </VirtualHost>

Make sure the certificate and key location are the same where we them moved before.

Restart the web server

    systemctl start httpd
    
To check the server is serving on secure port, point the browser on https://centos:443 or use the curl tool

    curl --cacert ca.pem https://centos
    It Works!

If we try to use the IP address instead of the server name

    curl --cacert ca.pem https://10.10.10.1
    curl: (51) Unable to communicate securely with peer:
               requested domain name does not match the server's certificate.

We get a TLS rror since the requested domain in the http request, is different than the name, i.e. ``centos`` we set in the Common Name field certificate. 

    openssl x509 -in server-cert.pem -noout -text

    Certificate:
        Data:
            Version: 1 (0x0)
            Serial Number: 12933182947807180877 (0xb37be55e3b2fb84d)
        Signature Algorithm: sha256WithRSAEncryption
            Issuer: C=IT, ST=Italy, L=Milan, O=My Own Certification Authority
            Validity
                Not Before: Aug  9 09:56:28 2017 GMT
                Not After : Aug  7 09:56:28 2027 GMT
            Subject: CN=centos
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (4096 bit)


This is a common issue with TLS certificates, especially when running services that expose different hostnames. In the next section, we'll create a certificate for multiple hostnames.

### Creating Certificates for multiple hostnames
By default, certificates have only one Common Name (**CN**) and are valid for only one hostname. Because of this, having a service with multiple hostnames or IP adresses, we are forced to use a separate certificate for each of them. In this situation, using a single multidomain certificate makes much more sense. For this example, create an estention file ``mysite.cnf`` with the following content

    [names]
    subjectAltName = DNS.0:localhost, IP.0:127.0.0.1, DNS.1:centos, IP.1:10.10.10.1

Now sign the certificate again by including the estention file

    openssl x509 -req -days 3650 -sha256 -in server.csr \
                 -CA ca.pem \
                 -CAkey ca-key.pem \
                 -CAcreateserial -out server.pem \
                 -extfile "site.cnf" -extensions names

When a certificate contains alternative names, the Common Name set in the request (.csr) is ignored. For this reason, include all desired hostnames on the alternative names configuration file.

Now inspect the new server certificate
```
openssl x509 -in server.pem -noout -text

Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 12933182947807180878 (0xb37be55e3b2fb84e)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=IT, ST=Italy, L=Milan, O=My Own Certification Authority
        Validity
            Not Before: Aug  9 10:32:19 2017 GMT
            Not After : Aug  7 10:32:19 2027 GMT
        Subject: CN=centos
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Alternative Name:
                DNS:localhost, IP Address:127.0.0.1,
                DNS:centos, IP Address:10.10.10.1
    Signature Algorithm: sha256WithRSAEncryption
    ...
```

Move both the new key and certificate to the location where the server is expecting them.

Restart the server and access it via curl command

     curl --cacert ca.pem https://centos
      It Works!

     curl --cacert ca.pem https://10.10.10.1
      It Works!
      
     curl --cacert ca.pem https://localhost
      It Works!
      
## The CloudFlare TLS toolkit
In this section, we are going to use the **CloudFlare** TLS toolkit for helping in TLS certificate creation. Details on this tool are [here](https://github.com/cloudflare/cfssl).

Install the tool

        wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
        wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

        chmod +x cfssl_linux-amd64
        chmod +x cfssljson_linux-amd64

        mv cfssl_linux-amd64 /usr/local/bin/cfssl
        mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

Create a Certification Authority configuration file ``ca-config.json`` as following

```json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "custom": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
```

Create the configuration file ``ca-csr.json`` for the Certification Authority signing request

```json
{
  "CN": "NoverIT",
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
    {
      "C": "IT",
      "ST": "Italy",
      "L": "Milan",
      "O": "My Own Certification Authority"
    }
  ]
}
```

Generate a CA certificate and private key:

    cfssl gencert -initca ca-csr.json | cfssljson -bare ca

As sesult, we have following files

    ca-key.pem
    ca.pem

They are the key and the certificate of our self signed Certification Authority.

### Create certificate and key for the server
Create the configuration file ``server-csr.json`` for server certificate signing request

```json
{
  "CN": "docker-engine",
  "hosts": [
    "centos",
    "10.10.10.1",
    "127.0.0.1",
    "localhost"
  ],
  "key": {
    "algo": "rsa",
    "size": 4096
  }
}
```

Create the key pair

    cfssl gencert \
       -ca=ca.pem \
       -ca-key=ca-key.pem \
       -config=ca-config.json \
       -profile=custom \
       server-csr.json | cfssljson -bare server

This will produce the ``server.pem`` certificate file containing the public key and the ``server-key.pem`` file, containing the private key. Move the server's keys pair to a given location where the http server is expecting them.

Restart the https server.





