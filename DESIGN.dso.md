# The Decline and Fall of DSO

## Target Audiences

1. Server owners
1. Website owners
1. Maintenance and security teams
1. Training and technical support
1. Managers and other internal key stakeholders
1. Future project/feature owners/maintainers

## What is DSO?

For PHP, DSO is a handler that allows Apache to serve PHP. It became popular because it was easy to use (arguably moot due to sweet tools like WHM and cPanel) and the fastest way to handle PHP (that last bit is no longer true). It has become the least preferable since it runs as the webserver which is a security issue.

## Detailed Summary

As of PHP 8, PHP decided to drop the major version from its `.so` and its symbols.

That will not work out of the box with our systems because they rely on on the consistent naming to do the right thing.

For example, if a user edits a PHP INI directive we write them all to `php.ini`, any supported ones to `.user.ini`, any supported ones to `.htaccess`. That way when their handler changes their PHP has the best chance of behaving the same as it was. In `.htaccess` we put any directives that 5 supported in an `IfModule` for 5, The directives that 7 supported in an `IfModule`, and 8 would get that treatment also. If we changed that to a single major-version agnositic `IfModule` and a 7 only diredtive where added while sitching to/running 8 there would be an error.

### References:

| PHP Version | Symbols/Files✻ |
| ----------- | ------------- |
| 4 | mod_php4.c libphp4.so php4_module |
| 5 | mod_php5.c libphp5.so php5_module |
| 7 | mod_php7.c libphp7.so php7_module |
| 8 expected | mod_php8.c libphp8.so php8_module |
| 8 actual | mod_php.c libphp.so php_module |

* Making it major agnostic started here: https://github.com/php/php-src/commit/6e3600f41b95d97d11ef48f817e6389a4ee95091
* Which caused this bug: https://bugs.php.net/bug.php?id=78681
* Which was addressed here: https://github.com/php/php-src/commit/ad53bacf3872c22919fc2620112ae64917f1c26a
* Follow up discusson here: https://news-web.php.net/php.internals/112219

**✻** renaming the file or symlinking the one we want to the one that exists won’t work due the symbols not matching (e.g. for `LoadModule` and `IfModule` statements).

## Overall Intent

To determine how to address the PHP 8 DSO problem.

## Maintainability

Estimate:

1. how much time and resources will be needed to maintain the feature in the future
2. how frequently maintenance will need to happen

This information will be in the table below for each option.

## Options/Decisions

| Name | Pros | Cons | Maint. Effort | Maint. Freq |
| ---- | ---- | ---- | ------------- | ----------- |
| Drop DSO in 8 | 1 line change in RPM, removes a security issue, encourages use of more modern/secure way to run PHP | None | None | Never |
| Patch PHP 8 to undo upstream’s change | Fairly simple RPM change (add patch that reverts the two SHAs noted above in “References”), will just work w/ no ULC changes | We have to maintain this patch in future PHP versions as long as they do | Effort may increase as PHP code changes (its automated unless they make drastic changes) | every new version of PHP |
| Embrace the change | Keeping up with upstream | Pretty involved ULC change (w/ backports/autofixers for pre 94 ones required), probably changes to all PHP RPMs prior to 8, what happens when PHP decides this is a mistake and undoes it? 💥  | Minimal, will fall off as RPMs go EOL | Anytime a PHP updates the ones prior to 8 will need patches updated. Mostly automated but requires more effrot when it can’t do it automatcally. |

### Conclusion

Let’s “Drop DSO in 8” for now, and if there is a large push to reinstate it, then revisit our options starting with the simpler “Patch PHP 8 to undo upstream’s change”.

## Child Documents

None.
