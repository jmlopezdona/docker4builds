Options to run the e2e tests on Saucelabs' webdriver server:

A. Run tests on the Saucelabs' servers with the app deployed on a public server:

Enable (and disable) this options in protractor.config file:

```javascript
baseUrl: 'http://jmlopezdona.github.io/seed-app-ionic/',
//baseUrl: 'http://localhost:8100/',

sauceUser: process.env.SAUCE_USERNAME,
sauceKey: process.env.SAUCE_ACCESS_KEY,
sauceSeleniumAddress: 'ondemand.saucelabs.com:80/wd/hub',
//seleniumAddress: 'http://192.168.1.38:4444/wd/hub',
//seleniumServerJar: './node_modules/protractor/selenium/selenium-server-standalone-2.48.2.jar',
//directConnect: true,
```

Set these system variables:

```bash
export SAUCE_USERNAME=<yours username in saucelabs>
export SAUCE_ACCESS_KEY=<acccess key field in https://saucelabs.com/beta/user-settings>
```

And run (before you must publish www folder in a public domain, like github pages)

```bash
gulp e2e
```

B. Run tests on the Saucelabs' servers using Saucelabs Connect (SC), a tunnel than let you to test your local app without publish it on a public server:

Run SC in your machine:

```bash
./sc -u <SAUCE_USERNAME> -k <SAUCE_ACCESS_KEY> &

```

Enable (and disable) this options in protractor.config file:

```javascript
baseUrl: 'http://jmlopezdona.github.io/seed-app-ionic/',
//baseUrl: 'http://localhost:8100/',

sauceUser: process.env.SAUCE_USERNAME,
sauceKey: process.env.SAUCE_ACCESS_KEY,
sauceSeleniumAddress: 'localhost:4445/wd/hub'
//seleniumAddress: 'http://192.168.1.38:4444/wd/hub',
//seleniumServerJar: './node_modules/protractor/selenium/selenium-server-standalone-2.48.2.jar',
//directConnect: true,
```

Set theses system variables:

```bash
export SAUCE_USERNAME=<yours username in saucelabs>
export SAUCE_ACCESS_KEY=<acccess key field in https://saucelabs.com/beta/user-settings>
```

And run (before you can to publish www folder in a public domain, like github pages)

```bash
gulp e2e --standalone --mocks
```

---

TODO: see sauce-tunnel npm plugin
