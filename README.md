# Uberspace Let's Encrypt Manager

This is a very simple script to automate the process of getting and renewing multiple SSL certificates for multiple domains on Uberspace.

### Reasoning

Utilizing Let's Encrypt on Uberspace is [very easy](https://wiki.uberspace.de/webserver:https#let_s-encrypt-zertifikate). Sadly there's one flaw: By default, all domains registered on your Uberspace are included in one certificate. This is a major privacy issue as it could reveal private domains or even domains you're not officially affiliated with.  
That's why I created the letsencrypt-mgr.sh.

### Howto

Create a file `~/etc/letsencrypt_domains.conf` with every domain you want to have in one certificate per line, e.g.:
```bash
1st.domain.tld,2nd.domain.tld
my.single.tld
my.other.tld,and.another.tld
```

Then just put the script into your crontab, e.g.:
```bash
23 3 * * 5 /home/your-uberspace-user/path/to/script/letsencrypt-mgr.sh > ~/tmp/letsencrypt-mgr.log
```

I recommend using `keep-until-expiring = True` in your `cli.ini` to avoid running into Let's Encrypts [Rate Limiting](https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769). Also consider using `staging = True` while testing the script for similar reasons.

It's possible to override every variable defined in the script to change its functionality.

### Disclaimer

This script works. I haven't put a lot of thought or time into it, so it's not unlikely the way the script works is overly complicated (`letsencrypt -c` seems to be an easier way), but it works.
