# strato-certbot
Wildcard certificates for strato.de

## Setup

Create `strato-auth.json`:

```json
{
  "api_url": "https://www.strato.de/apps/CustomerService",
  "username": "<username>",
  "password": "<password>"
}
```

The api url needs to be filled with the correct url from your country. 
So as an example for Germany its 'https://www.strato.de/apps/CustomerService', but for the Netherlands its 'https://www.strato.nl/apps/CustomerService#skl'

Make sure to make this file only readable for root:

`sudo chmod 0400 strato-auth.json`

### Two-Factor Authentification

To be able to authenticate two-factor, device name and TOTP secret must be entered into the JSON. If it is not used, it can either be empty strings or the entries can be removed completely (see above).

```json
{
  "api_url": "https://www.strato.de/apps/CustomerService",
  "username": "<username>",
  "password": "<password>",
  "totp_secret": "<secret>",
  "totp_devicename": "<devicename>"
}
```

### Waiting time

Sometimes it takes a while until the desired DNS record is published, which allows Certbot to verify the domain. To prevent this, a waiting time can be set.

```json
{
  "api_url": "https://www.strato.de/apps/CustomerService",
  "username": "<username>",
  "password": "<password>",
  "waiting_time": <seconds>
}
```

## Docker

The Dockerfile wraps these hook scripts into a certbot runtime.
You can/should map a volume or a host path into the container /etc/letsencrypt(/live) in order to get the certificates.
The container by default is not generating anything, instead only checking periodically (once a day at 3am) for certificate renewal.
In order to generate a certificate for your domain including a wildcard one, execute the following command in the running container:
```bash
docker exec strato_certbot_ct create-new-wildcard-cert.sh my-domain.de webmaster@my-domain.de
```
If successful, this will generate the certificates for you and renew them automatically when needed

### Setup

Create a strato-auth.json file based on the [template](samples/strato-auth.json.sample)

### Build

Run `./build.sh`

### Run

Run `./run.sh` which will build and start the container in detached mode using docker-compose

