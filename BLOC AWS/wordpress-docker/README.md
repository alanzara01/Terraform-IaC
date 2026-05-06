# WordPress + MySQL avec Docker sur AWS

Un déploiement simple de WordPress utilisant Docker Compose sur une instance EC2.

## Structure

- Une instance EC2 t2.micro
- Docker et Docker Compose installés dans l'instance
- WordPress et MySQL dans des conteneurs Docker
- Exposed sur le port 80

## Déploiement

```bash
cd "c:\terraform\BLOC AWS\wordpress-docker"
terraform init
terraform plan -out=tfplan
terraform apply "tfplan"
```

## Accès

Après le déploiement (attendez 2-3 minutes pour que les conteneurs se lancent) :

```
http://<public_ip>
```

L'URL exacte sera dans l'output `wordpress_url`.

## Identifiants WordPress

- Utilisateur: admin
- Mot de passe: À créer lors de la première configuration
- Base de données: wordpress
- Utilisateur DB: wordpress
- Mot de passe DB: wordpress123

## SSH

Pour vérifier les conteneurs :

```bash
ssh -i deployer-key.pem ec2-user@<public_ip>
docker-compose ps
```
