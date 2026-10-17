# Day 2: Permissions and Log Analysis

## What I learned
- What 755, 644 and 600 mean, in my own words
- How grep, awk, sort and uniq work together

## Commands I used
| Question | Command | Result |
|---|---|---|
| Top IPs by request count | `awk '{print $1}' access.log \| sort \| uniq -c \| sort -rn` | Three IPs tied at 3 requests |
| Requests with status >= 400 | `awk '$8 >= 400' access.log \| wc -l` | 7 |
| Suspicious probing | `grep -E "\.env\|wp-login" access.log` | 203.0.113.7 |

## Security observations
- 10.0.0.5 got 403 on /admin and 401 on /login: possible unauthorized access attempt
- 203.0.113.7 probed /.env and /wp-login.php: looks like reconnaissance

## Mistakes I made and what I learned
- `awk'{print $1}'` failed because there was no space after awk
- `uniq` alone gives wrong counts because it only compares adjacent lines


