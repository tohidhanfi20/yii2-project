# Yii2 Dockerized Deployment with Ansible, Prometheus, and Grafana

## Overview

This project demonstrates a CI/CD pipeline for a Yii2 PHP application using Docker, Docker Swarm, Ansible, Prometheus, and Grafana, with GitHub Actions for automation.

---
## Initial Setup

1. **Update Ansible Inventory**  
   Edit `ansible/inventory.ini` and replace the placeholder with your server’s public IP or DNS name:
[web]
your.server.ip.address ansible_user=ubuntu

2. **Configure SSH Keys**  
Generate an SSH key pair (if you don’t have one):
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"


Add the public key (`id_rsa.pub`) to the `~/.ssh/authorized_keys` file on your server:
cat ~/.ssh/id_rsa.pub | ssh ubuntu@your.server.ip.address 'cat >> ~/.ssh/authorized_keys'

Add the private key (`id_rsa`) as a GitHub Actions secret named `SSH_PRIVATE_KEY`.

3. **Set Up GitHub Actions Secrets**  
Go to your GitHub repository → Settings → Secrets and variables → Actions and add:
- `DOCKER_USERNAME` — your Docker Hub username
- `DOCKER_PASSWORD` — your Docker Hub password or access token
- `SSH_PRIVATE_KEY` — your private SSH key (from above)
- `EC2_USER` — the SSH username for your server (e.g., `ubuntu` for AWS EC2 Ubuntu)
- `SERVER_IP` — your server’s public IP (if referenced in your workflow)
- Any other secrets your workflow/playbook requires (e.g., `GRAFANA_ADMIN_PASSWORD`)

4. **Update Workflow and Playbook References**  
Make sure your workflow and playbook reference the correct inventory file and use the secrets as variables.

## Setup Instructions

### Prerequisites

- Docker & Docker Compose
- Ansible
- A server (e.g., AWS EC2) with SSH access
- Docker Hub account (for image push/pull)
- GitHub repository with secrets set for Docker Hub and SSH

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd <your-repo>
```

### 2. Build and run locally (optional)

```bash
docker-compose up --build
```

### 3. Configure Ansible

- Edit `ansible/inventory.ini` with your server IP/hostname.
- Ensure your SSH key and user are set in GitHub secrets.

### 4. Configure GitHub Actions

- Set secrets: `DOCKER_USERNAME`, `DOCKER_PASSWORD`, `SSH_PRIVATE_KEY`, `EC2_USER`, etc.

### 5. Push to main branch

- This triggers the workflow: builds, pushes image, runs Ansible to deploy.

---

## Assumptions

- The Yii2 app exposes `/metrics` for Prometheus scraping.
- The server is accessible via SSH and has Docker installed (or Ansible will install it).
- Docker Hub is used for image storage.

---

## How to Test Deployment

1. **Push code to main branch**  
   This triggers the CI/CD pipeline.

2. **Check GitHub Actions**  
   Ensure all steps complete successfully.

3. **Access the app**  
   Visit `http://<your-server-ip>/` in your browser.

4. **Check Prometheus**  
   Visit `http://<your-server-ip>:9090/targets` to see Node Exporter and app metrics.

5. **Check Grafana**  
   Visit `http://<your-server-ip>:3000/` (default user: admin/admin).

---

## Troubleshooting

- If deployment fails, check GitHub Actions logs and server logs.
- Ensure ports 80, 9000, 9090, and 3000 are open in your server firewall/security group.
- For Prometheus metrics, ensure `/metrics` endpoint is accessible from the server.

---

## Credits

- [Yii2](https://www.yiiframework.com/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Ansible](https://www.ansible.com/)
- [Docker](https://www.docker.com/)