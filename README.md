# drupal-docker

Docker development environment for Drupal.

## Setup

1. Clone this repo to your project directory.
2. Download a Drupal composer project to a subfolder called `drupal` and run `composer install`. The docker-compose config expects the document root to be found at `drupal/web`, but you can change this to something else (such as `drupal/www`) if your composer project uses a different folder name.
3. Run the following command to build and start the httpd server:
```
sudo USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose up httpd
```
`USER_ID` and `GROUP_ID` are used to recreate the container's user with the same user and group ID as the user on the host. This is important because it means that any new files created by PHP-FPM, Drush or Drupal Console will be created as if they belong to the host user, not root.

For convenience, this command is included as a script called `dockup`, which you can move to a folder in your system's `PATH`. There is also a script called `dockdn` that simply calls `sudo docker-compose down`. By adding these scripts to your `PATH`, you can call them from anywhere in your project folder.

## Using the CLI utilities, Drush, Drupal Console, and PHPUnit

For convenience, a script called `dockrun` is included that runs `sudo docker-compose run --rm`, and takes care of setting `USER_ID` and `GROUP_ID`.

### Drush

```bash
# Get the status of your site.
dockrun phpcli drush st
```

### Drupal Console

```bash
# Generate a module.
dockrun phpcli drupal generate:module
```

### PHPUnit

```bash
# Run tests for a custom module.
dockrun phpcli phpunit --group="mymodule"
```

## Using XDebug

The XDebug config in `etc/php/xdebug.ini` is set to use VSCODE by default. To use a different editor, just change the IDE key.

If you want to enable logging, uncomment the `xdebug.remote_log` setting.

### VS Code config

Add this configuration to your project's `.vscode/launch.json` to listen for XDebug

```json
{
  "name": "Listen for XDebug",
  "type": "php",
  "request": "launch",
  "port": 9000,
  "pathMappings": {
    "/var/www/drupal": "${workspaceFolder}/drupal"
  }
}
```
