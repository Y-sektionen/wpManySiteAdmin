# Keeping Wordpress and HTTPS certificates updated

The scripts for updating Wordpress and the HTTPS certificates are preferrably scheduled using crontab or some other scheduling mechanism native to your system of choice.

## Cron

Enter the cron table for the root account:

```bash
sudo crontab -e
```

Then add these lines to check for wordpress updates once a day, and renew https certificates once a month:

```crontab
min hour * * * /PATH/TO/PROJECT/DIR/update/wordpress
min hour 1 * * /PATH/TO/PROJECT/DIR/update/renew-https-certs
```
