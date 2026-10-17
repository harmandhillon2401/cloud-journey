# Day 2: Permissions and Log Analysis

cd ~/cloud-journey/week1
cat > day2-notes.md << 'EOF'
# Day 2: Permissions and Log Analysis

## What I learned
- `chmod 640` gives the owner read+write (4+2=6), the group read-only (4), and others nothing (0).
- `chmod 755` gives the owner read+write+execute (7), and the group and others read+execute (5), so only the owner can modify the file.
- `chmod 600` gives the owner read+write (4+2=6) and nobody else any access. It has no execute bit, which is right for a private key.
- The `d` at the start of `drwxr-xr-x` means the entry is a directory. A regular file starts with `-`.
- `>` overwrites a file and `>>` appends to it, so `>` can silently erase old content.
- `uniq -c` only compares neighbouring lines, so the input must go through `sort` first or the counts are wrong.
- A pipe (`|`) sends one command's output into the next command as input.

## Commands I used
| Question | Command | Result |
|---|---|---|
| Top IPs by request count | `awk '{print $1}' access.log \| sort \| uniq -c \| sort -rn` | Three IPs tied at 3 requests (10.0.0.5, 192.168.1.10, 203.0.113.7) |
| Requests with status >= 400 | `awk '$8 >= 400' access.log \| wc -l` | 7 (3 auth errors: 403/401, 3 not found: 404, 1 server error: 500) |
| Suspicious probing | `grep -E "\.env\|wp-login" access.log` | 203.0.113.7 |

## Security observations
- 10.0.0.5 got two 403s on /admin and a 401 on /login, which looks like an unauthorized access attempt. Next step: check whether it keeps retrying and consider blocking it at the firewall.
- 203.0.113.7 requested /.env and /wp-login.php, which are common targets in reconnaissance scans. Next step: check its other requests and block it if it keeps probing.

## Experiment: SSH key permissions
- I copied my private key to /tmp, set it to `644`, and tried to connect to GitHub.
- SSH printed "UNPROTECTED PRIVATE KEY FILE", said the key would be ignored, and returned `Permission denied (publickey)`.
- After `chmod 600` the same key authenticated successfully.
- The key itself never changed. At `644` other users could read it, so SSH treated it as possibly compromised. At `600` only I can read it.

## Mistakes I made and what I learned
- `awk'{print $1}'` failed because there was no space after `awk`.
- `cd~` failed for the same reason: it needs `cd ~`.
- `grep -i access.log` hung because I gave it no file to search, so it waited for input. Ctrl+C gets out.
- `uniq` alone gives wrong counts because it only compares adjacent lines.
- I created files in the repo root instead of `week1/`, so `git add week1/` failed. Check with `pwd` before using relative paths.
- `chmod +x` without a filename gave "missing operand".
- I typed a command as the answer to the `ssh-keygen` prompt. Answer only the question being asked.
- I ran Linux commands in PowerShell. The prompt shows which shell I'm in.

## What I'm still unsure about
- How awk numbers fields when a log line has extra spaces.
EOF
cat day2-notes.md
