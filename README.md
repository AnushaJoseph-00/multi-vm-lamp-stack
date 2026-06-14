# Multi-VM LAMP Stack

A classic **LAMP** web application split across **two virtual machines** on a private network, provisioned with Vagrant manually. The web tier (Apache + PHP) runs on one VM and connects across a private network to the data tier (MariaDB) on a second VM.

This is an **infrastructure project**: the focus is provisioning, networking, and service configuration. The small PHP page is a sample workload that proves the two tiers are connected.

## Tech stack

- **Vagrant + Oracle VirtualBox** — infrastructure as code, reproducible VMs
- **Ubuntu 22.04 (Jammy)** — the Linux base
- **Apache2** — web server
- **PHP** (`libapache2-mod-php`, `php-mysql`) — dynamic page + DB access
- **MariaDB** — relational database

## How to run

Requires VirtualBox and Vagrant on the host.

Then configure each VM by hand (see `SETUP.md` for the full walkthrough):

- **db VM:** install MariaDB, set `bind-address = 0.0.0.0`, create the database/user/table.
- **web VM:** install Apache + PHP, deploy `app/index.php` to `/var/www/html/`.

git clone https://github.com/AnushaJoseph-00/multi-vm-lamp-stack.git
cd multi-vm-lamp-stack
vagrant up

Open **http://localhost:8080** on the host to use the app.

## Key concepts demonstrated

- **Two-tier Virtual Machine** — web and data tiers on two separate virtual machine.
- **Private networking** — VMs communicate over a host-only network; the database is never exposed to the public internet.
- **Remote database access** — MariaDB `bind-address` changed from `127.0.0.1` (localhost only) to listen on the private network.
- **Least-privilege database user** — the app user is granted access only from the `192.168.56.%` subnet, not from anywhere.
- **Service management** — Apache and MariaDB run as managed system services.
- **Secure PHP** — prepared statements (SQL-injection safe) and output escaping (XSS safe).
- 
## Key Takeaways

This project was built and configured entirely manually  to understand each layer, not just to get a working result. I beleive before diving into automation gaining manual execution of these VMs will give strong foundational knowlege for DevOps skills

**Architecture**
- Built a **two-tier architecture**: the web tier (Apache + PHP) and the data tier (MariaDB) run on separate VMs, the way real systems separate concerns for scalability and security.
- Traced the full request path end to end: browser → Apache → PHP → private network → MariaDB → back to the browser.

**Networking**
- Connected two VMs over a **private (host-only) network** so they communicate without touching the public internet.
- Changed MariaDB's `bind-address` from `127.0.0.1` (localhost only) to listen on the private network — the key setting that makes cross-VM database access work.

**Security**
- Applied **least privilege**: the database user is granted access only from the `192.168.56.%` subnet, not from anywhere.
- Kept the database **off the public path** — only the web VM can reach it.
- Used **prepared statements** (SQL-injection safe) and **output escaping** (XSS safe) in the PHP.
- Excluded machine state and **private keys** (`.vagrant/`) from version control — secrets never belong in a repository.

**Operations**
- Provisioned reproducible VMs with **Vagrant** (infrastructure as code).
- Installed and managed **Apache** and **MariaDB** as system services.
- Practised real troubleshooting: editor navigation, service restarts, and resolving Git issues (unrelated histories, accidental staging of secrets).

**Skills:** `Linux` · `Vagrant` · `VirtualBox` · `Apache` · `PHP` · `MariaDB` · `networking` · `infrastructure as code` · `service configuration` · `Git`

> This is a hands-on infrastructure lab built locally. Its value is in the provisioning, networking, and configuration work — the PHP page is a small sample workload that proves the two tiers are connected.
